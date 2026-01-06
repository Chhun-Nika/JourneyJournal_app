class AppDateValidator {
  AppDateValidator._(); // private constructor to prevent instantiation

  /// Validate that a date is selected (not null)
  /// [value] : the date to validate
  /// [fieldName] : text to show in error message
  static String? validateRequired(DateTime? value, String fieldName) {
    if (value == null) return 'Please select $fieldName';
    return null;
  }

  /// Validate that end date is after start date
  /// [start] : start date
  /// [end] : end date
  /// [startFieldName] : custom name for start date field
  /// [endFieldName] : custom name for end date field
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

  /// Combined validator for end date:
  /// checks for null, then comparison
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