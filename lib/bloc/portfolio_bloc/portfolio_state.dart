// portfolio_state.dart
import 'package:equatable/equatable.dart';
import '../../data/model/portfolio_model.dart';

class PortfolioState extends Equatable {
  final bool loading;
  final String? error;
  final List<PortfolioModel> portfolios;
  final String? selectedPortfolioId;

  const PortfolioState({
    this.loading = false,
    this.error,
    this.portfolios = const [],
    this.selectedPortfolioId,
  });

  PortfolioState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
    List<PortfolioModel>? portfolios,
    String? selectedPortfolioId,
    bool clearSelection = false,
  }) {
    return PortfolioState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      portfolios: portfolios ?? this.portfolios,
      selectedPortfolioId: clearSelection
          ? null
          : (selectedPortfolioId ?? this.selectedPortfolioId),
    );
  }

  PortfolioModel? get selectedPortfolio {
    if (selectedPortfolioId == null) return null;
    return portfolios.firstWhere(
      (p) => p.id == selectedPortfolioId,
      orElse: () => portfolios.first,
    );
  }

  @override
  List<Object?> get props => [loading, error, portfolios, selectedPortfolioId];
}
