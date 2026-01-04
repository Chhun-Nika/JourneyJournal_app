import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/data/repository/expense_repo.dart';
import 'package:journey_journal_app/model/category.dart';
import 'package:journey_journal_app/model/expense.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_price_field.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_text_field.dart';
import 'package:journey_journal_app/ui/utils/validators.dart';

class AddExpenseScreen extends StatefulWidget {
  final String tripId;
  final ExpenseRepository expenseRepository;
  final List<Category> categories;

  const AddExpenseScreen({
    super.key,
    required this.tripId,
    required this.expenseRepository,
    required this.categories,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  late Category _selectedCategory;
  final  _titleController = TextEditingController();
  final  _priceController = TextEditingController();
  final  _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Default select first category
    _selectedCategory = widget.categories.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final amount = double.tryParse(_priceController.text.trim().replaceAll(',', '')) ?? 0;

    final newExpense = Expense(
      tripId: widget.tripId,
      categoryId: _selectedCategory.categoryId,
      title: title.isEmpty ? _selectedCategory.name : title,
      amount: amount,
      date: _selectedDate,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await widget.expenseRepository.addExpense(newExpense);

    // After saving, go back
    if (mounted) context.pop(true);  // Pass true to indicate data changed
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Category dropdown
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                items: widget.categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat.name),
                        ))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (cat) {
                  if (cat != null) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              AppTextField(
                label: "Tittle", 
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
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                  child: Text(
                    '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Note (optional)
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  hintText: 'Add any note here',
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // Save button
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
