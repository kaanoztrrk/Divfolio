import 'package:divfolio/core/enum/date_formatter.dart';
import 'package:divfolio/core/enum/decimal_format.dart';
import 'package:divfolio/cubit/decimal_format_cubit.dart';
import 'package:flutter/material.dart';
import 'package:divfolio/widget/text/app_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../cubit/currency_cubit.dart';
import '../../cubit/date_format_cubit.dart';
import '../../cubit/theme_cubit.dart';
import '../../widget/bottom_sheet/currency_bottom_sheet.dart';
import '../../widget/bottom_sheet/date_format_sheet.dart';
import '../../widget/bottom_sheet/decimal_format_sheet.dart';
import '../../widget/bottom_sheet/theme_sheet.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceXL,
            vertical: AppSizes.spaceLG,
          ),
          children: [
            const _SectionTitle('Interface'),
            const SizedBox(height: AppSizes.spaceMD),
            _SettingsCard(
              children: [
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return _SettingsTile(
                      icon: Icons.dark_mode_rounded,
                      title: 'Appearance',
                      value: state.selected.name,
                      onTap: () async {
                        final cubit = context.read<ThemeCubit>();

                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: AppColors.surface,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(AppSizes.radiusLG),
                            ),
                          ),
                          builder: (_) => BlocProvider.value(
                            value: cubit,
                            child: const ThemeBottomSheet(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceXL),
            const _SectionTitle('Preferences'),
            const SizedBox(height: AppSizes.spaceMD),
            _SettingsCard(
              children: [
                BlocBuilder<CurrencyCubit, CurrencyState>(
                  builder: (context, state) {
                    return _SettingsTile(
                      icon: Icons.attach_money_rounded,
                      title: 'Default Currency',
                      value:
                          '${state.selected.code} (${state.selected.symbol})',
                      onTap: () async {
                        final cubit = context.read<DecimalFormatCubit>();

                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: AppColors.surface,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(AppSizes.radiusLG),
                            ),
                          ),
                          builder: (_) => BlocProvider.value(
                            value: cubit,
                            child: const DecimalFormatBottomSheet(),
                          ),
                        );
                      },
                    );
                  },
                ),
                const _SettingsDivider(),
                BlocBuilder<DecimalFormatCubit, DecimalFormatState>(
                  builder: (context, state) {
                    return _SettingsTile(
                      icon: Icons.exposure_rounded,
                      title: 'Decimal Format',
                      value: state.selected.label,
                      onTap: () async {
                        final cubit = context.read<DecimalFormatCubit>();

                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: AppColors.surface,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(AppSizes.radiusLG),
                            ),
                          ),
                          builder: (_) => BlocProvider.value(
                            value: cubit,
                            child: const DecimalFormatBottomSheet(),
                          ),
                        );
                      },
                    );
                  },
                ),
                const _SettingsDivider(),
                BlocBuilder<DateFormatCubit, DateFormatState>(
                  builder: (context, state) {
                    return _SettingsTile(
                      icon: Icons.calendar_month_rounded,
                      title: 'Date Format',
                      value: state.selected.previewNow(),
                      onTap: () async {
                        final cubit = context.read<DateFormatCubit>();

                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: AppColors.surface,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(AppSizes.radiusLG),
                            ),
                          ),
                          builder: (_) => BlocProvider.value(
                            value: cubit,
                            child: const DateFormatBottomSheet(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceXL),
            const _SectionTitle('Data Management'),
            const SizedBox(height: AppSizes.spaceMD),
            const _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.document_scanner,
                  title: 'Export Data to CSV',
                  value: 'System',
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceXL),
            const _SectionTitle('About'),
            const SizedBox(height: AppSizes.spaceMD),
            const _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'Privacy Policy',
                  value: '',
                ),
                _SettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'Terms of Service',
                  value: '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: text,
      type: AppTextType.titleMedium,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary.withValues(alpha: 0.75),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        child: Column(children: children),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final iconBg = AppColors.primary.withValues(alpha: 0.12);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceMD,
          vertical: AppSizes.spaceSM,
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(AppSizes.radiusMD),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: AppSizes.spaceMD),
            Expanded(
              child: AppText(
                text: title,
                type: AppTextType.titleMedium,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppText(
              text: value,
              type: AppTextType.bodyMedium,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSizes.spaceXS),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: AppColors.divider);
  }
}
