import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/model/category.dart';
import 'package:journey_journal_app/model/expense.dart';
import 'package:journey_journal_app/data/repository/expense_repo.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_date_field.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_dropdown_menu.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_price_field.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_text_field.dart';
import 'package:journey_journal_app/ui/utils/validators.dart';

class AddExpenseScreen extends StatefulWidget {
  final String tripId;
  final List<Category> categories; // <-- pass categories from list screen

  const AddExpenseScreen({
    super.key,
    required this.tripId,
    required this.categories,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late Category _selectedCategory;

  final _expenseRepository = ExpenseRepository();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Set initial category from the passed list
    _selectedCategory = widget.categories.first;
  }

  void _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    final newExpense = Expense(
      tripId: widget.tripId,
      categoryId: _selectedCategory.categoryId,
      title: _titleController.text.trim().isEmpty
          ? _selectedCategory.name
          : _titleController.text.trim(),
      amount:
          double.tryParse(_priceController.text.trim().replaceAll(',', '')) ??
          0,
      date: _selectedDate,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    try {
      await _expenseRepository.addExpense(newExpense);
      if (!mounted) return;

      context.pop(newExpense); // Return the new expense to the list screen
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save expense')));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Form(
          key: _formKey,
          child: ListView(
            clipBehavior: Clip.none,
            children: [
              // Category dropdown (uses passed categories)
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
              const SizedBox(height: 16),

              AppTextField(
                label: "Title",
                controller: _titleController,
                validator: (v) => Validators.required(v, "title"),
              ),
              const SizedBox(height: 16),

              AppPriceField(
                label: "Price",
                controller: _priceController,
                validator: Validators.price,
              ),
              const SizedBox(height: 16),

              // Date picker
              AppDateField(
                hint: 'Date',
                value: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                onChanged: (date) => setState(() => _selectedDate = date),
              ),
              const SizedBox(height: 16),

              // Note (optional)
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  hintText: 'Add any note here',
                  alignLabelWithHint: true,
                ),
                textAlignVertical: TextAlignVertical.top,
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _saveExpense,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
