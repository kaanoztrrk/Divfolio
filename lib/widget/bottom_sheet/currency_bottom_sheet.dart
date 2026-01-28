import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../cubit/currency_cubit.dart';
import '../../widget/text/app_text.dart';

class CurrencyBottomSheet extends StatelessWidget {
  const CurrencyBottomSheet({super.key});

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
                    text: "Select Currency",
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

            BlocBuilder<CurrencyCubit, CurrencyState>(
              builder: (context, state) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.available.length,
                  separatorBuilder: (_, __) =>
                      Divider(color: AppColors.divider),
                  itemBuilder: (context, index) {
                    final item = state.available[index];
                    final isSelected =
                        item.code.toUpperCase() ==
                        state.selected.code.toUpperCase();

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () async {
                        await context.read<CurrencyCubit>().select(item);
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
                        child: AppText(
                          text: item.symbol,
                          type: AppTextType.titleMedium,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      title: AppText(
                        text: item.code,
                        type: AppTextType.titleMedium,
                        fontWeight: FontWeight.w700,
                      ),
                      subtitle: item.name == null
                          ? null
                          : AppText(
                              text: item.name!,
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
