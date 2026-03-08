import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/holding/holding_bloc.dart';
import '../../bloc/holding/holding_event.dart';
import '../../bloc/holding/holding_state.dart';
import '../../core/constants/app_size.dart';
import '../../core/init/locator.dart';
import '../../core/utils/device_utility.dart';
import '../../widget/button/primary_button.dart';
import '../../widget/field/app_label_field.dart';
import '../../widget/field/mini_input_field.dart';
import '../../widget/field/portfolio_select_field.dart';
import '../../widget/text/app_text.dart';
import 'widget/holding_cost_summary.dart';

// pay_date_field import KALDIRILDI → payDate artık DividendModel'e ait

class AddHoldingView extends StatefulWidget {
  const AddHoldingView({super.key});

  @override
  State<AddHoldingView> createState() => _AddHoldingViewState();
}

class _AddHoldingViewState extends State<AddHoldingView> {
  late TextEditingController _sharesCtrl;
  late TextEditingController _avgCostCtrl;
  late HoldingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _sharesCtrl = TextEditingController();
    _avgCostCtrl = TextEditingController();
    _bloc = getIt<HoldingBloc>();
  }

  @override
  void dispose() {
    _sharesCtrl.dispose();
    _avgCostCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<HoldingBloc, HoldingState>(
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
                  label: "Add to Portfolio",
                  onPressed: () {
                    context.read<HoldingBloc>().add(const SubmitHolding());
                    Navigator.pop(context);
                  },
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
                    AppLabeledField(
                      title: "Company ID",
                      hintText: "AAPL / MSFT ...",
                      leadingIcon: Icons.tag,
                      toUpperCase: true,
                      onChanged: (v) {
                        context.read<HoldingBloc>().add(
                          UpdateHoldingForm(companyId: v),
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.spaceMD),
                    AppLabeledField(
                      title: "Company Name",
                      hintText: "Apple Inc ...",
                      leadingIcon: Icons.business,
                      onChanged: (v) {
                        context.read<HoldingBloc>().add(
                          UpdateHoldingForm(companyName: v),
                        );
                      },
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
                            onChanged: (v) {
                              final value = double.tryParse(v) ?? 0;
                              context.read<HoldingBloc>().add(
                                UpdateHoldingForm(shares: value),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceMD),
                        Expanded(
                          child: MiniInputField(
                            title: "AVG. COST (\$)",
                            controller: _avgCostCtrl,
                            hintText: "150.00",
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (v) {
                              final value = double.tryParse(v);
                              context.read<HoldingBloc>().add(
                                UpdateHoldingForm(avgCost: value),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceXL),
                    HoldingCostSummary(
                      shares: double.tryParse(_sharesCtrl.text) ?? 0,
                      avgCost: double.tryParse(_avgCostCtrl.text) ?? 0,
                      currencySymbol: "\$",
                    ),
                    const SizedBox(height: AppSizes.spaceXL),
                    PortfolioSelectField(
                      selectedPortfolioId: state.selectedPortfolioId,
                      onChanged: (pid) {
                        context.read<HoldingBloc>().add(
                          UpdateHoldingForm(portfolioId: pid),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
