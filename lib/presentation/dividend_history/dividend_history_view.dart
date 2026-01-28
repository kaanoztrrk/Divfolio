import 'package:divfolio/constants/app_size.dart';
import 'package:flutter/material.dart';

import '../../widget/tile/dividend_tile.dart'; // path sende farklıysa düzelt

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
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const DividendTile();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
