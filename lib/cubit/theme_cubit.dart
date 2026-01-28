import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/enum/theme_enum.dart';
import '../service/shared_service.dart';

class ThemeState {
  const ThemeState({required this.selected, this.loading = false});

  final AppThemeMode selected;
  final bool loading;

  ThemeState copyWith({AppThemeMode? selected, bool? loading}) {
    return ThemeState(
      selected: selected ?? this.selected,
      loading: loading ?? this.loading,
    );
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({SharedService? shared})
    : _shared = shared ?? SharedService(),
      super(const ThemeState(selected: AppThemeMode.system, loading: true));

  final SharedService _shared;

  static const _key = 'theme_mode';

  Future<void> load() async {
    emit(state.copyWith(loading: true));

    final raw = _shared.getString(_key);
    final selected = AppThemeModeX.fromKey(raw);

    emit(state.copyWith(selected: selected, loading: false));
  }

  Future<void> select(AppThemeMode mode) async {
    emit(state.copyWith(selected: mode));
    await _shared.setString(_key, mode.name);
  }
}
