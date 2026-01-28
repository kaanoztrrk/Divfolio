import 'package:divfolio/core/enum/date_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../cubit/date_format_cubit.dart';
import '../text/app_text.dart';
import 'app_label_field.dart';

class PayDateField extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime>? onChanged;

  const PayDateField({super.key, required this.initialDate, this.onChanged});

  @override
  State<PayDateField> createState() => _PayDateFieldState();
}

class _PayDateFieldState extends State<PayDateField> {
  late DateTime _selected;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate;
    _controller = TextEditingController();
    _syncText();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Format değişince yazı güncellensin
    _syncText();
  }

  void _syncText() {
    final fmt = context.read<DateFormatCubit>().state.selected;
    _controller.text = fmt.format(_selected);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openCupertinoPicker() async {
    final fmtCubit = context.read<DateFormatCubit>();

    DateTime temp = _selected;

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLG),
        ),
      ),
      builder: (_) {
        return SizedBox(
          height: 320,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceMD,
                  vertical: AppSizes.spaceSM,
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: AppText(
                        text: "Cancel",
                        type: AppTextType.titleSmall,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() => _selected = temp);
                        _controller.text = fmtCubit.state.selected.format(
                          _selected,
                        );
                        widget.onChanged?.call(_selected);
                        Navigator.pop(context);
                      },
                      child: AppText(
                        text: "Done",
                        type: AppTextType.titleSmall,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selected,
                  maximumDate: DateTime.now().add(const Duration(days: 3650)),
                  onDateTimeChanged: (d) => temp = d,
                ),
              ),
            ],
          ),
        );
      },
    );

    // Format değişmiş olabilir; güvenli güncelle
    _controller.text = context.read<DateFormatCubit>().state.selected.format(
      _selected,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cubit değişince rebuild olsun
    final fmt = context.select<DateFormatCubit, AppDateFormat>(
      (c) => c.state.selected,
    );

    // UI text güncelle
    _controller.text = fmt.format(_selected);

    return AppLabeledField(
      title: "Pay Date",
      controller: _controller,
      hintText: "Select date",
      leadingIcon: Icons.calendar_today,
      readOnly: true,
      onTap: _openCupertinoPicker,
    );
  }
}
