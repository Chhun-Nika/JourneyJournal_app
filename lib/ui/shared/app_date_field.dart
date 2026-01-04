import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateField extends StatelessWidget {
  final String hint;
  final DateTime? value;
  final VoidCallback onTap;
  final String? Function(String?)? validator;

  const AppDateField({
    super.key,
    required this.hint,
    required this.value,
    required this.onTap,
    this.validator,
  });

  String _format(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          controller: TextEditingController(text: _format(value)),
          decoration: InputDecoration(
            labelText: hint,
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            suffixIcon: const Icon(Icons.calendar_today),
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
