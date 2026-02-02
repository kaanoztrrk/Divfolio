import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../bloc/portfolio_bloc/portfolio_event.dart';
import '../../constants/app_size.dart';
import '../../data/model/portfolio_model.dart';
import '../../widget/text/app_text.dart';

class CreatePortfolioSheet extends StatelessWidget {
  CreatePortfolioSheet({super.key});

  final TextEditingController _ctrl = TextEditingController();

  void _submit(BuildContext context) {
    final name = _ctrl.text.trim();
    if (name.isEmpty) return;

    final now = DateTime.now();

    context.read<PortfolioBloc>().add(
      UpsertPortfolio(
        PortfolioModel(
          id: now.microsecondsSinceEpoch.toString(),
          name: name,
          baseCurrencyCode: 'USD',
          createdAt: now,
          updatedAt: now,
          notes: null,
        ),
      ),
    );

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
              text: 'New Portfolio',
              type: AppTextType.titleMedium,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: AppSizes.spaceMD),
            TextField(
              controller: _ctrl,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: 'Portfolio name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(context),
            ),
            const SizedBox(height: AppSizes.spaceMD),
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
                    onPressed: () => _submit(context),
                    child: const AppText(
                      text: 'Create',
                      type: AppTextType.labelLarge,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
