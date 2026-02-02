import 'package:equatable/equatable.dart';
import '../../data/model/portfolio_model.dart';

sealed class PortfolioEvent extends Equatable {
  const PortfolioEvent();
  @override
  List<Object?> get props => [];
}

class LoadPortfolios extends PortfolioEvent {
  const LoadPortfolios({this.selectPortfolioId});
  final String? selectPortfolioId;

  @override
  List<Object?> get props => [selectPortfolioId];
}

class SelectPortfolio extends PortfolioEvent {
  const SelectPortfolio(this.portfolioId);
  final String portfolioId;

  @override
  List<Object?> get props => [portfolioId];
}

class UpsertPortfolio extends PortfolioEvent {
  const UpsertPortfolio(this.portfolio);
  final PortfolioModel portfolio;

  @override
  List<Object?> get props => [portfolio];
}

class DeletePortfolio extends PortfolioEvent {
  const DeletePortfolio(this.portfolioId);
  final String portfolioId;

  @override
  List<Object?> get props => [portfolioId];
}

class ResetPortfolioState extends PortfolioEvent {
  const ResetPortfolioState();
}
