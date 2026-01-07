import 'package:journey_journal_app/model/checklist_item.dart';
import 'package:uuid/uuid.dart';

import 'expense.dart';
import 'itinerary_activity.dart';

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
  final List<Expense> expenses;
  final List<ChecklistItem> checklistItems;
  final List<ItineraryActivity> itineraryActivities;
  

  Trip({
    String? tripId,
    required this.userId,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Expense>? expenses,
    List<ChecklistItem>? checklistItems,
    List<ItineraryActivity>? itineraryActivities,
  }) : tripId = tripId ?? uuid.v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       expenses = expenses ?? [],
       checklistItems = checklistItems ?? [],
       itineraryActivities = itineraryActivities ?? [];

  Trip copyWith({
    String? title,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    List<Expense>? expenses,
    List<ChecklistItem>? checklistItems,
    List<ItineraryActivity>? itineraryActivities,
  }) {
    return Trip(
      tripId: tripId,
      userId: userId,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      expenses: expenses ?? this.expenses,
      checklistItems: checklistItems ?? this.checklistItems,
      itineraryActivities: itineraryActivities ?? this.itineraryActivities,

    );
  }

  int get totalDays => endDate.difference(startDate).inDays + 1;
  double get totalExpense => expenses.fold(0.0, (sum, e) => sum + e.amount);

  Map<String, double> get expenseTotalsByCategory {
    final totals = <String, double>{};
    for (final expense in expenses) {
      totals.update(
        expense.categoryId,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return totals;
  }

  int get completedChecklistCount =>
      checklistItems.where((i) => i.completed).length;

  int get totalChecklistCount => checklistItems.length;

}
