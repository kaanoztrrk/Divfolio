import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/init/currency_init.dart';
import '../data/model/currency_model.dart';
import '../service/shared_service.dart';

class CurrencyState {
  const CurrencyState({
    required this.available,
    required this.selected,
    this.loading = false,
  });

  final List<CurrencyModel> available;
  final CurrencyModel selected;
  final bool loading;

  CurrencyState copyWith({
    List<CurrencyModel>? available,
    CurrencyModel? selected,
    bool? loading,
  }) {
    return CurrencyState(
      available: available ?? this.available,
      selected: selected ?? this.selected,
      loading: loading ?? this.loading,
    );
  }
}

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit({SharedService? shared})
    : _shared = shared ?? SharedService(),
      super(
        CurrencyState(
          available: CurrencyDefaults.list,
          selected: CurrencyDefaults.list.first,
          loading: true,
        ),
      );

  final SharedService _shared;

  static const _selectedKey = 'selected_currency_code';

  Future<void> load() async {
    emit(state.copyWith(loading: true));

    // Burada "available" artık local (CurrencyDefaults) sabit liste.
    // Kalıcı olarak sadece "selected currency code" tutuluyor.
    final currencies = List<CurrencyModel>.from(CurrencyDefaults.list)
      ..sort((a, b) => a.code.compareTo(b.code));

    final savedCode = _shared.getString(_selectedKey);

    CurrencyModel selected = currencies.first;

    if (savedCode != null && savedCode.isNotEmpty) {
      final match = currencies.where(
        (c) => c.code.toUpperCase() == savedCode.toUpperCase(),
      );
      if (match.isNotEmpty) selected = match.first;
    }

    emit(
      state.copyWith(available: currencies, selected: selected, loading: false),
    );
  }

  Future<void> select(CurrencyModel currency) async {
    emit(state.copyWith(selected: currency));
    await _shared.setString(_selectedKey, currency.code.toUpperCase());
  }
}
