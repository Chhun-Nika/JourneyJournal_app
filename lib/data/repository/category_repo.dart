import 'package:journey_journal_app/data/dao/category_dao.dart';
import 'package:uuid/uuid.dart';

import '../../model/category.dart';
import '../seed/default_category.dart';

class CategoryRepository {
  final _categoryDao = CategoryDao();
  final _uuid = const Uuid();

  /// Seed default categories ONLY ONCE
  Future<void> seedDefaultCategoriesIfNeeded() async {

    final now = DateTime.now();

    for (final category in defaultCategories) {
      await _categoryDao.insert({
        'categoryId': _uuid.v4(),
        'categoryType': category.categoryType.index,
        'name': category.name,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      });
    }
  }

  // Read categories by type
  Future<List<Category>> getCategoriesByType(
    CategoryType type,
  ) async {
    final maps = await _categoryDao.getByType(type.index.toString());
    return maps.map(_fromMap).toList();
  }

  Category _fromMap(Map<String, Object?> map) {
    return Category(
      categoryId: map['categoryId'] as String,
      categoryType:
          CategoryType.values[map['categoryType'] as int],
      name: map['name'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}