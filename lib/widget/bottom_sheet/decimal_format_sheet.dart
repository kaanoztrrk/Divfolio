import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_size.dart';
import '../../core/enum/decimal_format.dart';
import '../../core/utils/device_utility.dart';
import '../../cubit/decimal_format_cubit.dart';
import '../../widget/text/app_text.dart';

class DecimalFormatBottomSheet extends StatelessWidget {
  const DecimalFormatBottomSheet({super.key});

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
                    text: "Decimal Format",
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

            BlocBuilder<DecimalFormatCubit, DecimalFormatState>(
              builder: (context, state) {
                final items = DecimalFormat.values;

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
                        await context.read<DecimalFormatCubit>().select(item);
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
                          Icons.exposure_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      title: AppText(
                        text: item.label,
                        type: AppTextType.titleMedium,
                        fontWeight: FontWeight.w600,
                      ),
                      subtitle: AppText(
                        text: item.key, // "us" / "eu" / "plain"
                        type: AppTextType.labelMedium,
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
