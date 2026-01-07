import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../model/checklist_item.dart';
import '../../model/itinerary_activity.dart';
import '../../router/app_router.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String _channelId = 'itinerary_notifications';
  static const String _channelName = 'Itinerary reminders';
  static const String _channelDescription =
      'Notifications for itinerary activities';
  static const String _checklistChannelId = 'checklist_notifications';
  static const String _checklistChannelName = 'Checklist reminders';
  static const String _checklistChannelDescription =
      'Notifications for checklist items';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  String? _pendingPayload;

  Future<void> initialize() async {
    if (_initialized) return;

    if (!Platform.isAndroid) {
      _initialized = true;
      return;
    }

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      );
      await androidPlugin.createNotificationChannel(channel);
      const checklistChannel = AndroidNotificationChannel(
        _checklistChannelId,
        _checklistChannelName,
        description: _checklistChannelDescription,
        importance: Importance.high,
      );
      await androidPlugin.createNotificationChannel(checklistChannel);
    }

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _pendingPayload = launchDetails?.notificationResponse?.payload;
    }

    _initialized = true;
  }

  Future<void> handleInitialNotification() async {
    if (_pendingPayload == null) return;
    _openRouteFromPayload(_pendingPayload);
    _pendingPayload = null;
  }

  Future<void> scheduleItineraryNotifications(
    ItineraryActivity activity,
  ) async {
    if (!Platform.isAndroid) return;
    await initialize();

    final permissionGranted = await _ensureNotificationPermission();
    if (!permissionGranted) return;

    final scheduleMode = await _resolveAndroidScheduleMode();
    final now = DateTime.now();
    final eventTime = activity.combineDateTime;
    final hasReminder =
        activity.reminderEnabled && activity.reminderMinutesBefore > 0;
    final reminderTime =
        hasReminder ? activity.reminderNotificationDateTime : null;
    final details = _notificationDetails();
    final payload = _buildPayload(activity);

    if (eventTime.isAfter(now)) {
      await _plugin.zonedSchedule(
        _activityNotificationId(activity.activityId),
        'Itinerary activity',
        _buildActivityBody(activity),
        _toUtcTzDateTime(eventTime),
        details,
        androidScheduleMode: scheduleMode,
        payload: payload,
      );
    }

    if (hasReminder && reminderTime!.isAfter(now)) {
      await _plugin.zonedSchedule(
        _reminderNotificationId(activity.activityId),
        'Reminder',
        _buildReminderBody(activity),
        _toUtcTzDateTime(reminderTime),
        details,
        androidScheduleMode: scheduleMode,
        payload: payload,
      );
    }
  }

  Future<void> cancelItineraryNotifications(ItineraryActivity activity) async {
    if (!Platform.isAndroid) return;
    await initialize();

    await _plugin.cancel(_activityNotificationId(activity.activityId));
    await _plugin.cancel(_reminderNotificationId(activity.activityId));
  }

  void _onNotificationResponse(NotificationResponse response) {
    _openRouteFromPayload(response.payload);
  }

  Future<bool> _ensureNotificationPermission() async {
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final pluginGranted = await androidPlugin?.requestNotificationsPermission();
    if (pluginGranted == true) return true;

    final status = await Permission.notification.status;
    if (status.isGranted) return true;
    final request = await Permission.notification.request();
    return request.isGranted;
  }

  NotificationDetails _notificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    return const NotificationDetails(android: androidDetails);
  }

  NotificationDetails _checklistNotificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      _checklistChannelId,
      _checklistChannelName,
      channelDescription: _checklistChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    return const NotificationDetails(android: androidDetails);
  }

  Future<void> scheduleChecklistNotification(ChecklistItem item) async {
    if (!Platform.isAndroid) return;
    await initialize();

    if (!item.reminderEnabled || item.reminderTime == null) return;

    final permissionGranted = await _ensureNotificationPermission();
    if (!permissionGranted) return;

    final scheduleMode = await _resolveAndroidScheduleMode();
    final now = DateTime.now();
    final reminderTime = item.reminderTime!;
    if (!reminderTime.isAfter(now)) return;

    await _plugin.zonedSchedule(
      _checklistNotificationId(item.checklistItemId),
      'Checklist reminder',
      item.name,
      _toUtcTzDateTime(reminderTime),
      _checklistNotificationDetails(),
      androidScheduleMode: scheduleMode,
    );
  }

  Future<void> cancelChecklistNotification(ChecklistItem item) async {
    if (!Platform.isAndroid) return;
    await initialize();
    await _plugin.cancel(_checklistNotificationId(item.checklistItemId));
  }

  String _buildActivityBody(ItineraryActivity activity) {
    final location = activity.location?.trim();
    if (location == null || location.isEmpty) {
      return activity.name;
    }
    return '${activity.name} • $location';
  }

  String _buildReminderBody(ItineraryActivity activity) {
    return 'In ${activity.reminderMinutesBefore} minutes: ${activity.name}';
  }

  String _buildPayload(ItineraryActivity activity) {
    final dayDate = DateTime(
      activity.date.year,
      activity.date.month,
      activity.date.day,
    );
    return jsonEncode({
      'tripId': activity.tripId,
      'date': dayDate.toIso8601String(),
    });
  }

  void _openRouteFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map) return;
      final tripId = decoded['tripId'] as String?;
      final date = decoded['date'] as String?;
      if (tripId == null || date == null) return;
      final uri = Uri(
        path: '/trips/$tripId/agenda',
        queryParameters: {'date': date},
      );
      final route = uri.toString();
      if (appRouter.canPop()) {
        appRouter.push(route);
        return;
      }
      appRouter.go('/trips');
      Future<void>.delayed(Duration.zero, () {
        appRouter.push(route);
      });
    } catch (_) {
      return;
    }
  }

  tz.TZDateTime _toUtcTzDateTime(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime.toUtc(), tz.UTC);
  }

  Future<AndroidScheduleMode> _resolveAndroidScheduleMode() async {
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) {
      return AndroidScheduleMode.inexactAllowWhileIdle;
    }

    final canScheduleExact =
        await androidPlugin.canScheduleExactNotifications();
    if (canScheduleExact == true) {
      return AndroidScheduleMode.exactAllowWhileIdle;
    }

    final requested = await androidPlugin.requestExactAlarmsPermission();
    if (requested == true) {
      return AndroidScheduleMode.exactAllowWhileIdle;
    }

    return AndroidScheduleMode.inexactAllowWhileIdle;
  }

  int _activityNotificationId(String activityId) =>
      _notificationBaseId(activityId) * 2;

  int _reminderNotificationId(String activityId) =>
      _notificationBaseId(activityId) * 2 + 1;

  int _notificationBaseId(String activityId) {
    final normalized = activityId.replaceAll('-', '');
    final hex =
        normalized.length >= 8 ? normalized.substring(0, 8) : normalized;
    final parsed = int.tryParse(hex, radix: 16) ?? 0;
    return parsed & 0x3fffffff;
  }

  int _checklistNotificationId(String checklistItemId) {
    return _notificationBaseId(checklistItemId) + 0x40000000;
  }
}
