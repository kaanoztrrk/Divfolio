import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/holding/holding_bloc.dart';
import '../../bloc/holding/holding_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_size.dart';
import '../../data/model/holding_model.dart';
import '../text/app_text.dart';

class SelectHoldingSheet extends StatefulWidget {
  const SelectHoldingSheet({super.key});

  @override
  State<SelectHoldingSheet> createState() => _SelectHoldingSheetState();
}

class _SelectHoldingSheetState extends State<SelectHoldingSheet> {
  HoldingModel? _selectedHolding;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<HoldingBloc>(),
      child: BlocBuilder<HoldingBloc, HoldingState>(
        builder: (context, holdingState) {
          final holdings = holdingState.holdings;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (holdingState.loading)
                const Padding(
                  padding: EdgeInsets.all(AppSizes.spaceMD),
                  child: CircularProgressIndicator(),
                )
              else if (holdings.isEmpty)
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
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      setState(() => _selectedHolding = h);
                      Navigator.pop(context, h); // seçili holding'i geri döndür
                    },
                  ),
                ),
              const SizedBox(height: AppSizes.spaceMD),
            ],
          );
        },
      ),
    );
  }
}
