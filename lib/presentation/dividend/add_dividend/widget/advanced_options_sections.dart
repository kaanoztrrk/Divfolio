import 'package:flutter/material.dart';

import '../../../../constants/app_size.dart';
import '../../../../widget/field/mini_input_field.dart';
import '../../../../widget/field/notes_field.dart';
import '../../../../widget/field/select_field.dart';

class AdvancedOptionsSection extends StatelessWidget {
  final TextEditingController sharesController;
  final TextEditingController divPerShareController;
  final TextEditingController notesController;

  final String portfolioLabel;
  final VoidCallback onTapPortfolio;

  const AdvancedOptionsSection({
    super.key,
    required this.sharesController,
    required this.divPerShareController,
    required this.notesController,
    required this.portfolioLabel,
    required this.onTapPortfolio,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- top row: 2 small boxes ---
        Row(
          children: [
            Expanded(
              child: MiniInputField(
                title: "SHARES OWNED",
                controller: sharesController,
                hintText: "0",
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: AppSizes.spaceMD),
            Expanded(
              child: MiniInputField(
                title: "DIV / SHARE",
                controller: divPerShareController,
                hintText: "0.00",
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSizes.spaceMD),

        // --- portfolio dropdown field ---
        SelectField(
          title: "PORTFOLIO",
          value: portfolioLabel,
          onTap: onTapPortfolio,
        ),

        const SizedBox(height: AppSizes.spaceMD),

        // --- notes area ---
        NotesField(
          title: "NOTES",
          controller: notesController,
          hintText: "Add a note...",
        ),
      ],
    );
  }
}
