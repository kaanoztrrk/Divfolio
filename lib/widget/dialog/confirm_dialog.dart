import 'package:flutter/material.dart';

/// Genel amaçlı onay dialogu.
///
/// Kullanım örneği:
/// ```dart
/// ConfirmDialog.show(
///   context: context,
///   title: 'Delete Holding',
///   message: '${h.companyName} and all its dividends will be deleted.',
///   confirmLabel: 'Delete',
///   confirmColor: AppColors.error,
///   onConfirm: () {
///     context.read<HoldingBloc>().add(DeleteHolding(h.id));
///   },
/// );
/// ```
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelLabel = 'Cancel',
    this.confirmLabel = 'Confirm',
    this.confirmColor,
    required this.onConfirm,
  });

  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final Color? confirmColor;
  final VoidCallback onConfirm;

  /// Dialog'u gösterir. [onConfirm] callback'i Navigator.pop'tan önce çağrılır.
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String cancelLabel = 'Cancel',
    String confirmLabel = 'Confirm',
    Color? confirmColor,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: title,
        message: message,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        confirmColor: confirmColor,
        onConfirm: () {
          onConfirm();
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(confirmLabel, style: TextStyle(color: confirmColor)),
        ),
      ],
    );
  }
}
