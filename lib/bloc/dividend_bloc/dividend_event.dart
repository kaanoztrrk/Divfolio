import 'package:equatable/equatable.dart';
import '../../data/model/dividend_model.dart';

sealed class DividendEvent extends Equatable {
  const DividendEvent();

  @override
  List<Object?> get props => [];
}

class LoadDividends extends DividendEvent {
  const LoadDividends(this.portfolioId);
  final String portfolioId;

  @override
  List<Object?> get props => [portfolioId];
}

class LoadDividendsByCompany extends DividendEvent {
  const LoadDividendsByCompany({
    required this.portfolioId,
    required this.companyId,
  });

  final String portfolioId;
  final String companyId;

  @override
  List<Object?> get props => [portfolioId, companyId];
}

class UpsertDividend extends DividendEvent {
  const UpsertDividend(this.dividend);
  final DividendModel dividend;

  @override
  List<Object?> get props => [dividend];
}

class DeleteDividend extends DividendEvent {
  const DeleteDividend(this.dividendId);
  final String dividendId;

  @override
  List<Object?> get props => [dividendId];
}

class LoadDividendSummary extends DividendEvent {
  const LoadDividendSummary({required this.portfolioId, this.year});

  final String portfolioId;
  final int? year;

  @override
  List<Object?> get props => [portfolioId, year];
}

class ResetDividendState extends DividendEvent {
  const ResetDividendState();
}
