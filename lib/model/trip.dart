import 'package:uuid/uuid.dart';

var uuid = Uuid();
class Trip {
  final String tripId;
  final String userId;
  final String name;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;

  Trip({
    String? tripId,
    required this.userId,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
  }) : tripId = tripId ?? uuid.v4();

  Trip copyWith({
    String? name,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Trip(
      tripId: tripId,
      userId: userId,
      name: name ?? this.name,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}