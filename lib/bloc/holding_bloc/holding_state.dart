import 'package:equatable/equatable.dart';
import '../../core/init/currency_init.dart';
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
    this.holdings = const [],
  });

  HoldingState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
    String? selectedPortfolioId,
    HoldingModel? editingHolding,
    bool clearEditingHolding = false,
    String? companyId,
    String? companyName,
    double? shares,
    Object? avgCost = _sentinel,
    String? currencyCode,
    List<HoldingModel>? holdings,
  }) {
    return HoldingState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      selectedPortfolioId: selectedPortfolioId ?? this.selectedPortfolioId,
      editingHolding: clearEditingHolding
          ? null
          : (editingHolding ?? this.editingHolding),
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      shares: shares ?? this.shares,
      avgCost: avgCost == _sentinel ? this.avgCost : avgCost as double?,
      currencyCode: currencyCode ?? this.currencyCode,
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
    holdings,
  ];

  // HoldingState içine ekle
  String get currencySymbol {
    return CurrencyDefaults.list
        .firstWhere(
          (c) => c.code == currencyCode,
          orElse: () => CurrencyDefaults.list.first,
        )
        .symbol;
  }
}

const _sentinel = Object();
