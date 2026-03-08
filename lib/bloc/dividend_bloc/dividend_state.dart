import 'package:equatable/equatable.dart';
import '../../data/model/dividend_model.dart';

class DividendState extends Equatable {
  final bool loading;
  final String? error;
  final String? selectedPortfolioId;
  final String? selectedCompanyId;
  final List<DividendModel> dividends;
  final int? summaryYear;

  /// Para birimi bazlı net toplamlar
  /// Örn: {'TRY': 1500.0, 'USD': 200.0}
  /// Farklı para birimleri asla tek sayıya indirilmez
  final Map<String, double> totalsByCurrency;
  final Map<String, Map<String, double>> byCompanyByCurrency;

  const DividendState({
    this.loading = false,
    this.error,
    this.selectedPortfolioId,
    this.selectedCompanyId,
    this.dividends = const [],
    this.summaryYear,
    this.totalsByCurrency = const {},
    this.byCompanyByCurrency = const {},
    // totalNetDividends KALDIRILDI → farklı para birimlerini
    // tek sayıya indirmek yanıltıcı
  });

  DividendState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
    String? selectedPortfolioId,
    String? selectedCompanyId,
    bool clearCompanyFilter = false,
    List<DividendModel>? dividends,
    int? summaryYear,
    Map<String, double>? totalsByCurrency,
    Map<String, Map<String, double>>? byCompanyByCurrency,
  }) {
    return DividendState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      selectedPortfolioId: selectedPortfolioId ?? this.selectedPortfolioId,
      selectedCompanyId: clearCompanyFilter
          ? null
          : (selectedCompanyId ?? this.selectedCompanyId),
      dividends: dividends ?? this.dividends,
      summaryYear: summaryYear ?? this.summaryYear,
      totalsByCurrency: totalsByCurrency ?? this.totalsByCurrency,
      byCompanyByCurrency: byCompanyByCurrency ?? this.byCompanyByCurrency,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    error,
    selectedPortfolioId,
    selectedCompanyId,
    dividends,
    summaryYear,
    totalsByCurrency,
    byCompanyByCurrency,
  ];
}
