import 'package:intl/intl.dart';

enum AppDateFormat {
  ddMMyyyySlash, // 24/10/2023
  mmDDyyyySlash, // 10/24/2023
  yyyyMMddDash, // 2023-10-24
  ddMMMyyyy, // 24 Oct 2023
  MMMddyyyy, // Oct 24, 2023
  ddMMyyyyDot, // 24.10.2023
}

extension AppDateFormatX on AppDateFormat {
  String get pattern {
    switch (this) {
      case AppDateFormat.ddMMyyyySlash:
        return 'dd/MM/yyyy';
      case AppDateFormat.mmDDyyyySlash:
        return 'MM/dd/yyyy';
      case AppDateFormat.yyyyMMddDash:
        return 'yyyy-MM-dd';
      case AppDateFormat.ddMMMyyyy:
        return 'dd MMM yyyy';
      case AppDateFormat.MMMddyyyy:
        return 'MMM dd, yyyy';
      case AppDateFormat.ddMMyyyyDot:
        return 'dd.MM.yyyy';
    }
  }

  String get title {
    switch (this) {
      case AppDateFormat.ddMMyyyySlash:
        return 'DD/MM/YYYY';
      case AppDateFormat.mmDDyyyySlash:
        return 'MM/DD/YYYY';
      case AppDateFormat.yyyyMMddDash:
        return 'YYYY-MM-DD';
      case AppDateFormat.ddMMMyyyy:
        return 'DD MMM YYYY';
      case AppDateFormat.MMMddyyyy:
        return 'MMM DD, YYYY';
      case AppDateFormat.ddMMyyyyDot:
        return 'DD.MM.YYYY';
    }
  }

  String format(DateTime date, {String? locale}) {
    return DateFormat(pattern, locale).format(date);
  }

  String preview({String? locale}) {
    final sample = DateTime(2023, 10, 24);
    return format(sample, locale: locale);
  }
}
