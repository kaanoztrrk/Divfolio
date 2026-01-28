import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../cubit/currency_cubit.dart';
import '../../cubit/decimal_format_cubit.dart';
import '../../core/enum/decimal_format.dart';

extension MoneyX on num {
  String money(BuildContext context, {bool withSymbol = true}) {
    // Bu iki satır UI'da rebuild tetiklemez. Rebuild'i widget tarafında BlocBuilder/watch ile yap.
    final currency = context.read<CurrencyCubit>().state.selected;
    final format = context.read<DecimalFormatCubit>().state.selected;

    final locale = _localeOf(format);
    final useGrouping = _useGrouping(format);

    final nf = NumberFormat.decimalPattern(locale)
      ..minimumFractionDigits = currency.decimals
      ..maximumFractionDigits = currency.decimals;

    var out = nf.format(toDouble());

    if (!useGrouping) {
      // locale'e göre binlik ayraçları kaldır
      out = out.replaceAll(locale == 'en_US' ? ',' : '.', '');
    }

    return withSymbol ? '${currency.symbol}$out' : out;
  }

  String _localeOf(DecimalFormat f) {
    switch (f) {
      case DecimalFormat.us:
        return 'en_US'; // 1,234.56
      case DecimalFormat.eu:
        return 'de_DE'; // 1.234,56
      case DecimalFormat.plain:
        return 'en_US'; // grouping kapalıyken fark etmiyor
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
}
