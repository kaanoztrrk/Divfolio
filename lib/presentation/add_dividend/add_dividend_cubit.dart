import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/holding_model.dart';
import '../../bloc/holding_bloc/holding_bloc.dart';
import '../../bloc/holding_bloc/holding_event.dart';

class AddDividendState {
  final bool calculateMode;
  final DateTime payDate;
  final HoldingModel? selectedHolding;
  final double calculatedNet;

  AddDividendState({
    this.calculateMode = false,
    DateTime? payDate,
    this.selectedHolding,
    this.calculatedNet = 0.0,
  }) : payDate = payDate ?? DateTime.now();

  AddDividendState copyWith({
    bool? calculateMode,
    DateTime? payDate,
    HoldingModel? selectedHolding,
    bool clearHolding = false,
    double? calculatedNet,
  }) {
    return AddDividendState(
      calculateMode: calculateMode ?? this.calculateMode,
      payDate: payDate ?? this.payDate,
      selectedHolding: clearHolding
          ? null
          : (selectedHolding ?? this.selectedHolding),
      calculatedNet: calculatedNet ?? this.calculatedNet,
    );
  }
}

class AddDividendCubit extends Cubit<AddDividendState> {
  AddDividendCubit() : super(AddDividendState(payDate: DateTime.now()));

  final netAmountCtrl = TextEditingController();
  final sharesCtrl = TextEditingController();
  final divPerShareCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  void setMode(bool calculateMode) {
    emit(state.copyWith(calculateMode: calculateMode));
  }

  void setPayDate(DateTime date) {
    emit(state.copyWith(payDate: date));
  }

  void setHolding(HoldingModel holding) {
    emit(state.copyWith(selectedHolding: holding));
  }

  void updateCalculatedNet() {
    final shares = double.tryParse(sharesCtrl.text.trim()) ?? 0;
    final divPerShare = double.tryParse(divPerShareCtrl.text.trim()) ?? 0;
    emit(state.copyWith(calculatedNet: shares * divPerShare));
  }

  void reset() {
    netAmountCtrl.clear();
    sharesCtrl.clear();
    divPerShareCtrl.clear();
    notesCtrl.clear();
    emit(AddDividendState(payDate: DateTime.now()));
  }

  @override
  Future<void> close() {
    netAmountCtrl.dispose();
    sharesCtrl.dispose();
    divPerShareCtrl.dispose();
    notesCtrl.dispose();
    return super.close();
  }

  void initHoldings(HoldingBloc holdingBloc) {
    holdingBloc.add(const LoadAllHoldings());
  }
}
