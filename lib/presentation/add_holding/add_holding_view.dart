import 'package:divfolio/cubit/currency_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../core/utils/device_utility.dart';
import '../../widget/button/primary_button.dart';
import '../../widget/field/app_label_field.dart';
import '../../widget/field/mini_input_field.dart';
import '../../widget/field/pay_date_field.dart';
import '../../widget/field/portfolio_select_field.dart';
import '../../widget/field/select_field.dart';
import '../../widget/text/app_text.dart';
import 'widget/holding_cost_summary.dart';

class AddHoldingView extends StatelessWidget {
  const AddHoldingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

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
          child: PrimaryButton(label: "Add to Portfolio", onPressed: () {}),
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
                onChanged: (_) {}, // sadece UI
              ),
              const SizedBox(height: AppSizes.spaceMD),
              AppLabeledField(
                title: "Company Name",
                hintText: "Apple Inc ...",
                leadingIcon: Icons.business,
                onChanged: (_) {}, // sadece UI
              ),
              const SizedBox(height: AppSizes.spaceXL),
              Row(
                children: [
                  Expanded(
                    child: MiniInputField(
                      title: "SHARES",
                      controller: TextEditingController(), // sadece UI
                      hintText: "10.00",
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceMD),
                  BlocBuilder<CurrencyCubit, CurrencyState>(
                    builder: (context, currency) {
                      return Expanded(
                        child: MiniInputField(
                          title: "AVG. COST (${currency.selected.symbol})",
                          controller: TextEditingController(), // sadece UI
                          hintText: "150.00",
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceXL),
              BlocBuilder<CurrencyCubit, CurrencyState>(
                builder: (context, currency) {
                  return HoldingCostSummary(
                    shares: 10.00,
                    avgCost: 150.00,
                    currencySymbol: currency.selected.symbol,
                  );
                },
              ),

              const SizedBox(height: AppSizes.spaceXL),
              const PortfolioSelectField(),

              const SizedBox(height: AppSizes.spaceXL),
              PayDateField(
                initialDate: DateTime.now(),
                onChanged: (_) {}, // sadece UI
              ),
            ],
          ),
        ),
      ),
    );
  }
}
