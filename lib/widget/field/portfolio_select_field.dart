import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/portfolio_bloc/portfolio_bloc.dart';

import '../../bloc/portfolio_bloc/portfolio_state.dart';

import '../../widget/field/select_field.dart';

import '../bottom_sheet/portfolio_select_sheet.dart';

class PortfolioSelectField extends StatelessWidget {
  const PortfolioSelectField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      buildWhen: (p, c) =>
          p.selectedPortfolioId != c.selectedPortfolioId ||
          p.portfolios.length != c.portfolios.length,
      builder: (context, state) {
        return SelectField(
          title: "Portfolio",
          value: state.selectedPortfolio?.name ?? "Select...",
          onTap: () => _openSheet(context),
        );
      },
    );
  }

  void _openSheet(BuildContext context) {
    final bloc = context.read<PortfolioBloc>();

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider.value(
          value: bloc,
          child: const PortfolioBottomSheet(),
        );
      },
    );
  }
}
