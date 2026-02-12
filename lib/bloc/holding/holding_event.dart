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

/// Form alanlarını parça parça güncellemek için
class UpdateHoldingForm extends HoldingEvent {
  const UpdateHoldingForm({
    this.editingHolding,
    this.portfolioId, // <-- yeni ekledik
    this.companyId,
    this.companyName,
    this.shares,
    this.avgCost,
    this.currencyCode,
    this.payDate,
  });

  /// null değilse update, null ise create
  final HoldingModel? editingHolding;

  final String? portfolioId; // <-- yeni alan
  final String? companyId;
  final String? companyName;
  final double? shares;
  final double? avgCost;
  final String? currencyCode;
  final DateTime? payDate;
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
