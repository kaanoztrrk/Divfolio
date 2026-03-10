// money_extension.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../cubit/decimal_format_cubit.dart';
import '../../core/enum/decimal_format.dart';

extension MoneyX on num {
  /// Sadece sayıyı formatlar.
  /// Sembol UI tarafından portfolio.baseCurrencyCode'a göre eklenir.
  String formatAmount(BuildContext context) {
    final format = context.read<DecimalFormatCubit>().state.selected;
    final locale = _localeOf(format);
    final useGrouping = _useGrouping(format);

    // Ondalık basamak sayısı sabit 2
    final nf = NumberFormat.decimalPattern(locale)
      ..minimumFractionDigits = 2
      ..maximumFractionDigits = 2;

    var out = nf.format(toDouble());

    if (!useGrouping) {
      out = out.replaceAll(locale == 'en_US' ? ',' : '.', '');
    }

    return out;
  }

  /// Sembol + formatlanmış sayı.
  /// Sembol dışarıdan verilir, portfolio.baseCurrencyCode'dan türetilir.
  String moneyWithSymbol(BuildContext context, String currencyCode) {
    final symbol = symbolOf(currencyCode);
    return '$symbol${formatAmount(context)}';
  }

  String _localeOf(DecimalFormat f) {
    switch (f) {
      case DecimalFormat.us:
        return 'en_US';
      case DecimalFormat.eu:
        return 'de_DE';
      case DecimalFormat.plain:
        return 'en_US';
    }
  }

  bool _useGrouping(DecimalFormat f) {
    switch (f) {
      case DecimalFormat.us:
      case DecimalFormat.eu:
        return true;
      case DecimalFormat.plain:
        return false;
    }
  }

  static String symbolOf(String code) {
    switch (code.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'TRY':
        return '₺';
      default:
        return code;
    }
  }
}
