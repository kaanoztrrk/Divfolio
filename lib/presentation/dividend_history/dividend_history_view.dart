import 'package:divfolio/core/constants/app_size.dart';
import 'package:divfolio/core/utils/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/dividend_bloc/dividend_bloc.dart';
import '../../bloc/dividend_bloc/dividend_state.dart';
import '../../bloc/holding_bloc/holding_bloc.dart';
import '../../bloc/holding_bloc/holding_event.dart';
import '../../bloc/holding_bloc/holding_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_images.dart';
import '../../widget/text/app_text.dart';
import '../../widget/tile/dividend_tile.dart';

class DividendHistoryView extends StatefulWidget {
  const DividendHistoryView({super.key});

  @override
  State<DividendHistoryView> createState() => _DividendHistoryViewState();
}

class _DividendHistoryViewState extends State<DividendHistoryView> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    context.read<HoldingBloc>().add(const LoadAllHoldings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
        child: Column(
          children: [
            const SizedBox(height: AppSizes.spaceMD),

            SearchBar(
              controller: _searchController,
              elevation: const WidgetStatePropertyAll(0),
              hintText: "Search",
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),

            const SizedBox(height: AppSizes.spaceMD),

            Expanded(
              child: BlocBuilder<HoldingBloc, HoldingState>(
                builder: (context, holdingState) {
                  final holdingMap = {
                    for (final h in holdingState.holdings) h.id: h,
                  };

                  return BlocBuilder<DividendBloc, DividendState>(
                    builder: (context, state) {
                      if (state.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.error != null) {
                        return Center(
                          child: AppText(
                            text: state.error!,
                            type: AppTextType.bodyMedium,
                            color: AppColors.textSecondary,
                          ),
                        );
                      }

                      final items = state.dividends;

                      /// SEARCH FILTER
                      final filtered = items.where((dividend) {
                        final holding = holdingMap[dividend.holdingId];

                        if (holding == null) return false;

                        final name = holding.companyName.toLowerCase();
                        return name.contains(searchQuery);
                      }).toList();

                      if (filtered.isEmpty) {
                        return Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 340),
                            child: const EmptyState(
                              imagePath: AppImages.emptySearch,
                              title: "No results found",
                              subtitle: "Try searching another stock symbol.",
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final dividend = filtered[index];
                          final holding = holdingMap[dividend.holdingId];

                          return DividendTile(
                            dividend: dividend,
                            holding: holding,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
