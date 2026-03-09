import 'package:flutter/material.dart';

import '../../../../core/constants/app_size.dart';
import '../../../../widget/field/mini_input_field.dart';
import '../../../../widget/field/notes_field.dart';
import '../../../../widget/field/select_field.dart';

class AdvancedOptionsSection extends StatelessWidget {
  final TextEditingController sharesController;
  final TextEditingController divPerShareController;
  final TextEditingController notesController;

  // portfolioLabel ve onTapPortfolio KALDIRILDI

  const AdvancedOptionsSection({
    super.key,
    required this.sharesController,
    required this.divPerShareController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        // SelectField (portfolio) KALDIRILDI
        NotesField(
          title: "NOTES",
          controller: notesController,
          hintText: "Add a note...",
        ),
      ],
    );
  }
}
