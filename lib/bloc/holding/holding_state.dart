// holding_state.dart
import 'package:equatable/equatable.dart';
import '../../data/model/holding_model.dart';

class HoldingState extends Equatable {
  final bool loading;
  final String? error;

  final String? selectedPortfolioId;
  final HoldingModel? editingHolding;

  final String companyId;
  final String companyName;
  final double shares;
  final double? avgCost;
  final String currencyCode;
  final DateTime? payDate;

  final List<HoldingModel> holdings;

  const HoldingState({
    this.loading = false,
    this.error,
    this.selectedPortfolioId,
    this.editingHolding,
    this.companyId = '',
    this.companyName = '',
    this.shares = 0,
    this.avgCost,
    this.currencyCode = 'USD',
    this.payDate,
    this.holdings = const [],
  });

  HoldingState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
    String? selectedPortfolioId,
    HoldingModel? editingHolding,
    String? companyId,
    String? companyName,
    double? shares,
    double? avgCost,
    String? currencyCode,
    DateTime? payDate,
    List<HoldingModel>? holdings,
  }) {
    return HoldingState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      selectedPortfolioId: selectedPortfolioId ?? this.selectedPortfolioId,
      editingHolding: editingHolding ?? this.editingHolding,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      shares: shares ?? this.shares,
      avgCost: avgCost ?? this.avgCost,
      currencyCode: currencyCode ?? this.currencyCode,
      payDate: payDate ?? this.payDate,
      holdings: holdings ?? this.holdings,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    error,
    selectedPortfolioId,
    editingHolding,
    companyId,
    companyName,
    shares,
    avgCost,
    currencyCode,
    payDate,
    holdings,
  ];
}
