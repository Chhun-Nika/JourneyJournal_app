import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/data/repository/checklist_item_repo.dart';
import 'package:journey_journal_app/data/service/notification_service.dart';
import 'package:journey_journal_app/model/category.dart';
import 'package:journey_journal_app/model/checklist_item.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_dropdown_menu.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_date_field.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_time_field.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_text_field.dart';
import 'package:journey_journal_app/ui/utils/validators.dart';

class AddChecklistItemScreen extends StatefulWidget {
  final String tripId;
  final List<Category> categories;
  final ChecklistItem? existingItem;

  const AddChecklistItemScreen({
    super.key,
    required this.tripId,
    required this.categories,
    this.existingItem,
  });

  @override
  State<AddChecklistItemScreen> createState() => _AddChecklistItemScreenState();
}

class _AddChecklistItemScreenState extends State<AddChecklistItemScreen> {
  final _formKey = GlobalKey<FormState>();

  late Category _selectedCategory;
  final _nameController = TextEditingController();
  final ChecklistItemRepository checklistRepo = ChecklistItemRepository();

  bool _reminderEnabled = false;
  DateTime? _reminderDate;
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();

    _selectedCategory = widget.categories.first;

    if (widget.existingItem != null) {
      final item = widget.existingItem!;
      _selectedCategory = widget.categories.firstWhere(
        (cat) => cat.categoryId == item.categoryId,
        orElse: () => widget.categories.first,
      );
      _nameController.text = item.name;
      _reminderEnabled = item.reminderEnabled;
      if (item.reminderTime != null) {
        _reminderDate = item.reminderTime;
        _reminderTime = TimeOfDay.fromDateTime(item.reminderTime!);
      }
    }
  }

  void _saveChecklistItem() async {
    if (!_formKey.currentState!.validate()) return;

    DateTime? reminderDateTime;
    if (_reminderEnabled && _reminderDate != null && _reminderTime != null) {
      reminderDateTime = DateTime(
        _reminderDate!.year,
        _reminderDate!.month,
        _reminderDate!.day,
        _reminderTime!.hour,
        _reminderTime!.minute,
      );
    }

    final item = ChecklistItem(
      checklistItemId: widget.existingItem?.checklistItemId,
      tripId: widget.tripId,
      categoryId: _selectedCategory.categoryId,
      name: _nameController.text.trim(),
      reminderEnabled: reminderDateTime != null,
      reminderTime: reminderDateTime,
    );

    try {
      if (widget.existingItem == null) {
        await checklistRepo.addChecklistItem(item);
      } else {
        await checklistRepo.updateChecklistItem(item);
        await NotificationService.instance.cancelChecklistNotification(
          widget.existingItem!,
        );
      }
      await NotificationService.instance.scheduleChecklistNotification(item);

      if (!mounted) return;

      context.pop(item); 
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save checklist')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingItem != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Checklist Item' : 'Add Checklist Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Form(
          key: _formKey,
          child: ListView(
            clipBehavior: Clip.none,
            children: [
              AppTextField(
                label: "Item name",
                controller: _nameController,
                validator: (v) => Validators.required(v, "item name"),
              ),
              const SizedBox(height: 16),

              AppDropdownMenu<Category>(
                label: 'Category',
                value: _selectedCategory,
                entries: widget.categories
                    .map(
                      (cat) => DropdownMenuEntry(value: cat, label: cat.name),
                    )
                    .toList(),
                onSelected: (cat) {
                  if (cat != null) {
                    setState(() => _selectedCategory = cat);
                  }
                },
              ),
              const SizedBox(height: 14),

              SwitchListTile(
                contentPadding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                title: const Text('Enable reminder'),
                value: _reminderEnabled,
                onChanged: (v) {
                  setState(() {
                    _reminderEnabled = v;
                    if (!v) {
                      _reminderDate = null;
                      _reminderTime = null;
                    }
                  });
                },
              ),

              if (_reminderEnabled) ...[
                const SizedBox(height: 8),
                AppDateField(
                  hint: 'Reminder Date',
                  value: _reminderDate,
                  allowPastDates: false,
                  onChanged: (date) => setState(() => _reminderDate = date),
                ),
                const SizedBox(height: 16),
                AppTimeField(
                  hint: 'Reminder Time',
                  value: _reminderTime,
                  onChanged: (time) => setState(() => _reminderTime = time),
                ),
              ],

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _saveChecklistItem,
                child: Text(isEditing ? 'Save Changes' : 'Save Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
