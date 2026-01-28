import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/enum/date_formatter.dart';
import '../service/shared_service.dart';

class DateFormatState {
  const DateFormatState({required this.selected, this.loading = false});

  final AppDateFormat selected;
  final bool loading;

  DateFormatState copyWith({AppDateFormat? selected, bool? loading}) {
    return DateFormatState(
      selected: selected ?? this.selected,
      loading: loading ?? this.loading,
    );
  }
}

class DateFormatCubit extends Cubit<DateFormatState> {
  DateFormatCubit({SharedService? shared})
    : _shared = shared ?? SharedService(),
      super(
        const DateFormatState(selected: AppDateFormat.MMMddyyyy, loading: true),
      );

  final SharedService _shared;

  static const _key = 'date_format';

  Future<void> load() async {
    emit(state.copyWith(loading: true));

    final raw = _shared.getString(_key);

    final selected = AppDateFormat.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => AppDateFormat.MMMddyyyy,
    );

    emit(state.copyWith(selected: selected, loading: false));
  }

  Future<void> select(AppDateFormat format) async {
    emit(state.copyWith(selected: format));
    await _shared.setString(_key, format.name);
  }
}
