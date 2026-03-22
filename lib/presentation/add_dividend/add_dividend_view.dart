import 'package:divfolio/core/constants/app_colors.dart';
import 'package:divfolio/core/constants/app_size.dart';
import 'package:divfolio/core/routes/app_routes.dart';
import 'package:divfolio/core/theme/custom/text_theme.dart';
import 'package:divfolio/core/utils/device_utility.dart';
import 'package:divfolio/data/model/dividend_model.dart';
import 'package:divfolio/widget/button/primary_button.dart';
import 'package:divfolio/widget/field/pay_date_field.dart';
import 'package:divfolio/widget/field/select_field.dart';
import 'package:divfolio/widget/text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../bloc/dividend_bloc/dividend_bloc.dart';
import '../../../bloc/dividend_bloc/dividend_event.dart';
import '../../../bloc/holding_bloc/holding_bloc.dart';
import '../../../bloc/holding_bloc/holding_state.dart';
import '../../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../../bloc/portfolio_bloc/portfolio_state.dart';
import '../../../core/utils/money_extension.dart';
import '../../../data/model/holding_model.dart';
import '../../../widget/bottom_sheet/select_holding_sheet.dart';
import 'add_dividend_cubit.dart';
import 'widget/calculate_section.dart';
import 'widget/mode_tabbar.dart';
import 'widget/net_amount_section.dart';

class AddDividendView extends StatelessWidget {
  const AddDividendView({super.key, this.editingDividend, this.editingHolding});

  final DividendModel? editingDividend;
  final HoldingModel? editingHolding;

  bool get isEditMode => editingDividend != null;

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    return BlocProvider(
      create: (context) {
        final cubit = AddDividendCubit()
          ..initHoldings(context.read<HoldingBloc>());
        if (editingDividend != null) {
          cubit.initFromDividend(editingDividend!, editingHolding);
        }
        return cubit;
      },
      child: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, portfolioState) {
          final currencySymbol = MoneyX.symbolOf(
            portfolioState.selectedPortfolio?.baseCurrencyCode ?? 'USD',
          );

          return BlocBuilder<HoldingBloc, HoldingState>(
            builder: (context, holdingState) {
              return BlocBuilder<AddDividendCubit, AddDividendState>(
                builder: (context, cubitState) {
                  final cubit = context.read<AddDividendCubit>();

                  return Scaffold(
                    resizeToAvoidBottomInset: true,
                    appBar: AppBar(
                      elevation: 0,
                      centerTitle: true,
                      scrolledUnderElevation: 0,
                      surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      title: AppText(
                        text: isEditMode
                            ? 'Edit Dividend'
                            : 'Add Dividend', // ← değişti
                        type: AppTextType.titleMedium,
                      ),
                    ),
                    bottomNavigationBar: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spaceMD,
                          vertical: AppSizes.spaceSM,
                        ),
                        child: PrimaryButton(
                          label: isEditMode
                              ? "Save Changes"
                              : "Save Dividend", // ← değişti
                          onPressed: () =>
                              _save(context, cubitState, portfolioState),
                        ),
                      ),
                    ),
                    body: SafeArea(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.spaceLG,
                          horizontal: AppSizes.spaceMD,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.surfaceDark
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusMD,
                                ),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.borderDark
                                      : AppColors.border,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(
                                      AppSizes.spaceMD,
                                    ),
                                    child: holdingState.loading
                                        ? const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                AppSizes.spaceMD,
                                              ),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : SelectField(
                                            title: "Company",
                                            // ← edit modunda holding değiştirilemez
                                            value:
                                                cubitState.selectedHolding !=
                                                    null
                                                ? "${cubitState.selectedHolding!.companyName} (${cubitState.selectedHolding!.companyId})"
                                                : "Select a holding",
                                            onTap: isEditMode
                                                ? () {} // edit modunda tıklanmaz
                                                : () => _openHoldingPicker(
                                                    context,
                                                  ),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(
                                      AppSizes.spaceMD,
                                    ),
                                    child: PayDateField(
                                      initialDate: cubitState.payDate,
                                      onChanged: cubit.setPayDate,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.spaceMD,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.overlayDark
                                            : AppColors.surface.withValues(
                                                alpha: 0.5,
                                              ),
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.radiusSM,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          ModeTab(
                                            label: "Net Amount",
                                            selected: !cubitState.calculateMode,
                                            onTap: () => cubit.setMode(false),
                                          ),
                                          ModeTab(
                                            label: "Calculate",
                                            selected: cubitState.calculateMode,
                                            onTap: () => cubit.setMode(true),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.spaceMD),
                                  if (!cubitState.calculateMode)
                                    NetAmountSection(
                                      controller: cubit.netAmountCtrl,
                                      currencySymbol: currencySymbol,
                                      isDark: isDark,
                                    ),
                                  if (cubitState.calculateMode)
                                    CalculateSection(
                                      sharesCtrl: cubit.sharesCtrl,
                                      divPerShareCtrl: cubit.divPerShareCtrl,
                                      calculatedNet: cubitState.calculatedNet,
                                      currencySymbol: currencySymbol,
                                      isDark: isDark,
                                      onSharesChanged: (_) =>
                                          cubit.updateCalculatedNet(),
                                      onDivPerShareChanged: (_) =>
                                          cubit.updateCalculatedNet(),
                                    ),
                                  const SizedBox(height: AppSizes.spaceMD),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSizes.spaceXL),
                            AppText(
                              text: "NOTES",
                              type: AppTextType.bodyMedium,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.75,
                              ),
                            ),
                            const SizedBox(height: AppSizes.spaceSM),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.surfaceDark
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusMD,
                                ),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.borderDark
                                      : AppColors.border,
                                ),
                              ),
                              child: TextField(
                                controller: cubit.notesCtrl,
                                maxLines: 3,
                                style: AppTextTheme.textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  hintText: "Add a note (optional)...",
                                  hintStyle: TextStyle(
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(
                                    AppSizes.spaceMD,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSizes.spaceXXL),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _openHoldingPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<HoldingModel>(
      context: context,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: context.read<HoldingBloc>(),
        child: const SelectHoldingSheet(),
      ),
    );
    if (selected != null) {
      context.read<AddDividendCubit>().setHolding(selected);
    }
  }

  void _save(
    BuildContext context,
    AddDividendState cubitState,
    PortfolioState portfolioState,
  ) {
    final cubit = context.read<AddDividendCubit>();
    final holding = cubitState.selectedHolding;
    final pid = holding?.portfolioId ?? portfolioState.selectedPortfolioId;
    final currency =
        portfolioState.selectedPortfolio?.baseCurrencyCode ?? 'USD';

    if (holding == null || pid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a holding.")));
      return;
    }

    double? netOverride;
    double? shares;
    double? divPerShare;

    if (cubitState.calculateMode) {
      shares = double.tryParse(cubit.sharesCtrl.text.trim());
      divPerShare = double.tryParse(cubit.divPerShareCtrl.text.trim());
      if (shares == null || divPerShare == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Enter both shares and dividend per share."),
          ),
        );
        return;
      }
    } else {
      netOverride = double.tryParse(cubit.netAmountCtrl.text.trim());
      if (netOverride == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter the net amount received.")),
        );
        return;
      }
    }

    final now = DateTime.now();
    final dividend = DividendModel(
      id: isEditMode
          ? editingDividend!.id
          : const Uuid().v4(), // ← edit modunda aynı id
      portfolioId: pid,
      holdingId: holding.id,
      payDate: cubitState.payDate,
      sharesAtPayDate: shares ?? holding.shares,
      dividendPerShare: divPerShare ?? 0,
      currencyCode: currency,
      netOverride: netOverride,
      notes: cubit.notesCtrl.text.trim().isEmpty
          ? null
          : cubit.notesCtrl.text.trim(),
      createdAt: isEditMode
          ? editingDividend!.createdAt
          : now, // ← orijinal createdAt korunur
      updatedAt: now,
    );

    context.read<DividendBloc>().add(UpsertDividend(dividend));
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
