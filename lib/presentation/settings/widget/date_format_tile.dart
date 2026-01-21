import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';
import '../../../core/enum/date_formatter.dart';
import '../../../cubit/date_format_cubit.dart';
import '../../../widget/text/app_text.dart';

class DateFormatSettingTile extends StatelessWidget {
  const DateFormatSettingTile({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context.select<DateFormatCubit, AppDateFormat>(
      (c) => c.state.format,
    );

    return ListTile(
      onTap: () => _openPicker(context, selected),
      leading: Icon(Icons.event, color: AppColors.primary),
      title: AppText(
        text: "Date Format",
        type: AppTextType.titleMedium,
        fontWeight: FontWeight.w600,
      ),
      subtitle: AppText(
        text: selected.preview(),
        type: AppTextType.labelMedium,
        color: AppColors.textSecondary,
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
    );
  }

  void _openPicker(BuildContext context, AppDateFormat selected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLG),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(AppSizes.spaceMD),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Choose date format",
                type: AppTextType.titleMedium,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: AppSizes.spaceMD),
              ...AppDateFormat.values.map((f) {
                final isSelected = f == selected;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    context.read<DateFormatCubit>().setFormat(f);
                    Navigator.pop(context);
                  },
                  title: AppText(
                    text: f.title,
                    type: AppTextType.titleMedium,
                    fontWeight: FontWeight.w600,
                  ),
                  subtitle: AppText(
                    text: f.preview(),
                    type: AppTextType.labelMedium,
                    color: AppColors.textSecondary,
                  ),
                  trailing: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                );
              }),
              const SizedBox(height: AppSizes.spaceMD),
            ],
          ),
        );
      },
    );
  }
}
