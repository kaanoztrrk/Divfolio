import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/custom/text_theme.dart';

/// Enum for predefined text styles
enum AppTextType {
  displayLarge,
  displayMedium,
  displaySmall,

  headlineLarge,
  headlineMedium,
  headlineSmall,

  titleLarge,
  titleMedium,
  titleSmall,

  bodyXLarge,
  bodyLarge,
  bodyMedium,
  bodySmall,
  bodyXSmall,

  labelLarge,
  labelMedium,
  labelSmall,
}

/// Clean AppText widget (no localization)
class AppText extends StatelessWidget {
  final String text;
  final AppTextType type;

  // optional overrides
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final FontStyle? fontStyle;
  final double? height;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDecoration? decoration;
  final String? googleFont;

  const AppText({
    super.key,
    required this.text,
    required this.type,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.letterSpacing,
    this.fontStyle,
    this.height,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.decoration,
    this.googleFont,
  });

  TextStyle _resolveBaseStyle(TextTheme theme) {
    switch (type) {
      case AppTextType.displayLarge:
        return theme.displayLarge ?? const TextStyle();
      case AppTextType.displayMedium:
        return theme.displayMedium ?? const TextStyle();
      case AppTextType.displaySmall:
        return theme.displaySmall ?? const TextStyle();

      case AppTextType.headlineLarge:
        return theme.headlineLarge ?? const TextStyle();
      case AppTextType.headlineMedium:
        return theme.headlineMedium ?? const TextStyle();
      case AppTextType.headlineSmall:
        return theme.headlineSmall ?? const TextStyle();

      case AppTextType.titleLarge:
        return theme.titleLarge ?? const TextStyle();
      case AppTextType.titleMedium:
        return theme.titleMedium ?? const TextStyle();
      case AppTextType.titleSmall:
        return theme.titleSmall ?? const TextStyle();

      case AppTextType.bodyXLarge:
        return (theme.bodyLarge ?? const TextStyle()).copyWith(fontSize: 18);
      case AppTextType.bodyLarge:
        return theme.bodyLarge ?? const TextStyle();
      case AppTextType.bodyMedium:
        return theme.bodyMedium ?? const TextStyle();
      case AppTextType.bodySmall:
        return theme.bodySmall ?? const TextStyle();
      case AppTextType.bodyXSmall:
        return (theme.bodySmall ?? const TextStyle()).copyWith(fontSize: 10);

      case AppTextType.labelLarge:
        return theme.labelLarge ?? const TextStyle();
      case AppTextType.labelMedium:
        return theme.labelMedium ?? const TextStyle();
      case AppTextType.labelSmall:
        return theme.labelSmall ?? const TextStyle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.textTheme;
    TextStyle style = _resolveBaseStyle(textTheme);

    // Apply overrides
    style = style.copyWith(
      color: color ?? style.color,
      fontSize: fontSize ?? style.fontSize,
      fontWeight: fontWeight ?? style.fontWeight,
      letterSpacing: letterSpacing ?? style.letterSpacing,
      fontStyle: fontStyle ?? style.fontStyle,
      height: height ?? style.height,
      decoration: decoration ?? style.decoration,
      decorationColor: decoration != null ? (color ?? style.color) : null,
    );

    // Safe Google Font
    if (googleFont != null) {
      try {
        style = GoogleFonts.getFont(googleFont!, textStyle: style);
      } catch (_) {
        // Eğer yanlış font ismi gelirse crash olmasın
      }
    }

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}
