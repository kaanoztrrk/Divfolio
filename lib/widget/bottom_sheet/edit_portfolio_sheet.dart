import 'package:divfolio/core/constants/app_colors.dart';
import 'package:divfolio/widget/button/primary_button.dart';
import 'package:divfolio/widget/field/select_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../bloc/portfolio_bloc/portfolio_event.dart';
import '../../core/constants/app_size.dart';
import '../../core/init/currency_init.dart';
import '../../core/utils/device_utility.dart';
import '../../data/model/currency_model.dart';
import '../../data/model/portfolio_model.dart';
import '../../widget/text/app_text.dart';
import '../field/app_label_field.dart';

class EditPortfolioSheet extends StatefulWidget {
  const EditPortfolioSheet({super.key, required this.portfolio});

  final PortfolioModel portfolio;

  @override
  State<EditPortfolioSheet> createState() => _EditPortfolioSheetState();
}

class _EditPortfolioSheetState extends State<EditPortfolioSheet> {
  late final TextEditingController _nameCtrl;
  late CurrencyModel _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.portfolio.name);

    // Mevcut portfolio currency'sini seç, bulunamazsa ilk currency
    _selectedCurrency = CurrencyDefaults.list.firstWhere(
      (c) => c.code == widget.portfolio.baseCurrencyCode,
      orElse: () => CurrencyDefaults.list.first,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

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
              title: "Edit Portfolio",
              controller: _nameCtrl,
              hintText: "Portfolio Name",
            ),
            const SizedBox(height: AppSizes.spaceMD),
            SelectField(
              title: "Select Currency",
              value: '${_selectedCurrency.symbol} ${_selectedCurrency.code}',
              onTap: _openCurrencyPicker,
            ),
            const SizedBox(height: AppSizes.spaceMD),
            PrimaryButton(
              label: "Save Changes",
              onPressed: () {
                final name = _nameCtrl.text.trim();
                if (name.isEmpty) return;

                final now = DateTime.now();

                context.read<PortfolioBloc>().add(
                  UpsertPortfolio(
                    // Mevcut portfolio'yu güncelle — id ve createdAt korunur
                    widget.portfolio.copyWith(
                      name: name,
                      baseCurrencyCode: _selectedCurrency.code,
                      updatedAt: now,
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
            ...CurrencyDefaults.list.map(
              (currency) => ListTile(
                leading: AppText(
                  text: currency.symbol,
                  type: AppTextType.titleLarge,
                ),
                title: AppText(
                  text: currency.code,
                  type: AppTextType.bodyLarge,
                ),
                subtitle: AppText(
                  text: currency.name.toString(),
                  type: AppTextType.bodySmall,
                ),
                trailing: currency.code == _selectedCurrency.code
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  setState(() => _selectedCurrency = currency);
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
