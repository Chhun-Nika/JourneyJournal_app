import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/data/repository/checklist_item_repo.dart';

import '../../data/repository/category_repo.dart';
import '../../model/category.dart';
import '../../model/checklist_item.dart';
import '../../model/trip.dart';
import '../shared/widgets/create_button.dart';
import 'checklist_item_tile.dart';

class ChecklistListScreen extends StatefulWidget {
  final Trip trip;

  const ChecklistListScreen({super.key, required this.trip});

  @override
  State<ChecklistListScreen> createState() => _ChecklistListScreenState();
}

class _ChecklistListScreenState extends State<ChecklistListScreen> {
  bool isLoading = true;

  final ChecklistItemRepository checklistRepository = ChecklistItemRepository();
  final CategoryRepository categoryRepository = CategoryRepository();

  List<Category> checklistCategories = [];

  // Keep track of last cleared completed items for undo
  List<ChecklistItem> _lastClearedCompleted = [];
  ChecklistItem? _lastDeletedItem;
  int? _lastDeletedIndex;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      checklistCategories = await categoryRepository.getCategoriesByType(
        CategoryType.checklist,
      );
      final items = await checklistRepository.getTripChecklistItems(
        widget.trip.tripId,
      );

      if (!mounted) return;

      setState(() {
        widget.trip.checklistItems
          ..clear()
          ..addAll(items);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading checklist: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _onCreatePressed() async {
    final newItem = await context.push<ChecklistItem>(
      '/checklist/add',
      extra: {'tripId': widget.trip.tripId, 'categories': checklistCategories},
    );

    if (newItem != null) {
      setState(() {
        widget.trip.checklistItems.add(newItem);
      });
    }
  }

  void _onEditPressed(ChecklistItem item) async {
    final updatedItem = await context.push<ChecklistItem>(
      '/checklist/edit',
      extra: {
        'tripId': widget.trip.tripId,
        'categories': checklistCategories,
        'existingItem': item,
      },
    );

    if (updatedItem != null) {
      setState(() {
        final index = widget.trip.checklistItems.indexWhere(
          (i) => i.checklistItemId == updatedItem.checklistItemId,
        );
        if (index != -1) widget.trip.checklistItems[index] = updatedItem;
      });
    }
  }


  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete checklist?'),
            content: const Text('You can undo this action.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _toggleCompleted(ChecklistItem item) async {
    final updated = item.copyWith(completed: !item.completed);
    await checklistRepository.updateChecklistItem(updated);
    setState(() {
      final index = widget.trip.checklistItems.indexWhere(
        (i) => i.checklistItemId == item.checklistItemId,
      );
      if (index != -1) widget.trip.checklistItems[index] = updated;
    });
  }

  void _clearCompleted() async {
    final completedItems = widget.trip.checklistItems
        .where((item) => item.completed)
        .toList();

    if (completedItems.isEmpty) return;

    _lastClearedCompleted = completedItems;

    for (var item in completedItems) {
      await checklistRepository.deleteChecklistItem(item.checklistItemId);
    }

    setState(() {
      widget.trip.checklistItems.removeWhere((item) => item.completed);
    });

    // Show Snackbar with Undo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${completedItems.length} completed item(s) cleared'),
        action: SnackBarAction(label: 'Undo', onPressed: _undoClearCompleted),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _undoClearCompleted() async {
    for (var item in _lastClearedCompleted) {
      await checklistRepository.addChecklistItem(item);
    }

    setState(() {
      widget.trip.checklistItems.addAll(_lastClearedCompleted);
      _lastClearedCompleted = [];
    });
  }

  void _deleteItem(ChecklistItem item) async {
    _lastDeletedIndex = widget.trip.checklistItems.indexOf(item);
    _lastDeletedItem = item;

    await checklistRepository.deleteChecklistItem(item.checklistItemId);

    setState(() {
      widget.trip.checklistItems.remove(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Checklist item deleted'),
        action: SnackBarAction(label: 'Undo', onPressed: _undoDelete),
      ),
    );
  }

  void _undoDelete() async {
    if (_lastDeletedItem == null) return;

    await checklistRepository.addChecklistItem(_lastDeletedItem!);

    setState(() {
      widget.trip.checklistItems.insert(_lastDeletedIndex!, _lastDeletedItem!);
    });

    _lastDeletedItem = null;
    _lastDeletedIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    final uncheckedItems = widget.trip.checklistItems
        .where((i) => !i.completed)
        .toList();
    final checkedItems = widget.trip.checklistItems
        .where((i) => i.completed)
        .toList();
    final List<dynamic> combinedList = [];

    if (uncheckedItems.isNotEmpty) {
      combinedList.add('To do');
      combinedList.addAll(uncheckedItems);
      combinedList.add('Spacer');
    }

    if (checkedItems.isNotEmpty) {
      combinedList.add('Completed');
      combinedList.addAll(checkedItems);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Checklist')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : widget.trip.checklistItems.isEmpty
            ? const Center(child: Text('No checklist items yet'))
            : ListView.builder(
                itemCount: combinedList.length,
                itemBuilder: (context, index) {
                  final item = combinedList[index];
                  if (item is String) {
                    if (item == 'To do' || item == 'Completed') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: item == 'Completed'
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            if (item == 'Completed')
                              TextButton(
                                onPressed: _clearCompleted,
                                child: const Text(
                                  'Clear All',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                      );
                    } else if (item == 'Spacer') {
                      return const SizedBox(height: 24);
                    }
                  } else if (item is ChecklistItem) {
                    return Dismissible(
                      key: ValueKey(
                        '${item.checklistItemId}_${item.createdAt}',
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) => _confirmDelete(context),
                      onDismissed: (_) => _deleteItem(item),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ChecklistItemTile(
                        item: item,
                        onToggleCompleted: () => _toggleCompleted(item),
                        onTap:() =>  _onEditPressed(item)
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
      ),
      floatingActionButton: CreateButton(
        tooltip: 'Add Checklist Item',
        onPressed: _onCreatePressed,
      ),
    );
  }
}
