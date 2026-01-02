enum CategoryType {
  checklist,
  expense,
  itineraryActivity
}

class Category {
  final String categoryId;
  // userId can be null, and it is null when the category is the default one
  final String? userId;
  final CategoryType categoryType;
  final String name;
  final bool isDefault;

  Category({
    required this.categoryId,
    this.userId,
    required this.categoryType,
    required this.name,
    this.isDefault = false,
  });

  Category copyWith({
    String? name,
  }) {
    return Category(
      categoryId: categoryId,
      userId: userId,
      categoryType: categoryType,
      name: name ?? this.name,
      isDefault: isDefault,
    );
  }
}