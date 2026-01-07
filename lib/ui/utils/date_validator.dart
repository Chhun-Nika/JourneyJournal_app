class AppDateValidator {
  AppDateValidator._(); 

  static String? validateRequired(DateTime? value, String fieldName) {
    if (value == null) return 'Please select $fieldName';
    return null;
  }

  static String? validateEndAfterStart({
    required DateTime? start,
    required DateTime? end,
    String startFieldName = 'start date',
    String endFieldName = 'end date',
  }) {
    if (end == null) return 'Please select $endFieldName';
    if (start == null) return 'Please select $startFieldName first';
    if (end.isBefore(start)) return '$endFieldName cannot be before $startFieldName';
    if (end.isAtSameMomentAs(start)) return '$endFieldName cannot be the same as $startFieldName';
    return null;
  }
  static String? validateEndDate({
    required DateTime? start,
    required DateTime? end,
    String startFieldName = 'start date',
    String endFieldName = 'end date',
  }) {
    final nullCheck = validateRequired(end, endFieldName);
    if (nullCheck != null) return nullCheck;

    return validateEndAfterStart(
      start: start,
      end: end,
      startFieldName: startFieldName,
      endFieldName: endFieldName,
    );
  }
}