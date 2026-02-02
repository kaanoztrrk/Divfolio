import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../core/enum/date_formatter.dart';
import '../../core/utils/device_utility.dart';
import '../../cubit/date_format_cubit.dart';
import '../text/app_text.dart';

class DateFormatBottomSheet extends StatelessWidget {
  const DateFormatBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceMD),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: AppText(
                    text: "Date Format",
                    type: AppTextType.titleMedium,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceMD),

            BlocBuilder<DateFormatCubit, DateFormatState>(
              builder: (context, state) {
                final items = AppDateFormat.values;

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => Divider(
                    color: isDark ? AppColors.dividerDark : AppColors.divider,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item == state.selected;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () async {
                        await context.read<DateFormatCubit>().select(item);
                        if (context.mounted) Navigator.pop(context);
                      },
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMD,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.calendar_month_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      title: AppText(
                        text: item
                            .previewNow(), // örn: 27.01.2026 / 01/27/2026 / 27 Jan 2026
                        type: AppTextType.titleMedium,
                        fontWeight: FontWeight.w600,
                      ),
                      subtitle: AppText(
                        text: item
                            .pattern, // istersen küçük bilgi olarak kalsın (dd/MM/yyyy)
                        type: AppTextType.labelSmall,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primary,
                            )
                          : Icon(
                              Icons.circle_outlined,
                              color: isDark
                                  ? AppColors.borderDark
                                  : AppColors.border,
                            ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: AppSizes.spaceMD),
          ],
        ),
      ),
    );
  }
}
