import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class ItineraryActivity {
  final String activityId;
  final String tripId;
  final String name;
  final String? description; // optional
  final String? location; // optional
  final DateTime date;
  final TimeOfDay time;
  final bool isCompleted;
  final bool reminderEnabled;
  final int reminderMinutesBefore;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItineraryActivity({
    String? activityId,
    required this.tripId,
    required this.name,
    this.description,
    this.location,
    required this.date,
    required this.time,
    this.isCompleted = false,
    this.reminderEnabled = false,
    this.reminderMinutesBefore = 15,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : activityId = activityId ?? uuid.v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  ItineraryActivity copyWith({
    String? name,
    String? description,
    String? location,
    DateTime? date,
    TimeOfDay? time,
    bool? isCompleted,
    bool? reminderEnabled,
    int? reminderMinutesBefore,
  }) {
    return ItineraryActivity(
      activityId: activityId,
      tripId: tripId,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ItineraryActivity markComplete() => copyWith(isCompleted: true);

  ItineraryActivity toggleReminder([bool? enable]) =>
      copyWith(reminderEnabled: enable ?? !reminderEnabled);

  DateTime get combineDateTime =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);

  DateTime get reminderNotificationDateTime =>
      combineDateTime.subtract(Duration(minutes: reminderMinutesBefore));

  bool get isPastDue =>
      !isCompleted && combineDateTime.isBefore(DateTime.now());

  bool get isUpcoming =>
      !isCompleted && combineDateTime.isAfter(DateTime.now());
}
