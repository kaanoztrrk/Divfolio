import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/enum/date_formatter.dart';

class DateFormatState {
  final AppDateFormat format;

  const DateFormatState({required this.format});
}

class DateFormatCubit extends Cubit<DateFormatState> {
  DateFormatCubit()
    : super(const DateFormatState(format: AppDateFormat.MMMddyyyy));

  void setFormat(AppDateFormat format) {
    emit(DateFormatState(format: format));
  }
}
