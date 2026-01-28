import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/enum/decimal_format.dart';
import '../service/shared_service.dart';

class DecimalFormatState {
  const DecimalFormatState({required this.selected, this.loading = false});

  final DecimalFormat selected;
  final bool loading;

  DecimalFormatState copyWith({DecimalFormat? selected, bool? loading}) {
    return DecimalFormatState(
      selected: selected ?? this.selected,
      loading: loading ?? this.loading,
    );
  }
}

class DecimalFormatCubit extends Cubit<DecimalFormatState> {
  DecimalFormatCubit({SharedService? shared})
    : _shared = shared ?? SharedService(),
      super(
        const DecimalFormatState(selected: DecimalFormat.us, loading: true),
      );

  final SharedService _shared;

  static const _key = 'decimal_format';

  Future<void> load() async {
    emit(state.copyWith(loading: true));

    final saved = _shared.getString(_key);
    final selected = DecimalFormatX.fromKey(saved);

    emit(state.copyWith(selected: selected, loading: false));
  }

  Future<void> select(DecimalFormat format) async {
    emit(state.copyWith(selected: format));
    await _shared.setString(_key, format.key);
  }
}
