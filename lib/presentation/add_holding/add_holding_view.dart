import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/holding_bloc/holding_bloc.dart';
import '../../bloc/holding_bloc/holding_event.dart';
import '../../bloc/holding_bloc/holding_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_size.dart';
import '../../data/model/holding_model.dart';
import '../../widget/button/primary_button.dart';
import '../../widget/field/app_label_field.dart';
import '../../widget/field/mini_input_field.dart';
import '../../widget/field/portfolio_select_field.dart';
import '../../widget/text/app_text.dart';
import 'widget/holding_cost_summary.dart';

class AddHoldingView extends StatefulWidget {
  const AddHoldingView({super.key, this.editingHolding});
  final HoldingModel? editingHolding;

  @override
  State<AddHoldingView> createState() => _AddHoldingViewState();
}

class _AddHoldingViewState extends State<AddHoldingView> {
  late TextEditingController _sharesCtrl;
  late TextEditingController _avgCostCtrl;

  @override
  void initState() {
    super.initState();
    _sharesCtrl = TextEditingController();
    _avgCostCtrl = TextEditingController();

    _sharesCtrl.addListener(() => setState(() {}));
    _avgCostCtrl.addListener(() => setState(() {}));

    final h = widget.editingHolding;
    if (h != null) {
      _sharesCtrl.text = h.shares.toString();
      _avgCostCtrl.text = h.avgCost?.toString() ?? '';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HoldingBloc>().add(
          UpdateHoldingForm(
            editingHolding: h,
            companyId: h.companyId,
            companyName: h.companyName,
            shares: h.shares,
            avgCost: h.avgCost,
            currencyCode: h.currencyCode,
            portfolioId: h.portfolioId,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _sharesCtrl.dispose();
    _avgCostCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HoldingBloc, HoldingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: AppText(
              text: widget.editingHolding != null
                  ? "Edit Holding"
                  : "Add Holdings",
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
                label: widget.editingHolding != null
                    ? "Save Changes"
                    : "Add to Portfolio",
                onPressed: () {
                  final error = _validate(state);
                  if (error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error),
                        backgroundColor: AppColors.error,
                      ),
                    );
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
                    maxLength: 5, // EKLE
                    initialValue: widget.editingHolding?.companyId,
                    readOnly: widget.editingHolding != null,
                    onChanged: (v) {
                      context.read<HoldingBloc>().add(
                        UpdateHoldingForm(companyId: v),
                      );
                    },
                  ),
                  AppLabeledField(
                    title: "Company Name",
                    hintText: "Apple Inc ...",
                    leadingIcon: Icons.business,
                    initialValue: widget.editingHolding?.companyName,
                    readOnly: widget.editingHolding != null,
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
                          title: "AVG. COST (${state.currencySymbol})",
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
                    currencySymbol: state.currencySymbol,
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
    );
  }

  String? _validate(HoldingState state) {
    final companyId = state.companyId.trim();
    final companyName = state.companyName.trim();

    if (companyId.isEmpty) return 'Company ID is required.';
    if (companyId.length > 5) return 'Company ID must be max 5 characters.';
    if (companyName.isEmpty) return 'Company Name is required.';
    if (state.shares <= 0) return 'Shares must be greater than 0.';
    if (state.avgCost != null && state.avgCost! < 0) {
      return 'Average cost cannot be negative.';
    }
    if (state.selectedPortfolioId == null) return 'Please select a portfolio.';
    return null;
  }
}
