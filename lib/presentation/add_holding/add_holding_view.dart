import 'package:divfolio/cubit/currency_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/holding/holding_bloc.dart';
import '../../bloc/holding/holding_event.dart';
import '../../bloc/holding/holding_state.dart';
import '../../constants/app_size.dart';
import '../../core/utils/device_utility.dart';
import '../../widget/button/primary_button.dart';
import '../../widget/field/app_label_field.dart';
import '../../widget/field/mini_input_field.dart';
import '../../widget/field/pay_date_field.dart';
import '../../widget/field/portfolio_select_field.dart';
import '../../widget/text/app_text.dart';
import 'widget/holding_cost_summary.dart';

class AddHoldingView extends StatefulWidget {
  const AddHoldingView({super.key});

  @override
  State<AddHoldingView> createState() => _AddHoldingViewState();
}

class _AddHoldingViewState extends State<AddHoldingView> {
  late TextEditingController _sharesCtrl;
  late TextEditingController _avgCostCtrl;

  @override
  void initState() {
    super.initState();
    final state = context.read<HoldingBloc>().state;
    _sharesCtrl = TextEditingController(
      text: state.shares == 0 ? '' : state.shares.toString(),
    );
    _avgCostCtrl = TextEditingController(
      text: state.avgCost != null ? state.avgCost!.toStringAsFixed(2) : '',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<HoldingBloc>().state;
    // Bloc state değişirse controller güncelle
    _sharesCtrl.value = _sharesCtrl.value.copyWith(
      text: state.shares == 0 ? '' : state.shares.toString(),
    );
    _avgCostCtrl.value = _avgCostCtrl.value.copyWith(
      text: state.avgCost != null ? state.avgCost!.toStringAsFixed(2) : '',
      selection: TextSelection.collapsed(
        offset: state.avgCost != null
            ? state.avgCost!.toStringAsFixed(2).length
            : 0,
      ),
    );
  }

  @override
  void dispose() {
    _sharesCtrl.dispose();
    _avgCostCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    return BlocBuilder<HoldingBloc, HoldingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const AppText(
              text: "Add Holdings",
              type: AppTextType.titleMedium,
            ),
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
                label: state.editingHolding == null
                    ? "Add to Portfolio"
                    : "Update Holding",

                onPressed: () {
                  if (_sharesCtrl.text.isEmpty || _avgCostCtrl.text.isEmpty) {
                    return;
                  }
                  context.read<HoldingBloc>().add(const SubmitHolding());
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(
                vertical: AppSizes.spaceLG,
                horizontal: AppSizes.spaceMD,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLabeledField(
                    title: "Company ID",
                    hintText: "AAPL / MSFT ...",
                    leadingIcon: Icons.tag,
                    toUpperCase: true,
                    onChanged: (v) => context.read<HoldingBloc>().add(
                      UpdateHoldingForm(companyId: v),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceMD),
                  AppLabeledField(
                    title: "Company Name",
                    hintText: "Apple Inc ...",
                    leadingIcon: Icons.business,

                    onChanged: (v) => context.read<HoldingBloc>().add(
                      UpdateHoldingForm(companyName: v),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceXL),
                  Row(
                    children: [
                      Expanded(
                        child: MiniInputField(
                          title: "SHARES",
                          controller: _sharesCtrl,
                          hintText: "10.00",
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (v) => context.read<HoldingBloc>().add(
                            UpdateHoldingForm(shares: double.tryParse(v) ?? 0),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.spaceMD),
                      BlocBuilder<CurrencyCubit, CurrencyState>(
                        builder: (context, currency) {
                          final avgCost = context
                              .read<HoldingBloc>()
                              .state
                              .avgCost;
                          final newText = avgCost != null
                              ? avgCost.toStringAsFixed(2)
                              : '';
                          if (_avgCostCtrl.text != newText) {
                            _avgCostCtrl.value = _avgCostCtrl.value.copyWith(
                              text: newText,
                              selection: TextSelection.collapsed(
                                offset: newText.length,
                              ),
                            );
                          }

                          return Expanded(
                            child: MiniInputField(
                              title: "AVG. COST (${currency.selected.symbol})",
                              controller: _avgCostCtrl,
                              hintText: "150.00",
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              onChanged: (v) => context.read<HoldingBloc>().add(
                                UpdateHoldingForm(
                                  avgCost: double.tryParse(v),
                                  currencyCode: currency.selected.code,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceXL),
                  BlocBuilder<HoldingBloc, HoldingState>(
                    builder: (context, state) {
                      return BlocBuilder<CurrencyCubit, CurrencyState>(
                        builder: (context, currency) {
                          return HoldingCostSummary(
                            shares: state.shares,
                            avgCost: state.avgCost ?? 0.0,
                            currencySymbol: currency.selected.symbol,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: AppSizes.spaceXL),
                  PortfolioSelectField(
                    selectedPortfolioId: state.selectedPortfolioId,
                    onChanged: (pid) {
                      context.read<HoldingBloc>().add(
                        UpdateHoldingForm(
                          portfolioId: pid, // buraya gönderiyoruz
                        ),
                      );
                      print("Selected portfolio ID: $pid");
                      // istersen hemen holdingleri yükleyebilirsin:
                      context.read<HoldingBloc>().add(LoadHoldings(pid));
                    },
                  ),

                  const SizedBox(height: AppSizes.spaceXL),
                  PayDateField(
                    initialDate: state.payDate ?? DateTime.now(),
                    onChanged: (d) => context.read<HoldingBloc>().add(
                      UpdateHoldingForm(payDate: d),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
