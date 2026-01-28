import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../core/enum/decimal_format.dart';
import '../../cubit/decimal_format_cubit.dart' hide DecimalFormat;
import '../../widget/text/app_text.dart';

class DecimalFormatBottomSheet extends StatelessWidget {
  const DecimalFormatBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
                  separatorBuilder: (_, __) =>
                      Divider(color: AppColors.divider),
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
                        fontWeight: FontWeight.w700,
                      ),
                      subtitle: AppText(
                        text: item.key, // "us" / "eu" / "plain"
                        type: AppTextType.labelMedium,
                        color: AppColors.textSecondary,
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primary,
                            )
                          : Icon(
                              Icons.circle_outlined,
                              color: AppColors.border,
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
