import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // BRAND COLORS
  // ---------------------------------------------------------------------------

  /// Primary brand color (finance blue)
  static const primary = Color(0xFF10B981);

  /// Secondary accent (dividend green)
  static const secondary = Color(
    0xFF008073,
  ); // daha temiz, light theme’de daha okunur

  // ---------------------------------------------------------------------------
  // BACKGROUND COLORS (LIGHT)
  // ---------------------------------------------------------------------------

  /// App main background (very light gray)
  static const background = Color(0xFFF8F9FA);

  /// Card, sheet, container background
  static const surface = Color(0xFFFFFFFF);

  /// Elevated surfaces (dialogs, modals, filled sections)
  static const surfaceHigh = Color(0xFFF1F3F6);

  // ---------------------------------------------------------------------------
  // TEXT COLORS (LIGHT)
  // ---------------------------------------------------------------------------

  /// Main readable text (near-black)
  static const textPrimary = Color(0xFF0F172A);

  /// Secondary / muted text
  static const textSecondary = Color(0xFF64748B);

  /// Disabled or hint text
  static const textDisabled = Color(0xFF94A3B8);

  // ---------------------------------------------------------------------------
  // STATUS COLORS
  // ---------------------------------------------------------------------------

  /// Positive values, profit, success
  static const success = Color(0xFF16A34A);

  /// Warning, attention
  static const warning = Color(0xFFF59E0B);

  /// Error, negative values
  static const error = Color(0xFFEF4444);

  // ---------------------------------------------------------------------------
  // BORDER & DIVIDER (LIGHT)
  // ---------------------------------------------------------------------------

  /// Card / input border
  static const border = Color(0xFFE5E7EB);

  /// Divider color
  static const divider = Color(0xFFEAECEF);

  // ---------------------------------------------------------------------------
  // OPTIONAL: ICON / OVERLAY
  // ---------------------------------------------------------------------------

  static const icon = Color(0xFF475569);

  /// subtle shadow/overlay tint
  static const overlay = Color(0x0F0F172A);
}
