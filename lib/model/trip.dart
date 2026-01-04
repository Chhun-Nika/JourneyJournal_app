import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Trip {
  final String tripId;
  final String userId;
  final String title;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Trip({
    String? tripId,
    required this.userId,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : tripId = tripId ?? uuid.v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Trip copyWith({
    String? title,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Trip(
      tripId: tripId,
      userId: userId,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt,
      updatedAt: DateTime.now()
    );
  }

}
