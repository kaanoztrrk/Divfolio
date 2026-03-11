import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../bloc/portfolio_bloc/portfolio_state.dart';
import '../bottom_sheet/portfolio_select_sheet.dart';
import '../field/select_field.dart';

class PortfolioSelectField extends StatelessWidget {
  final String? selectedPortfolioId;
  final ValueChanged<String> onChanged; // Seçilen ID dışarıya gönderilecek

  const PortfolioSelectField({
    super.key,
    required this.selectedPortfolioId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      buildWhen: (previous, current) =>
          previous.selectedPortfolioId != current.selectedPortfolioId ||
          previous.portfolios.length != current.portfolios.length,
      builder: (context, state) {
        String displayText = "Select...";
        if (selectedPortfolioId != null) {
          final matches = state.portfolios.where(
            (p) => p.id == selectedPortfolioId,
          );
          if (matches.isNotEmpty) {
            displayText = matches.first.name;
          }
        }

        return SelectField(
          title: "Portfolio",
          value: displayText,
          onTap: () async {
            final selectedId = await _openSheet(context, selectedPortfolioId);
            if (selectedId != null) {
              onChanged(selectedId);
              print("Selected portfolio ID: $selectedId");
            }
          },
        );
      },
    );
  }

  Future<String?> _openSheet(BuildContext context, String? currentSelectedId) {
    final bloc = context.read<PortfolioBloc>();

    return showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider.value(
          value: bloc,
          child: PortfolioBottomSheet(
            currentSelectedId: currentSelectedId,

            onSelect: (selectedId) {
              Navigator.pop(context, selectedId);
            },
          ),
        );
      },
    );
  }
}
