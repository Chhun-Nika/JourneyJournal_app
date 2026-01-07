import 'package:journey_journal_app/data/dao/category_dao.dart';
import '../../model/category.dart';

class CategoryRepository {
  final _categoryDao = CategoryDao();
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