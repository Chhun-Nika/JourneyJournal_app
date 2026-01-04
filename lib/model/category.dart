import 'package:uuid/uuid.dart';

var uuid = Uuid();

enum CategoryType { checklist, expense, itineraryActivity }

class Category {
  final String categoryId;
  // userId can be null, and it is null when the category is the default one
  final String? userId;
  final CategoryType categoryType;
  final String name;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    String? categoryId,
    this.userId,
    required this.categoryType,
    required this.name,
    this.isDefault = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : categoryId = categoryId ?? uuid.v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Category copyWith({String? name}) {
    return Category(
      categoryId: categoryId,
      userId: userId,
      categoryType: categoryType,
      name: name ?? this.name,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: DateTime.now()
    );
  }
}
