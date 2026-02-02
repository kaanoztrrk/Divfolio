import 'package:divfolio/constants/app_size.dart';
import 'package:divfolio/core/utils/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/dividend_bloc/dividend_bloc.dart';
import '../../bloc/dividend_bloc/dividend_state.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../widget/text/app_text.dart';
import '../../widget/tile/dividend_tile.dart';

class DividendHistoryView extends StatelessWidget {
  const DividendHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMD),
        child: Column(
          children: [
            const SizedBox(height: AppSizes.spaceMD),

            const SearchBar(
              elevation: WidgetStatePropertyAll(0),
              hintText: "Search",
            ),

            const SizedBox(height: AppSizes.spaceMD),

            Expanded(
              child: BlocBuilder<DividendBloc, DividendState>(
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
                  if (items.isEmpty) {
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 340),
                        child: const EmptyState(
                          imagePath: AppImages.emptySearch,
                          title: "Dividend history is empty",
                          subtitle:
                              "Add your holdings to generate historical dividend data.",
                        ),
                      ),
                    );
                  }

                  // History ekranıysa istersen take(5) kaldır.
                  final recent = items.take(5).toList();

                  return ListView.builder(
                    itemCount: recent.length,
                    itemBuilder: (context, index) {
                      final dividend = recent[index];
                      return DividendTile(dividend: dividend);
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
