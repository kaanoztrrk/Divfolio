import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget to display an SVG image from assets with optional customization.
class AppImage extends StatelessWidget {
  /// Path to the SVG asset, e.g. `Assets.icons.logo.appLogo`.
  final String assetPath;

  /// Optional width of the image.
  final double? width;

  /// Optional height of the image.
  final double? height;

  /// How the image should be inscribed into the space allocated.
  /// Defaults to [BoxFit.contain].
  final BoxFit fit;

  /// Optional color to apply to the SVG.
  final Color? color;

  /// Optional callback when the image is tapped.
  final VoidCallback? onTap;

  /// Optional placeholder widget to show while loading or on error.
  final Widget? placeholder;

  /// If true, the image is clipped into a circle.
  final bool circleImage;

  const AppImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.onTap,
    this.placeholder,
    this.circleImage = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      placeholderBuilder: (context) =>
          placeholder ??
          Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.image_not_supported, size: 24),
            ),
          ),
    );

    // Apply circular clipping if requested.
    if (circleImage) {
      imageWidget = ClipOval(
        child: SizedBox(width: width, height: height, child: imageWidget),
      );
    }

    // Wrap with GestureDetector if onTap is provided.
    if (onTap != null) {
      imageWidget = GestureDetector(onTap: onTap, child: imageWidget);
    }

    return imageWidget;
  }
}
