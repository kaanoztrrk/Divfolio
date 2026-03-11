import 'package:divfolio/core/utils/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:divfolio/core/constants/app_colors.dart';

import '../../core/constants/app_size.dart';
import '../dialog/confirm_dialog.dart';

class DeleteSlidableAction extends StatelessWidget {
  const DeleteSlidableAction({
    super.key,
    this.label = 'Delete',
    required this.confirmTitle,
    required this.confirmMessage,
    required this.onConfirm,
  });

  final String label;
  final String confirmTitle;
  final String confirmMessage;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    return SlidableAction(
      onPressed: (_) => ConfirmDialog.show(
        context: context,
        title: confirmTitle,
        message: confirmMessage,
        confirmLabel: 'Delete',
        confirmColor: AppColors.error,
        onConfirm: onConfirm,
      ),
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      foregroundColor: AppColors.error,
      icon: Icons.delete_outline_rounded,
      label: label,
    );
  }
}

class EditSlidableAction extends StatelessWidget {
  const EditSlidableAction({
    super.key,
    this.label = 'Edit',
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    return SlidableAction(
      onPressed: (_) => onPressed(),
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      foregroundColor: AppColors.warning,
      icon: Icons.edit_outlined,
      label: label,
    );
  }
}
