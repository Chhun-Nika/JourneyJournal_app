import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/service/notification_service.dart';
import '../../data/repository/itinerary_activity_repo.dart';
import '../../data/repository/trip.repo.dart';
import '../../model/itinerary_activity.dart';
import '../../model/trip.dart';
import '../shared/theme/app_theme.dart';
import '../shared/widgets/create_button.dart';
import 'itinerary_tile.dart';

class AgendaScreen extends StatefulWidget {
  final Trip trip;
  final int dayIndex;
  final DateTime dayDate;

  const AgendaScreen({
    super.key,
    required this.trip,
    required this.dayIndex,
    required this.dayDate,
  });

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class AgendaRouteLoader extends StatefulWidget {
  final String tripId;
  final DateTime dayDate;

  const AgendaRouteLoader({
    super.key,
    required this.tripId,
    required this.dayDate,
  });

  @override
  State<AgendaRouteLoader> createState() => _AgendaRouteLoaderState();
}

class _AgendaRouteLoaderState extends State<AgendaRouteLoader> {
  final TripRepository _tripRepository = TripRepository();
  Trip? _trip;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrip();
  }

  Future<void> _loadTrip() async {
    final trip = await _tripRepository.getTrip(widget.tripId);
    if (!mounted) return;
    setState(() {
      _trip = trip;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final trip = _trip;
    if (trip == null) {
      return const Scaffold(body: Center(child: Text('Trip not found')));
    }

    final tripStart = DateTime(
      trip.startDate.year,
      trip.startDate.month,
      trip.startDate.day,
    );
    final dayIndex = widget.dayDate.difference(tripStart).inDays;
    final safeIndex = dayIndex < 0 ? 0 : dayIndex;

    return AgendaScreen(
      trip: trip,
      dayIndex: safeIndex,
      dayDate: widget.dayDate,
    );
  }
}

class _AgendaScreenState extends State<AgendaScreen> {
  final _repository = ItineraryActivityRepository();

  List<ItineraryActivity> agendas = [];
  bool _loading = true;
  Timer? _nextRefreshTimer;
  ItineraryActivity? _lastDeletedActivity;

  @override
  void initState() {
    super.initState();
    _loadAgendas();
  }

  Future<void> _loadAgendas() async {
    setState(() => _loading = true);

    final all = await _repository.getTripActivities(widget.trip.tripId);

    final filtered = all
        .where(
          (a) =>
              a.date.year == widget.dayDate.year &&
              a.date.month == widget.dayDate.month &&
              a.date.day == widget.dayDate.day,
        )
        .toList();

    filtered.sort((a, b) => a.combineDateTime.compareTo(b.combineDateTime));

    if (!mounted) return;
    setState(() {
      agendas = filtered;
      widget.trip.itineraryActivities
        ..clear()
        ..addAll(filtered);
      _loading = false;
    });
    _scheduleNextRefresh();
  }

  Future<void> _toggleCompleted(ItineraryActivity activity, bool? value) async {
    final updated = activity.copyWith(isCompleted: value ?? false);

    await _repository.updateActivity(updated);
    await _loadAgendas();
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete activity?'),
            content: const Text('You can undo this action.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _deleteActivity(ItineraryActivity activity) async {
    _lastDeletedActivity = activity;

    await _repository.deleteActivity(activity.activityId);
    await NotificationService.instance.cancelItineraryNotifications(activity);

    if (!mounted) return;
    setState(() {
      agendas.removeWhere((a) => a.activityId == activity.activityId);
      widget.trip.itineraryActivities.removeWhere(
        (a) => a.activityId == activity.activityId,
      );
    });
    _scheduleNextRefresh();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Itinerary activity deleted'),
        action: SnackBarAction(label: 'Undo', onPressed: _undoDelete),
      ),
    );
  }

  void _undoDelete() async {
    final activity = _lastDeletedActivity;
    if (activity == null) return;

    await _repository.addActivity(activity);
    await NotificationService.instance.scheduleItineraryNotifications(activity);

    if (!mounted) return;
    setState(() {
      agendas.add(activity);
      agendas.sort((a, b) => a.combineDateTime.compareTo(b.combineDateTime));
      widget.trip.itineraryActivities.add(activity);
      widget.trip.itineraryActivities.sort(
        (a, b) => a.combineDateTime.compareTo(b.combineDateTime),
      );
    });
    _scheduleNextRefresh();

    _lastDeletedActivity = null;
  }

  Future<void> _openActivityForm({ItineraryActivity? activity}) async {
    final route = activity == null ? '/itinerary/add' : '/itinerary/edit';
    final result = await context.push<ItineraryActivity>(
      route,
      extra: {
        'trip': widget.trip,
        'date': widget.dayDate,
        if (activity != null) 'activity': activity,
      },
    );

    if (result != null) {
      await _loadAgendas();
    }
  }

  void _scheduleNextRefresh() {
    _nextRefreshTimer?.cancel();

    final now = DateTime.now();
    DateTime? nextUpdate;

    for (final activity in agendas) {
      final eventTime = activity.combineDateTime;
      if (eventTime.isAfter(now)) {
        nextUpdate = _earliest(nextUpdate, eventTime);
      }

      if (activity.reminderEnabled && activity.reminderMinutesBefore > 0) {
        final reminderTime = activity.reminderNotificationDateTime;
        if (reminderTime.isAfter(now)) {
          nextUpdate = _earliest(nextUpdate, reminderTime);
        }
      }
    }

    if (nextUpdate == null) return;

    final delay = nextUpdate.difference(now);
    _nextRefreshTimer = Timer(delay, () {
      if (!mounted) return;
      setState(() {});
      _scheduleNextRefresh();
    });
  }

  DateTime _earliest(DateTime? current, DateTime candidate) {
    if (current == null || candidate.isBefore(current)) {
      return candidate;
    }
    return current;
  }

  @override
  void dispose() {
    _nextRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, d MMM yyyy').format(widget.dayDate);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Itinerary - ${widget.trip.title}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day ${widget.dayIndex + 1} • $formattedDate',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : agendas.isEmpty
                  ? Center(
                      child: Text(
                        'No activities yet.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: agendas.length,
                      itemBuilder: (context, index) {
                        final activity = agendas[index];
                        return Dismissible(
                          key: ValueKey(
                            '${activity.activityId}_${activity.createdAt}',
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) => _confirmDelete(context),
                          onDismissed: (_) => _deleteActivity(activity),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.tileHorizontalPadding,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(
                                AppTheme.tileBorderRadius,
                              ),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: AgendaTile(
                            activity: activity,
                            onChecked: (v) => _toggleCompleted(activity, v),
                            onTap: () => _openActivityForm(activity: activity),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: CreateButton(
        tooltip: 'Add Activity',
        onPressed: () => _openActivityForm(),
      ),
    );
  }
}
