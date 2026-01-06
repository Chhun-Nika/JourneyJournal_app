import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';

class AppDateField extends StatelessWidget {
  final String hint;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged; // use onChanged instead of VoidCallback
  final bool allowPastDates; // new
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(String?)? validator;

  const AppDateField({
    super.key,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.allowPastDates = true,
    this.firstDate,
    this.lastDate,
    this.validator,
  });

  String _format(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMM yyyy').format(date);
  }

  Future<void> _pickDate(BuildContext context) async {
    final today = DateTime.now();
    final minDate = firstDate ?? (allowPastDates ? DateTime(1900) : today);
    final maxDate = lastDate ?? DateTime(2100);
    var initialDate = value ?? today;
    if (initialDate.isBefore(minDate)) {
      initialDate = minDate;
    } else if (initialDate.isAfter(maxDate)) {
      initialDate = maxDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDate,
      lastDate: maxDate,
    );

    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          controller: TextEditingController(text: _format(value)),
          decoration: InputDecoration(
            labelText: hint,
            labelStyle: TextStyle(color: AppTheme.hintColor),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey,),
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator,
        ),
      ),
    );
  }
}
