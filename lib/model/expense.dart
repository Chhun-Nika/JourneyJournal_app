import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Expense {
  final String expenseId;
  final String categoryId;
  final String tripId;
  final String title;
  final double amount;
  final DateTime date;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  Expense({
    String? expenseId,
    required this.categoryId,
    required this.tripId,
    required this.title,
    required this.amount,
    required this.date,
    this.note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : expenseId = expenseId ?? uuid.v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Expense copyWith({
    String? title,
    double? amount,
    DateTime? date,
    String? note,
    String? categoryId,
  }) {
    return Expense(
      expenseId: expenseId,
      tripId: tripId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt,
      updatedAt: DateTime.now()
    );
  }
}
