import 'package:flutter/material.dart';

enum AppThemeMode { system, light, dark }

extension AppThemeModeX on AppThemeMode {
  String get label {
    switch (this) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }

  ThemeMode get toFlutter {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  static AppThemeMode fromKey(String? raw) {
    if (raw == null || raw.isEmpty) return AppThemeMode.system;
    return AppThemeMode.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => AppThemeMode.system,
    );
  }
}
