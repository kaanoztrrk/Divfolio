import 'package:divfolio/core/utils/device_utility.dart';
import 'package:divfolio/widget/text/app_text.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, this.onSettingsTap});

  final VoidCallback? onSettingsTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    final bgColor = isDark ? AppColors.backgroundDark : AppColors.background;

    return AppBar(
      backgroundColor: bgColor,

      // 🔴 Kritik satırlar
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      forceMaterialTransparency: false,

      elevation: 0,
      centerTitle: false,

      title: AppText(
        text: "Divfolio",
        type: AppTextType.titleLarge,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        googleFont: "Audiowide",
      ),
    );
  }
}
