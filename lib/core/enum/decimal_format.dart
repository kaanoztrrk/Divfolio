enum DecimalFormat {
  us, // 1,234.56
  eu, // 1.234,56
  plain, // 1234.56 (grouping yok)
}

extension DecimalFormatX on DecimalFormat {
  String get label {
    switch (this) {
      case DecimalFormat.us:
        return '1,234.56';
      case DecimalFormat.eu:
        return '1.234,56';
      case DecimalFormat.plain:
        return '1234.56';
    }
  }

  /// Persist edeceğimiz değer
  String get key => name;

  static DecimalFormat fromKey(String? raw) {
    if (raw == null || raw.isEmpty) return DecimalFormat.us;
    return DecimalFormat.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => DecimalFormat.us,
    );
  }
}
