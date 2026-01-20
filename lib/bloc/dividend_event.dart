import 'package:equatable/equatable.dart';

import '../data/model/dividend_model.dart';

abstract class DividendEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// portfolioId için tüm dividendleri yükle
class LoadDividends extends DividendEvent {
  final String portfolioId;
  LoadDividends(this.portfolioId);

  @override
  List<Object?> get props => [portfolioId];
}

/// portfolio + company filtresi ile yükle
class LoadDividendsByCompany extends DividendEvent {
  final String portfolioId;
  final String companyId;

  LoadDividendsByCompany({required this.portfolioId, required this.companyId});

  @override
  List<Object?> get props => [portfolioId, companyId];
}

/// dividend ekle/güncelle
class UpsertDividend extends DividendEvent {
  final Dividend dividend;
  UpsertDividend(this.dividend);

  @override
  List<Object?> get props => [dividend];
}

/// dividend sil
class DeleteDividend extends DividendEvent {
  final String dividendId;
  DeleteDividend(this.dividendId);

  @override
  List<Object?> get props => [dividendId];
}

/// Özet (totals + breakdown) yükle
class LoadDividendSummary extends DividendEvent {
  final String portfolioId;
  final int? year;

  LoadDividendSummary({required this.portfolioId, this.year});

  @override
  List<Object?> get props => [portfolioId, year];
}

/// bloc state sıfırla
class ResetDividendState extends DividendEvent {}
