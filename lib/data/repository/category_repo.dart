import 'package:journey_journal_app/data/dao/category_dao.dart';

import '../../model/category.dart';
import '../seed/default_category.dart';

class CategoryRepository {
  final _categoryDao = CategoryDao();

  Future<void> seedDefaultCategories() async {
    for (final category in defaultCategories) {
      await _categoryDao.insert(_toMap(category));
    }
  }

  Future<List<Category>> getCategoriesForUser(
    String userId,
    CategoryType type,
  ) async {
    final maps =
        await _categoryDao.getByUserAndType(userId, type.index);
    return maps.map(_fromMap).toList();
  }

  Future<void> addUserCategory(Category category) async {
    if (category.isDefault) {
      throw Exception('Cannot manually add default category');
    }
    await _categoryDao.insert(_toMap(category));
  }

  Future<void> updateCategory(Category category) async {
    await _categoryDao.update(
      category.categoryId,
      {
        'name': category.name,
        'updatedAt': category.updatedAt.toIso8601String(),
      },
    );
  }

  Future<void> deleteCategory(String categoryId) async {
    await _categoryDao.delete(categoryId);
  }

  Map<String, Object?> _toMap(Category category) {
    return {
      'categoryId': category.categoryId,
      'userId': category.userId,
      'categoryType': category.categoryType.index,
      'name': category.name,
      'isDefault': category.isDefault ? 1 : 0,
      'createdAt': category.createdAt.toIso8601String(),
      'updatedAt': category.updatedAt.toIso8601String(),
    };
  }

  Category _fromMap(Map<String, Object?> map) {
    return Category(
      categoryId: map['categoryId']! as String,
      userId: map['userId'] as String?,
      categoryType:
          CategoryType.values[map['categoryType']! as int],
      name: map['name']! as String,
      isDefault: (map['isDefault']! as int) == 1,
      createdAt: DateTime.parse(map['createdAt']! as String),
      updatedAt: DateTime.parse(map['updatedAt']! as String),
    );
  }
}