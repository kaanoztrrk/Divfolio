import 'package:divfolio/constants/app_colors.dart';
import 'package:divfolio/widget/button/primary_button.dart';
import 'package:divfolio/widget/field/select_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../bloc/portfolio_bloc/portfolio_event.dart';
import '../../constants/app_size.dart';
import '../../core/utils/device_utility.dart';
import '../../data/model/portfolio_model.dart';
import '../../widget/text/app_text.dart';
import '../field/app_label_field.dart';

class CreatePortfolioSheet extends StatefulWidget {
  const CreatePortfolioSheet({super.key});

  @override
  State<CreatePortfolioSheet> createState() => _CreatePortfolioSheetState();
}

class _CreatePortfolioSheetState extends State<CreatePortfolioSheet> {
  final TextEditingController _nameCtrl = TextEditingController();

  // LOCAL currency list
  final List<String> _currencies = ['USD', 'EUR', 'TRY'];

  String _selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.spaceMD,
          AppSizes.spaceMD,
          AppSizes.spaceMD,
          AppSizes.spaceMD + bottomInset,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppLabeledField(
              title: "Create Portfolio",
              controller: _nameCtrl,
              hintText: "Portfolio Name",
            ),

            const SizedBox(height: AppSizes.spaceMD),

            SelectField(
              title: "Select Currency",
              value: _selectedCurrency,
              onTap: () => _openCurrencyPicker(),
            ),

            const SizedBox(height: AppSizes.spaceMD),

            /// Actions
            PrimaryButton(
              label: "Done",
              onPressed: () {
                final name = _nameCtrl.text.trim();
                if (name.isEmpty) return;

                final now = DateTime.now();

                context.read<PortfolioBloc>().add(
                  UpsertPortfolio(
                    PortfolioModel(
                      id: now.microsecondsSinceEpoch.toString(),
                      name: name,
                      baseCurrencyCode: _selectedCurrency,
                      createdAt: now,
                      updatedAt: now,
                      notes: null,
                    ),
                  ),
                );

                Navigator.pop(context);
              },
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: AppText(
                text: "Cancel",
                type: AppTextType.bodyLarge,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCurrencyPicker() {
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._currencies.map(
              (currency) => ListTile(
                title: AppText(text: currency, type: AppTextType.bodyLarge),
                trailing: currency == _selectedCurrency
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedCurrency = currency;
                  });
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
}
