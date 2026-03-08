import 'package:flutter/material.dart';

/// Central design size tokens for the entire application.
/// Use these values instead of magic numbers.
class AppSizes {
  AppSizes._();

  // ---------------------------------------------------------------------------
  // SPACING SYSTEM
  // Used for: padding, margin, gap, SizedBox, layout spacing
  // Rule: All spacing must come from this scale.
  // ---------------------------------------------------------------------------

  /// 0px - No spacing
  static const double space0 = 0;

  /// 4px - Micro spacing (icon gaps, dense UI)
  static const double spaceXS = 4;

  /// 8px - Small spacing
  static const double spaceSM = 8;

  /// 12px - Medium-small spacing
  static const double spaceMD = 12;

  /// 16px - Base spacing (default padding)
  static const double spaceLG = 16;

  /// 20px - Optional intermediate spacing
  static const double spaceXL = 20;

  /// 24px - Large section spacing
  static const double spaceXXL = 24;

  /// 32px - Extra large spacing
  static const double space3XL = 32;

  /// 48px - Section separation spacing
  static const double space4XL = 48;

  // ---------------------------------------------------------------------------
  // TYPOGRAPHY SIZE SCALE
  // Used for: TextStyle.fontSize
  // ---------------------------------------------------------------------------

  /// 10px - Hint, micro labels
  static const double fontXS = 10;

  /// 12px - Caption, helper text
  static const double fontSM = 12;

  /// 14px - Small body text
  static const double fontMD = 14;

  /// 16px - Base body text
  static const double fontLG = 16;

  /// 18px - Subtitle
  static const double fontXL = 18;

  /// 22px - Title
  static const double fontXXL = 22;

  /// 28px - Headline
  static const double font3XL = 28;

  /// 32px - Page title (rare use)
  static const double font4XL = 32;

  // ---------------------------------------------------------------------------
  // LINE HEIGHT SCALE
  // Used for: TextStyle.height
  // ---------------------------------------------------------------------------

  /// Tight line height for titles
  static const double lineHeightTight = 1.15;

  /// Normal reading line height
  static const double lineHeightNormal = 1.35;

  /// Relaxed reading line height
  static const double lineHeightRelaxed = 1.55;

  // ---------------------------------------------------------------------------
  // BORDER RADIUS SCALE
  // Used for: buttons, cards, dialogs, containers
  // ---------------------------------------------------------------------------

  /// 4px - Very small rounding
  static const double radiusXS = 4;

  /// 8px - Small rounding
  static const double radiusSM = 8;

  /// 12px - Default rounding
  static const double radiusMD = 12;

  /// 16px - Large rounding
  static const double radiusLG = 16;

  /// 24px - Extra large rounding
  static const double radiusXL = 24;

  /// Fully rounded shape (circle / pill)
  static const double radiusCircle = 999;

  /// Helper for BorderRadius.circular
  static BorderRadius border(double radius) => BorderRadius.circular(radius);

  // ---------------------------------------------------------------------------
  // ICON SIZE SCALE
  // Used for: Icon widget size
  // ---------------------------------------------------------------------------

  /// 12px - Micro icon
  static const double iconXS = 12;

  /// 16px - Small icon
  static const double iconSM = 16;

  /// 20px - Medium icon
  static const double iconMD = 20;

  /// 24px - Default material icon
  static const double iconLG = 24;

  /// 32px - Large icon
  static const double iconXL = 32;

  /// 48px - Extra large icon
  static const double iconXXL = 48;

  // ---------------------------------------------------------------------------
  // ELEVATION SCALE
  // Used for: Material elevation
  // ---------------------------------------------------------------------------

  /// No shadow
  static const double elevationNone = 0;

  /// Very subtle shadow
  static const double elevationXS = 1;

  /// Small shadow
  static const double elevationSM = 2;

  /// Default card elevation
  static const double elevationMD = 4;

  /// Strong shadow (dialogs, modals)
  static const double elevationLG = 8;

  // ---------------------------------------------------------------------------
  // COMPONENT HEIGHTS
  // Used for: button, input, form fields
  // ---------------------------------------------------------------------------

  /// Small button height
  static const double buttonHeightSM = 40;

  /// Default button height
  static const double buttonHeightMD = 48;

  /// Large button height
  static const double buttonHeightLG = 56;

  /// Small input height
  static const double inputHeightSM = 44;

  /// Default input height
  static const double inputHeightMD = 48;

  /// Large input height
  static const double inputHeightLG = 56;

  // ---------------------------------------------------------------------------
  // LAYOUT CONSTRAINTS
  // Used for: centered forms, dialogs, pages
  // ---------------------------------------------------------------------------

  /// Max width for mobile forms
  static const double maxFormWidth = 520;

  /// Max width for dialogs
  static const double maxDialogWidth = 420;
}
