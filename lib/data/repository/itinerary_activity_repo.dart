import 'package:flutter/material.dart';
import '../dao/itinerary_activity_dao.dart';
import '../../model/itinerary_activity.dart';

class ItineraryActivityRepository {
  final ItineraryActivityDao _dao = ItineraryActivityDao();

  Future<void> addActivity(ItineraryActivity activity) async {
    await _dao.insert(_toMap(activity));
  }

  Future<void> updateActivity(ItineraryActivity activity) async {
    await _dao.update(_toMap(activity), activity.activityId);
  }

  Future<void> deleteActivity(String activityId) async {
    await _dao.delete(activityId);
  }

  Future<ItineraryActivity?> getActivity(String activityId) async {
    final map = await _dao.getById(activityId);
    if (map == null) return null;
    return _fromMap(map);
  }

  Future<List<ItineraryActivity>> getTripActivities(String tripId) async {
    final maps = await _dao.getByTripId(tripId);
    return maps.map((m) => _fromMap(m)).toList();
  }

  Map<String, Object> _toMap(ItineraryActivity activity) {
    return {
      'activityId': activity.activityId,
      'tripId': activity.tripId,
      'name': activity.name,
      'description': activity.description,
      'date': activity.date.toIso8601String(),
      'time': '${activity.time.hour}:${activity.time.minute}',
      'reminderEnabled': activity.reminderEnabled ? 1 : 0,
      'reminderMinutesBefore': activity.reminderMinutesBefore,
      'createdAt': activity.createdAt.toIso8601String(),
      'updatedAt': activity.updatedAt.toIso8601String(),
    };
  }

  ItineraryActivity _fromMap(Map<String, Object?> map) {
    final timeParts = (map['time'] as String).split(':');
    return ItineraryActivity(
      activityId: map['activityId'] as String,
      tripId: map['tripId'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      date: DateTime.parse(map['date'] as String),
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      reminderEnabled: map['reminderEnabled'] == 1,
      reminderMinutesBefore: map['reminderMinutesBefore'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}