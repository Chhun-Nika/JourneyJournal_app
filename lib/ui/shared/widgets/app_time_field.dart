import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppTimeField extends StatelessWidget {
  final String hint;
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay> onChanged;
  final String? Function(String?)? validator;

  const AppTimeField({
    super.key,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  String _format(BuildContext context, TimeOfDay? time) {
    if (time == null) return '';
    return time.format(context);
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(),
    );

    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickTime(context),
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          controller: TextEditingController(text: _format(context, value)),
          decoration: InputDecoration(
            labelText: hint,
            labelStyle: TextStyle(color: AppTheme.hintColor),
            suffixIcon: const Icon(
              Icons.access_time,
              color: Colors.grey,
            ),
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
