import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../widget/button/primary_button.dart';
import '../../widget/field/app_label_field.dart';
import '../../widget/field/mini_input_field.dart';
import '../../widget/field/pay_date_field.dart';
import '../../widget/field/select_field.dart';
import '../../widget/text/app_text.dart';

class AddHoldingView extends StatefulWidget {
  const AddHoldingView({super.key});

  @override
  State<AddHoldingView> createState() => _AddHoldingViewState();
}

class _AddHoldingViewState extends State<AddHoldingView> {
  final _companyIdCtrl = TextEditingController();
  final _companyNameCtrl = TextEditingController();
  final _sharesCtrl = TextEditingController();
  final _avgCostCtrl = TextEditingController();

  // UI State
  String _selectedPortfolioLabel = "Select...";
  String _currencySymbol = "\$";
  String _currencyCode = "USD";

  // Mock portfolios (şimdilik)
  final List<_PortfolioItem> _portfolios = [
    _PortfolioItem(id: "pf-1", name: "Main Portfolio", baseCurrencyCode: "USD"),
    _PortfolioItem(id: "pf-2", name: "TR Portfolio", baseCurrencyCode: "TRY"),
  ];
  String? _selectedPortfolioId;

  @override
  void dispose() {
    _companyIdCtrl.dispose();
    _companyNameCtrl.dispose();
    _sharesCtrl.dispose();
    _avgCostCtrl.dispose();
    super.dispose();
  }

  double? _tryParseDouble(String s) {
    final t = s.replaceAll(',', '.').trim();
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  double _totalCost() {
    final shares = _tryParseDouble(_sharesCtrl.text) ?? 0;
    final avg = _tryParseDouble(_avgCostCtrl.text) ?? 0;
    return shares * avg;
  }

  Future<void> _openPortfolioPicker() async {
    final res = await showModalBottomSheet<_PortfolioPickResult>(
      context: context,
      showDragHandle: true,
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceMD),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: AppText(
                        text: "Select Portfolio",
                        type: AppTextType.titleMedium,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final name = await _openNewPortfolioSheet();
                        if (name == null) return;

                        // UI-only: listeye ekle
                        final newId =
                            "pf-${DateTime.now().microsecondsSinceEpoch}";
                        final item = _PortfolioItem(
                          id: newId,
                          name: name,
                          baseCurrencyCode: _currencyCode,
                        );

                        setState(() {
                          _portfolios.insert(0, item);
                        });

                        if (!sheetCtx.mounted) return;
                        Navigator.pop(
                          sheetCtx,
                          _PortfolioPickResult(id: item.id, label: item.name),
                        );
                      },
                      child: const Text("Add new"),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceSM),
                if (_portfolios.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.spaceLG),
                    child: AppText(
                      text: "No portfolios yet. Add one.",
                      type: AppTextType.bodyMedium,
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: _portfolios.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: AppColors.divider),
                    itemBuilder: (_, i) {
                      final p = _portfolios[i];
                      final selected = p.id == _selectedPortfolioId;

                      return ListTile(
                        title: Text(p.name),
                        subtitle: Text(p.baseCurrencyCode),
                        trailing: selected ? const Icon(Icons.check) : null,
                        onTap: () {
                          Navigator.pop(
                            sheetCtx,
                            _PortfolioPickResult(id: p.id, label: p.name),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (res == null) return;

    setState(() {
      _selectedPortfolioId = res.id;
      _selectedPortfolioLabel = res.label;
    });
  }

  Future<String?> _openNewPortfolioSheet() async {
    final ctrl = TextEditingController();

    final res = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetCtx) {
        final bottom = MediaQuery.of(sheetCtx).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.spaceMD,
            AppSizes.spaceMD,
            AppSizes.spaceMD,
            AppSizes.spaceMD + bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppText(
                text: "New Portfolio",
                type: AppTextType.titleMedium,
              ),
              const SizedBox(height: AppSizes.spaceMD),
              TextField(
                controller: ctrl,
                autofocus: true,
                decoration: const InputDecoration(hintText: "Portfolio name"),
              ),
              const SizedBox(height: AppSizes.spaceMD),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final v = ctrl.text.trim();
                    Navigator.pop(sheetCtx, v.isEmpty ? null : v);
                  },
                  child: const Text("Create"),
                ),
              ),
            ],
          ),
        );
      },
    );

    ctrl.dispose();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final total = _totalCost();

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
              if (_selectedPortfolioId == null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Portfolio seç.")));
                return;
              }

              // TODO: kaydetme aksiyonu (bloc/cubit sonra)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("TODO: Save holding")),
              );
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
                onChanged: (v) => _companyIdCtrl.text = v,
              ),
              const SizedBox(height: AppSizes.spaceMD),
              AppLabeledField(
                title: "Company (optional)",
                hintText: "Apple Inc ...",
                leadingIcon: Icons.business,
                onChanged: (v) => _companyNameCtrl.text = v,
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
                      // MiniInputField destekliyorsa:
                      // onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceMD),
                  Expanded(
                    child: MiniInputField(
                      title: "AVG. COST ($_currencySymbol)",
                      controller: _avgCostCtrl,
                      hintText: "150.00",
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      // onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spaceXL),

              Container(
                padding: const EdgeInsets.all(AppSizes.spaceXXL),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calculate,
                          color: AppColors.textPrimary.withValues(alpha: 0.6),
                          size: 20,
                        ),
                        const SizedBox(width: AppSizes.spaceSM),
                        AppText(
                          text: "Total Cost",
                          type: AppTextType.bodyMedium,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppText(
                          text:
                              "${_sharesCtrl.text.isEmpty ? "0" : _sharesCtrl.text} x "
                              "${_avgCostCtrl.text.isEmpty ? "0" : _avgCostCtrl.text}",
                          type: AppTextType.labelLarge,
                          color: AppColors.textSecondary,
                        ),
                        AppText(
                          text: "${total.toStringAsFixed(2)} $_currencySymbol",
                          type: AppTextType.titleLarge,
                          color: AppColors.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.spaceXL),

              SelectField(
                title: "Portfolio",
                value: _selectedPortfolioLabel,
                onTap: _openPortfolioPicker,
              ),

              const SizedBox(height: AppSizes.spaceXL),

              PayDateField(initialDate: DateTime.now(), onChanged: (_) {}),

              const SizedBox(height: AppSizes.spaceXL),
            ],
          ),
        ),
      ),
    );
  }
}

class _PortfolioItem {
  final String id;
  final String name;
  final String baseCurrencyCode;

  const _PortfolioItem({
    required this.id,
    required this.name,
    required this.baseCurrencyCode,
  });
}

class _PortfolioPickResult {
  final String id;
  final String label;

  const _PortfolioPickResult({required this.id, required this.label});
}
