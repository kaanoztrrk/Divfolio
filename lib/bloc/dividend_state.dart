import 'package:equatable/equatable.dart';

import '../data/model/dividend_model.dart';

class DividendState extends Equatable {
  final bool loading;
  final String? error;

  /// UI context
  final String? selectedPortfolioId;
  final String? selectedCompanyId;

  /// Data
  final List<Dividend> dividends;

  /// Summary (opsiyonel ekran)
  final int? summaryYear;
  final Map<String, double> totalsByCurrency; // currency -> total net
  final Map<String, Map<String, double>>
  byCompanyByCurrency; // companyId -> (currency -> total)

  const DividendState({
    this.loading = false,
    this.error,
    this.selectedPortfolioId,
    this.selectedCompanyId,
    this.dividends = const [],
    this.summaryYear,
    this.totalsByCurrency = const {},
    this.byCompanyByCurrency = const {},
  });

  DividendState copyWith({
    bool? loading,
    String? error,
    String? selectedPortfolioId,
    String? selectedCompanyId,
    List<Dividend>? dividends,
    int? summaryYear,
    Map<String, double>? totalsByCurrency,
    Map<String, Map<String, double>>? byCompanyByCurrency,
  }) {
    return DividendState(
      loading: loading ?? this.loading,
      error: error,
      selectedPortfolioId: selectedPortfolioId ?? this.selectedPortfolioId,
      selectedCompanyId: selectedCompanyId,
      dividends: dividends ?? this.dividends,
      summaryYear: summaryYear ?? this.summaryYear,
      totalsByCurrency: totalsByCurrency ?? this.totalsByCurrency,
      byCompanyByCurrency: byCompanyByCurrency ?? this.byCompanyByCurrency,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    error ?? '',
    selectedPortfolioId ?? '',
    selectedCompanyId ?? '',
    dividends,
    summaryYear ?? -1,
    totalsByCurrency,
    byCompanyByCurrency,
  ];
}
