import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/data/repository/checklist_item_repo.dart';
import 'package:journey_journal_app/model/category.dart';
import 'package:journey_journal_app/model/checklist_item.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_text_field.dart';
import 'package:journey_journal_app/ui/utils/validators.dart';

class AddChecklistItemScreen extends StatefulWidget {
  final String tripId;
  final List<Category> categories;

  const AddChecklistItemScreen({
    super.key,
    required this.tripId,
    required this.categories,
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
  }

  Future<void> _pickReminderDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _reminderDate = picked);
    }
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
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
      tripId: widget.tripId,
      categoryId: _selectedCategory.categoryId,
      name: _nameController.text.trim(),
      reminderEnabled: reminderDateTime != null,
      reminderTime: reminderDateTime,
    );

    try {
      await checklistRepo.addChecklistItem(item);
      if (!mounted) return;

      context.pop(item); // Return the new expense to the list screen
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Checklist Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Category>(
                initialValue: _selectedCategory,
                items: widget.categories
                    .map(
                      (cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat.name)),
                    )
                    .toList(),
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (cat) {
                  if (cat != null) {
                    setState(() => _selectedCategory = cat);
                  }
                },
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: "Item name",
                controller: _nameController,
                validator: (v) => Validators.required(v, "item name"),
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text("Enable Reminder"),
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

              if (_reminderEnabled)
                InkWell(
                  onTap: _pickReminderDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Reminder Date',
                    ),
                    child: Text(
                      _reminderDate == null
                          ? "Select date"
                          : "${_reminderDate!.month}/${_reminderDate!.day}/${_reminderDate!.year}",
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),

              if (_reminderEnabled) const SizedBox(height: 16),

              if (_reminderEnabled)
                InkWell(
                  onTap: _pickReminderTime,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Reminder Time',
                    ),
                    child: Text(
                      _reminderTime == null
                          ? "Select time"
                          : _reminderTime!.format(context),
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _saveChecklistItem,
                child: const Text('Save Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
