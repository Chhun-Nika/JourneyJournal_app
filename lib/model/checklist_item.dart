import 'package:uuid/uuid.dart';

var uuid = Uuid();

class ChecklistItem {
  final String checklistItemId;
  final String categoryId;
  final String tripId;
  final String name;
  final bool completed;
  final bool reminderEnabled;
  final DateTime? reminderTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChecklistItem({
    String? checklistItemId,
    required this.categoryId,
    required this.tripId,
    required this.name,
    this.completed = false,
    this.reminderEnabled = false,
    this.reminderTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : checklistItemId = checklistItemId ?? uuid.v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  ChecklistItem copyWith({
    String? name,
    String? categoryId,
    bool? completed,
    bool? reminderEnabled,
    DateTime? reminderTime,
  }) {
    return ChecklistItem(
      checklistItemId: checklistItemId,
      tripId: tripId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      completed: completed ?? this.completed,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt,
      updatedAt: DateTime.now()
    );
  }

  // easier to update specific fields,
  ChecklistItem markCompleted() => copyWith(completed: true);
  ChecklistItem enableReminder(DateTime time) =>
      copyWith(reminderEnabled: true, reminderTime: time);
  ChecklistItem disableReminder() =>
      copyWith(reminderEnabled: false, reminderTime: null);
}
