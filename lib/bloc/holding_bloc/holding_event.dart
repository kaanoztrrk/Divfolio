import 'package:equatable/equatable.dart';
import '../../data/model/holding_model.dart';

sealed class HoldingEvent extends Equatable {
  const HoldingEvent();

  @override
  List<Object?> get props => [];
}

class LoadHoldings extends HoldingEvent {
  const LoadHoldings(this.portfolioId);
  final String portfolioId;

  @override
  List<Object?> get props => [portfolioId];
}

class UpdateHoldingForm extends HoldingEvent {
  const UpdateHoldingForm({
    this.editingHolding,
    this.portfolioId,
    this.companyId,
    this.companyName,
    this.shares,
    this.avgCost,
    this.currencyCode,
  });

  final HoldingModel? editingHolding;
  final String? portfolioId;
  final String? companyId;
  final String? companyName;
  final double? shares;
  final double? avgCost;
  final String? currencyCode;
  // payDate KALDIRILDI → DividendModel'e ait
}

class SubmitHolding extends HoldingEvent {
  const SubmitHolding();
}

class DeleteHolding extends HoldingEvent {
  const DeleteHolding(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class ResetHoldingForm extends HoldingEvent {
  const ResetHoldingForm();
}

class LoadAllHoldings extends HoldingEvent {
  const LoadAllHoldings();
}
