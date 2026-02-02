import 'package:divfolio/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../text/app_text.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.showFab,
  });

  final int currentIndex;
  final void Function(int) onTap;
  final bool showFab;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: showFab ? const CircularNotchedRectangle() : null,
      notchMargin: 10,
      child: SizedBox(
        height: 72, // overflow fix
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavItem(
                    icon: Iconsax.home_2,
                    label: 'Dashboard',
                    selected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _NavItem(
                    icon: Iconsax.wallet_3,
                    label: 'Portfolios',
                    selected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                ],
              ),
            ),

            // FAB notch alanı
            SizedBox(width: showFab ? 72 : 0),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavItem(
                    icon: Iconsax.receipt_item,
                    label: 'History',
                    selected: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                  _NavItem(
                    icon: Iconsax.setting_4,
                    label: 'Settings',
                    selected: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : Colors.grey;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(height: 2),
                AppText(
                  text: label,
                  type: AppTextType.labelSmall,
                  color: color,
                  maxLines: 1,
                  overflow: TextOverflow.visible, // ❗️ellipsis YOK
                  textAlign: TextAlign.center,
                  height: 1.1,
                  letterSpacing: -0.2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
