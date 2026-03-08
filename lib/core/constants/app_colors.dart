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

  // ---------------------------------------------------------------------------
  // BACKGROUND COLORS (DARK)
  // ---------------------------------------------------------------------------

  /// App main background (deep slate)
  static const backgroundDark = Color(0xFF0B1220);

  /// Card, sheet, container background
  static const surfaceDark = Color(0xFF121A2B);

  /// Elevated surfaces
  static const surfaceHighDark = Color(0xFF1A2338);

  // ---------------------------------------------------------------------------
  // TEXT COLORS (DARK)
  // ---------------------------------------------------------------------------

  /// Main readable text (near-white)
  static const textPrimaryDark = Color(0xFFE5E7EB);

  /// Secondary / muted text
  static const textSecondaryDark = Color(0xFF9CA3AF);

  /// Disabled / hint
  static const textDisabledDark = Color(0xFF6B7280);

  // ---------------------------------------------------------------------------
  // BORDER & DIVIDER (DARK)
  // ---------------------------------------------------------------------------

  static const borderDark = Color(0xFF243044);
  static const dividerDark = Color(0xFF1F2937);

  // ---------------------------------------------------------------------------
  // ICON / OVERLAY (DARK)
  // ---------------------------------------------------------------------------

  static const iconDark = Color(0xFFCBD5E1);
  static const overlayDark = Color(0x33000000);
}
