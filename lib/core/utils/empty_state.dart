import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../widget/image/app_image.dart';
import '../../widget/text/app_text.dart';
import 'device_utility.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.imagePath,
    required this.title,
    this.subtitle,
  });

  final String imagePath;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceMD,
                    vertical: AppSizes.spaceMD,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 150,
                          maxHeight: 150,
                        ),
                        child: AppImage(
                          assetPath: imagePath,
                          width: 150,
                          height: 150,
                          color: isDark
                              ? AppColors.background
                              : AppColors.backgroundDark,
                        ),
                      ),

                      const SizedBox(height: AppSizes.spaceXL),

                      AppText(
                        text: title,
                        type: AppTextType.titleMedium,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                      ),

                      if (subtitle != null) ...[
                        const SizedBox(height: AppSizes.spaceSM),
                        AppText(
                          text: subtitle!,
                          type: AppTextType.bodyMedium,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
