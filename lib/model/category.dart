import 'package:uuid/uuid.dart';

var uuid = Uuid();

enum CategoryType { checklist, expense }

class Category {
  final String categoryId;
  final CategoryType categoryType;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    String? categoryId,
    required this.categoryType,
    required this.name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : categoryId = categoryId ?? uuid.v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
}
