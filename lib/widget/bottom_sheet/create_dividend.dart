import 'package:divfolio/core/routes/app_router.dart';
import 'package:divfolio/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

class CreateDividendSheet {
  static void openAddSheet(BuildContext context) {
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
                  Navigator.popAndPushNamed(context, AppRoutes.addHolding);
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Add Dividend'),
                onTap: () {
                  Navigator.popAndPushNamed(context, AppRoutes.addDividend);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
