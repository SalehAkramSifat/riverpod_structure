extension StringExtension on String {
  /// Check if the string is a valid email address
  bool get isValidEmail =>
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(this);

  /// Check if the string is a valid phone number (basic international or local)
  bool get isValidPhone =>
      RegExp(r'^\+?[0-9]{10,14}$').hasMatch(replaceAll(' ', ''));

  /// Capitalize first letter of string
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Title case every word in string
  String get titleCase => split(' ')
      .map((word) => word.trim().capitalize)
      .where((word) => word.isNotEmpty)
      .join(' ');
}

extension NullableStringExtension on String? {
  /// Returns true if null, empty, or whitespace only
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;

  /// Returns true if not null and has non-whitespace characters
  bool get isNotNullOrEmpty => !isNullOrEmpty;
}
