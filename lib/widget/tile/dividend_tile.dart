import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/custom/text_theme.dart';
import '../../data/model/dividend_model.dart';
import '../text/app_text.dart';

class DividendTile extends StatelessWidget {
  const DividendTile({super.key, required this.dividend});
  final DividendModel dividend;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.dividendDetail);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSizes.spaceSM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
          border: Border.all(color: AppColors.border),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceMD,
            vertical: AppSizes.spaceSM,
          ),
          leading: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMD),
            ),
            alignment: Alignment.center,
            child: AppText(
              text: "AAPL",
              type: AppTextType.labelSmall,
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          title: AppText(
            text: "Apple Inc",
            type: AppTextType.titleMedium,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          subtitle: AppText(
            text: "50 Shares",
            type: AppTextType.labelMedium,
            color: AppColors.textSecondary.withValues(alpha: 0.7),
          ),
          trailing: RichText(
            textAlign: TextAlign.end,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "\$45.67\n",
                  style: AppTextTheme.textTheme.titleMedium!.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: "Received",
                  style: AppTextTheme.textTheme.labelSmall!.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
