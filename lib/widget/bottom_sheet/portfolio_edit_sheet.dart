import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../bloc/portfolio_bloc/portfolio_event.dart';
import '../../constants/app_size.dart';
import '../../constants/app_colors.dart';
import '../../data/model/portfolio_model.dart';
import '../../widget/text/app_text.dart';

class PortfolioEditSheet extends StatefulWidget {
  const PortfolioEditSheet({super.key, required this.portfolio});

  final PortfolioModel portfolio;

  @override
  State<PortfolioEditSheet> createState() => _PortfolioEditSheetState();
}

class _PortfolioEditSheetState extends State<PortfolioEditSheet> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.portfolio.name);
  }

  void _saveName() {
    final name = _ctrl.text.trim();
    if (name.isEmpty || name == widget.portfolio.name) return;

    context.read<PortfolioBloc>().add(
      UpsertPortfolio(
        widget.portfolio.copyWith(name: name, updatedAt: DateTime.now()),
      ),
    );

    Navigator.pop(context);
  }

  void _deletePortfolio() {
    context.read<PortfolioBloc>().add(DeletePortfolio(widget.portfolio.id));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.spaceMD,
          AppSizes.spaceMD,
          AppSizes.spaceMD,
          AppSizes.spaceMD + bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Edit Portfolio',
              type: AppTextType.titleMedium,
              fontWeight: FontWeight.w700,
            ),

            const SizedBox(height: AppSizes.spaceMD),

            TextField(
              controller: _ctrl,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Portfolio name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _saveName(),
            ),

            const SizedBox(height: AppSizes.spaceLG),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const AppText(
                      text: 'Cancel',
                      type: AppTextType.labelLarge,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spaceMD),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveName,
                    child: const AppText(
                      text: 'Save',
                      type: AppTextType.labelLarge,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.spaceMD),

            const Divider(),

            const SizedBox(height: AppSizes.spaceSM),

            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _deletePortfolio,
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const AppText(
                  text: 'Delete Portfolio',
                  type: AppTextType.labelLarge,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
