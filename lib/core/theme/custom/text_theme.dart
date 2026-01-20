import 'package:flutter/material.dart';

class AppTextTheme {
  AppTextTheme._();

  static const _fontFamily = 'Poppins';

  static TextTheme get textTheme {
    return TextTheme(
      // Display (büyük hero yazılar, splash / onboarding başlıkları)
      displayLarge: _style(size: 57, weight: FontWeight.w400),
      displayMedium: _style(size: 45, weight: FontWeight.w400),
      displaySmall: _style(size: 36, weight: FontWeight.w400),

      // Headline (ekran içi ana başlıklar)
      headlineLarge: _style(size: 32, weight: FontWeight.w600),
      headlineMedium: _style(size: 28, weight: FontWeight.w600),
      headlineSmall: _style(size: 24, weight: FontWeight.w600),

      // Title (section başlıkları, card başlıkları)
      titleLarge: _style(size: 22, weight: FontWeight.w600),
      titleMedium: _style(size: 16, weight: FontWeight.w500),
      titleSmall: _style(size: 14, weight: FontWeight.w500),

      // Body (içerik yazıları)
      bodyLarge: _style(size: 16, weight: FontWeight.w400),
      bodyMedium: _style(size: 14, weight: FontWeight.w400),
      bodySmall: _style(size: 12, weight: FontWeight.w400),

      // Label (buton, chip, küçük etiketler)
      labelLarge: _style(size: 14, weight: FontWeight.w500),
      labelMedium: _style(size: 12, weight: FontWeight.w500),
      labelSmall: _style(size: 11, weight: FontWeight.w500),
    );
  }

  static TextStyle _style({required double size, required FontWeight weight}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: size,
      fontWeight: weight,
      height: 1.2,
    );
  }
}
