import 'package:divfolio/core/routes/app_router.dart';
import 'package:divfolio/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

class CreateDividendSheet {
  static void openAddSheet(BuildContext context) {
    final nav = Navigator.of(context); // parent navigator'ı yakala

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.add_chart),
                title: const Text('Add Holding'),
                onTap: () {
                  nav.pop(); // sheet kapanır
                  nav.pushNamed(AppRoutes.addHolding); // sonra route
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Add Dividend'),
                onTap: () {
                  nav.pop();
                  nav.pushNamed(AppRoutes.addDividend);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
