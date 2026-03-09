import 'package:divfolio/core/constants/app_colors.dart';
import 'package:divfolio/core/constants/app_size.dart';
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
import '../../../bloc/holding/holding_bloc.dart';
import '../../../bloc/holding/holding_event.dart';
import '../../../bloc/holding/holding_state.dart';
import '../../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../../bloc/portfolio_bloc/portfolio_state.dart';
import '../../../data/model/holding_model.dart';
import '../../../widget/bottom_sheet/select_holding_sheet.dart';

class AddDividendView extends StatefulWidget {
  const AddDividendView({super.key});

  @override
  State<AddDividendView> createState() => _AddDividendViewState();
}

class _AddDividendViewState extends State<AddDividendView> {
  final _uuid = const Uuid();

  final _netAmountCtrl = TextEditingController();
  final _sharesCtrl = TextEditingController();
  final _divPerShareCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  DateTime _payDate = DateTime.now();
  HoldingModel? _selectedHolding;

  // false → Net Amount modu, true → Calculate modu
  bool _calculateMode = false;

  @override
  void initState() {
    super.initState();
    _sharesCtrl.addListener(_onCalculate);
    _divPerShareCtrl.addListener(_onCalculate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HoldingBloc>().add(const LoadAllHoldings());
    });
  }

  void _onCalculate() => setState(() {}); // hesaplanan tutarı güncellemek için

  double get _calculatedNet {
    final shares = double.tryParse(_sharesCtrl.text.trim()) ?? 0;
    final divPerShare = double.tryParse(_divPerShareCtrl.text.trim()) ?? 0;
    return shares * divPerShare;
  }

  @override
  void dispose() {
    _netAmountCtrl.dispose();
    _sharesCtrl.dispose();
    _divPerShareCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _reset() {
    _netAmountCtrl.clear();
    _sharesCtrl.clear();
    _divPerShareCtrl.clear();
    _notesCtrl.clear();
    setState(() {
      _payDate = DateTime.now();
      _selectedHolding = null;
      _calculateMode = false;
    });
  }

  void _save(BuildContext context, PortfolioState portfolioState) {
    final holding = _selectedHolding;
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

    if (_calculateMode) {
      // Calculate modu → shares × divPerShare zorunlu
      shares = double.tryParse(_sharesCtrl.text.trim());
      divPerShare = double.tryParse(_divPerShareCtrl.text.trim());
      if (shares == null || divPerShare == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Enter both shares and dividend per share."),
          ),
        );
        return;
      }
      // netOverride yok, hesaplanan değer kullanılır
    } else {
      // Net Amount modu → netOverride zorunlu
      netOverride = double.tryParse(_netAmountCtrl.text.trim());
      if (netOverride == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter the net amount received.")),
        );
        return;
      }
    }

    final now = DateTime.now();

    final dividend = DividendModel(
      id: _uuid.v4(),
      portfolioId: pid,
      holdingId: holding.id,
      payDate: _payDate,
      sharesAtPayDate: shares ?? holding.shares,
      dividendPerShare: divPerShare ?? 0,
      currencyCode: currency,
      netOverride: netOverride,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      createdAt: now,
      updatedAt: now,
    );

    context.read<DividendBloc>().add(UpsertDividend(dividend));
    Navigator.pop(context);
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
      setState(() => _selectedHolding = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, portfolioState) {
        final portfolio = portfolioState.selectedPortfolio;
        final currencySymbol = _currencySymbol(
          portfolio?.baseCurrencyCode ?? 'USD',
        );

        return BlocBuilder<HoldingBloc, HoldingState>(
          builder: (context, holdingState) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: const AppText(
                  text: 'Add Dividend',
                  type: AppTextType.titleMedium,
                ),
                actions: [
                  TextButton(
                    onPressed: _reset,
                    child: const AppText(
                      text: "Reset",
                      type: AppTextType.bodyMedium,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.spaceMD,
                    AppSizes.spaceSM,
                    AppSizes.spaceMD,
                    AppSizes.spaceMD,
                  ),
                  child: PrimaryButton(
                    label: "Save Dividend",
                    onPressed: () => _save(context, portfolioState),
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
                      // ---- MAIN CARD ----
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
                            // Holding seç
                            Padding(
                              padding: const EdgeInsets.all(AppSizes.spaceMD),
                              child: holdingState.loading
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          AppSizes.spaceMD,
                                        ),
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : SelectField(
                                      title: "Company",
                                      value: _selectedHolding != null
                                          ? "${_selectedHolding!.companyName} (${_selectedHolding!.companyId})"
                                          : "Select a holding",
                                      onTap: () => _openHoldingPicker(context),
                                    ),
                            ),

                            // Pay date
                            Padding(
                              padding: const EdgeInsets.all(AppSizes.spaceMD),
                              child: PayDateField(
                                initialDate: _payDate,
                                onChanged: (d) => setState(() => _payDate = d),
                              ),
                            ),

                            // Mode toggle
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
                                    _ModeTab(
                                      label: "Net Amount",
                                      selected: !_calculateMode,
                                      onTap: () => setState(
                                        () => _calculateMode = false,
                                      ),
                                    ),
                                    _ModeTab(
                                      label: "Calculate",
                                      selected: _calculateMode,
                                      onTap: () =>
                                          setState(() => _calculateMode = true),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: AppSizes.spaceMD),

                            // ---- NET AMOUNT MODU ----
                            if (!_calculateMode)
                              _AmountSection(
                                isDark: isDark,
                                currencySymbol: currencySymbol,
                                controller: _netAmountCtrl,
                                title: "NET AMOUNT RECEIVED",
                                hint: "0.00",
                                info:
                                    "Actual amount received after tax withholdings.",
                              ),

                            // ---- CALCULATE MODU ----
                            if (_calculateMode)
                              _CalculateSection(
                                isDark: isDark,
                                currencySymbol: currencySymbol,
                                sharesCtrl: _sharesCtrl,
                                divPerShareCtrl: _divPerShareCtrl,
                                calculatedNet: _calculatedNet,
                              ),

                            const SizedBox(height: AppSizes.spaceMD),
                          ],
                        ),
                      ),

                      // ---- NOTES ----
                      const SizedBox(height: AppSizes.spaceXL),
                      AppText(
                        text: "NOTES",
                        type: AppTextType.bodyMedium,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary.withValues(alpha: 0.75),
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
                          controller: _notesCtrl,
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
  }

  String _currencySymbol(String code) {
    switch (code.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'TRY':
        return '₺';
      default:
        return code;
    }
  }
}

// ---- MODE TAB ----
class _ModeTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceSM),
          decoration: BoxDecoration(
            color: selected
                ? (isDark ? AppColors.surfaceDark : AppColors.surface)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusSM),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: AppText(
              text: label,
              type: AppTextType.bodyMedium,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ---- NET AMOUNT SECTION ----
class _AmountSection extends StatelessWidget {
  final bool isDark;
  final String currencySymbol;
  final TextEditingController controller;
  final String title;
  final String hint;
  final String info;

  const _AmountSection({
    required this.isDark,
    required this.currencySymbol,
    required this.controller,
    required this.title,
    required this.hint,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
      padding: const EdgeInsets.all(AppSizes.spaceMD),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary
            : AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: title,
            type: AppTextType.bodyMedium,
            fontWeight: isDark ? FontWeight.w600 : FontWeight.w500,
            color: isDark
                ? AppColors.textPrimary
                : AppColors.textPrimary.withValues(alpha: 0.8),
          ),
          const SizedBox(height: AppSizes.spaceSM),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                text: currencySymbol,
                type: AppTextType.headlineLarge,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.icon : AppColors.primary,
              ),
              const SizedBox(width: AppSizes.spaceXS),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: AppTextTheme.textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceSM),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: isDark ? AppColors.textPrimary : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSizes.spaceXS),
              Expanded(
                child: AppText(
                  text: info,
                  type: AppTextType.labelSmall,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---- CALCULATE SECTION ----
class _CalculateSection extends StatelessWidget {
  final bool isDark;
  final String currencySymbol;
  final TextEditingController sharesCtrl;
  final TextEditingController divPerShareCtrl;
  final double calculatedNet;

  const _CalculateSection({
    required this.isDark,
    required this.currencySymbol,
    required this.sharesCtrl,
    required this.divPerShareCtrl,
    required this.calculatedNet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
      padding: const EdgeInsets.all(AppSizes.spaceMD),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary
            : AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shares + Div/Share yan yana
          Row(
            children: [
              Expanded(
                child: _CalcField(
                  isDark: isDark,
                  label: "SHARES OWNED",
                  controller: sharesCtrl,
                  hint: "0",
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: AppSizes.spaceMD),
              Expanded(
                child: _CalcField(
                  isDark: isDark,
                  label: "DIV / SHARE",
                  controller: divPerShareCtrl,
                  hint: "0.00",
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spaceMD),

          // Hesaplanan tutar
          Container(
            padding: const EdgeInsets.all(AppSizes.spaceSM),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSizes.radiusSM),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: "Estimated Net",
                  type: AppTextType.bodyMedium,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textSecondary,
                ),
                AppText(
                  text: "$currencySymbol${calculatedNet.toStringAsFixed(2)}",
                  type: AppTextType.bodyMedium,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceSM),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: isDark ? AppColors.textPrimary : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSizes.spaceXS),
              Expanded(
                child: AppText(
                  text: "Shares × Dividend per share. Tax not included.",
                  type: AppTextType.labelSmall,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---- CALC FIELD ----
class _CalcField extends StatelessWidget {
  final bool isDark;
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const _CalcField({
    required this.isDark,
    required this.label,
    required this.controller,
    required this.hint,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: label,
          type: AppTextType.labelSmall,
          color: isDark ? AppColors.textPrimary : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: AppSizes.spaceXS),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTextTheme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.4),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.border,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.border,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppSizes.spaceSM,
            ),
          ),
        ),
      ],
    );
  }
}
