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
import '../../../bloc/holding/holding_state.dart';
import '../../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../../bloc/portfolio_bloc/portfolio_state.dart';
import '../../../data/model/holding_model.dart';
import 'widget/advanced_options_sections.dart';

class AddDividendView extends StatefulWidget {
  const AddDividendView({super.key});

  @override
  State<AddDividendView> createState() => _AddDividendViewState();
}

class _AddDividendViewState extends State<AddDividendView> {
  final _uuid = const Uuid();

  // Controllers
  final _netAmountCtrl = TextEditingController();
  final _sharesCtrl = TextEditingController();
  final _divPerShareCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  // Local state
  DateTime _payDate = DateTime.now();
  HoldingModel? _selectedHolding;

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
    });
  }

  void _save(BuildContext context, PortfolioState portfolioState) {
    final holding = _selectedHolding;
    final pid = portfolioState.selectedPortfolioId;
    final currency =
        portfolioState.selectedPortfolio?.baseCurrencyCode ?? 'USD';

    // Validasyon
    if (holding == null || pid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a holding.")));
      return;
    }

    final netOverride = double.tryParse(_netAmountCtrl.text.trim());
    final shares = double.tryParse(_sharesCtrl.text.trim());
    final divPerShare = double.tryParse(_divPerShareCtrl.text.trim());

    // Net tutar girilmemişse shares × divPerShare zorunlu
    if (netOverride == null && (shares == null || divPerShare == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Enter net amount or both shares and dividend per share.",
          ),
        ),
      );
      return;
    }

    final now = DateTime.now();

    final dividend = DividendModel(
      id: _uuid.v4(),
      portfolioId: pid,
      holdingId: holding.id,
      payDate: _payDate,
      // netOverride varsa shares/divPerShare sembolik kalır
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

  void _openHoldingPicker(BuildContext context, List<HoldingModel> holdings) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (holdings.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceMD),
                child: AppText(
                  text: "No holdings found. Add a holding first.",
                  type: AppTextType.bodyMedium,
                  color: AppColors.textSecondary,
                ),
              )
            else
              ...holdings.map(
                (h) => ListTile(
                  title: AppText(
                    text: h.companyName,
                    type: AppTextType.bodyLarge,
                  ),
                  subtitle: AppText(
                    text: h.companyId,
                    type: AppTextType.labelMedium,
                    color: AppColors.textSecondary,
                  ),
                  trailing: _selectedHolding?.id == h.id
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    setState(() => _selectedHolding = h);
                    Navigator.pop(context);
                  },
                ),
              ),
            const SizedBox(height: AppSizes.spaceMD),
          ],
        );
      },
    );
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
                  IconButton(
                    onPressed: _reset,
                    icon: const AppText(
                      text: "Reset",
                      type: AppTextType.bodyLarge,
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
                              child: SelectField(
                                title: "Company",
                                value: _selectedHolding != null
                                    ? "${_selectedHolding!.companyName} (${_selectedHolding!.companyId})"
                                    : "Select a holding",
                                onTap: () => _openHoldingPicker(
                                  context,
                                  holdingState.holdings,
                                ),
                              ),
                            ),

                            // Ödeme tarihi
                            Padding(
                              padding: const EdgeInsets.all(AppSizes.spaceMD),
                              child: PayDateField(
                                initialDate: _payDate,
                                onChanged: (d) => setState(() => _payDate = d),
                              ),
                            ),

                            // Net tutar
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.spaceMD,
                                horizontal: AppSizes.spaceMD,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.primary
                                    : AppColors.primary.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                    AppSizes.radiusMD,
                                  ),
                                  bottomRight: Radius.circular(
                                    AppSizes.radiusMD,
                                  ),
                                ),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.borderDark
                                      : AppColors.border,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: "NET AMOUNT RECEIVED",
                                    type: AppTextType.bodyMedium,
                                    fontWeight: isDark
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : AppColors.textPrimary.withValues(
                                            alpha: 0.8,
                                          ),
                                  ),
                                  const SizedBox(height: AppSizes.spaceSM),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      AppText(
                                        text: currencySymbol,
                                        type: AppTextType.headlineLarge,
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? AppColors.icon
                                            : AppColors.primary,
                                      ),
                                      const SizedBox(width: AppSizes.spaceXS),
                                      Expanded(
                                        child: TextField(
                                          controller: _netAmountCtrl,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                decimal: true,
                                              ),
                                          style: AppTextTheme
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textPrimary,
                                              ),
                                          decoration: InputDecoration(
                                            hintText: "0.00",
                                            hintStyle: TextStyle(
                                              color: AppColors.textSecondary
                                                  .withValues(alpha: 0.5),
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
                                        size: 16,
                                        color: isDark
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: AppSizes.spaceXS),
                                      Expanded(
                                        child: AppText(
                                          text:
                                              "Actual amount received after tax withholdings.",
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
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSizes.spaceXL),
                      AppText(
                        text: "ADVANCED OPTIONS",
                        type: AppTextType.bodyMedium,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary.withValues(alpha: 0.75),
                      ),
                      const SizedBox(height: AppSizes.spaceXL),

                      AdvancedOptionsSection(
                        sharesController: _sharesCtrl,
                        divPerShareController: _divPerShareCtrl,
                        notesController: _notesCtrl,
                        portfolioLabel:
                            portfolio?.name ?? 'No portfolio selected',
                        onTapPortfolio: () {},
                        // Portfolio burada değiştirilemez,
                        // seçili portfolio dashboard'dan geliyor
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
