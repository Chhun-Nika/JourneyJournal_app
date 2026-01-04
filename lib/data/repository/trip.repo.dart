import '../../model/trip.dart';
import '../dao/trip_dao.dart';

class TripRepository {
  final _tripDao = TripDao();

  Future<void> addTrip(Trip trip) async {
    await _tripDao.insert(_toMap(trip));
  }

  Future<Trip?> getTrip(String tripId) async {
    final map = await _tripDao.getById(tripId);
    if (map == null) return null;
    return _fromMap(map);
  }

  Future<List<Trip>> getUserTrips(String userId) async {
    final maps = await _tripDao.getByUserId(userId);
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<void> updateTrip(Trip trip) async {
    await _tripDao.update(trip.tripId, _toMap(trip));
  }

  Future<void> deleteTrip(String tripId) async {
    await _tripDao.delete(tripId);
  }

  // Convert Trip object to Map
  Map<String, Object> _toMap(Trip trip) {
    return {
      'tripId': trip.tripId,
      'userId': trip.userId,
      'title': trip.title,
      'destination': trip.destination,
      'startDate': trip.startDate.toIso8601String(),
      'endDate': trip.endDate.toIso8601String(),
      'createdAt': trip.createdAt.toIso8601String(),
      'updatedAt': trip.updatedAt.toIso8601String(),
    };
  }

  // Convert Map to Trip object
  Trip _fromMap(Map<String, Object?> map) {
    return Trip(
      tripId: map['tripId'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      destination: map['destination'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}