import '../../model/checklist_item.dart';
import '../dao/checklist_item_dao.dart';

class ChecklistItemRepository {
  final _checklistItemDao = ChecklistItemDao();

  Future<void> addChecklistItem(ChecklistItem item) async {
    await _checklistItemDao.insert(_toMap(item));
  }

  Future<ChecklistItem?> getChecklistItem(String checklistItemId) async {
    final map = await _checklistItemDao.getById(checklistItemId);
    if (map == null) return null;
    return _fromMap(map);
  }

  Future<List<ChecklistItem>> getTripChecklistItems(String tripId) async {
    final maps = await _checklistItemDao.getByTripId(tripId);
    return maps.map(_fromMap).toList();
  }

  Future<void> updateChecklistItem(ChecklistItem item) async {
    await _checklistItemDao.update(item.checklistItemId, {
      ..._toMap(item),
      'updatedAt': item.updatedAt.toIso8601String(),
    });
  }

  Future<void> deleteChecklistItem(String checklistItemId) async {
    await _checklistItemDao.delete(checklistItemId);
  }

  Map<String, Object?> _toMap(ChecklistItem item) {
    return {
      'checklistItemId': item.checklistItemId,
      'tripId': item.tripId,
      'categoryId': item.categoryId,
      'name': item.name,
      'completed': item.completed ? 1 : 0,
      'reminderEnabled': item.reminderEnabled ? 1 : 0,
      'reminderTime': item.reminderTime?.toIso8601String(),
      'createdAt': item.createdAt.toIso8601String(),
      'updatedAt': item.updatedAt.toIso8601String(),
    };
  }

  ChecklistItem _fromMap(Map<String, Object?> map) {
    return ChecklistItem(
      checklistItemId: map['checklistItemId']! as String,
      tripId: map['tripId']! as String,
      categoryId: map['categoryId']! as String,
      name: map['name']! as String,
      completed: (map['completed']! as int) == 1,
      reminderEnabled: (map['reminderEnabled']! as int) == 1,
      reminderTime: map['reminderTime'] != null
          ? DateTime.parse(map['reminderTime']! as String)
          : null,
      createdAt: DateTime.parse(map['createdAt']! as String),
      updatedAt: DateTime.parse(map['updatedAt']! as String),
    );
  }
}
