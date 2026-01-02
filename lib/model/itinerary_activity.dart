import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
class ItineraryActivity {
  final String activityId;
  final String tripId;
  final String name;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final bool reminderEnabled;
  final int reminderMinutesBefore;

  ItineraryActivity({
    String? activityId,
    required this.tripId,
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    this.reminderEnabled = false,
    this.reminderMinutesBefore = 15,
  }) : activityId = activityId ?? uuid.v4();

  // copyWith is used to create a new instance with updated fields
  ItineraryActivity copyWith({
    String? name,
    String? description,
    DateTime? date,
    TimeOfDay? time,
    bool? reminderEnabled,
    int? reminderMinutesBefore,
  }) {
    return ItineraryActivity(
      activityId: activityId, 
      tripId: tripId,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
    );
  }
}