import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/portfolio_repository.dart';
import '../../service/log_service.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc(this._repository) : super(const PortfolioState()) {
    on<LoadPortfolios>(_onLoadPortfolios);
    on<SelectPortfolio>(_onSelectPortfolio);
    on<UpsertPortfolio>(_onUpsertPortfolio);
    on<DeletePortfolio>(_onDeletePortfolio);
    on<ResetPortfolioState>((event, emit) => emit(const PortfolioState()));
  }

  final PortfolioRepository _repository;
  final LogService _log = LogService.instance;

  Future<void> _onLoadPortfolios(
    LoadPortfolios event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      // ✅ boşsa default portfolio oluştur
      await _repository.ensureDefaultPortfolio();

      // ✅ sonra listeyi çek
      final list = await _repository.getPortfolios();

      // seçim mantığı
      String? selectedId;

      if (event.selectPortfolioId != null &&
          list.any((p) => p.id == event.selectPortfolioId)) {
        selectedId = event.selectPortfolioId;
      } else if (state.selectedPortfolioId != null &&
          list.any((p) => p.id == state.selectedPortfolioId)) {
        selectedId = state.selectedPortfolioId;
      } else if (list.isNotEmpty) {
        selectedId = list.first.id;
      }

      emit(
        state.copyWith(
          loading: false,
          portfolios: list,
          selectedPortfolioId: selectedId,
          clearSelection: list.isEmpty,
        ),
      );

      _log.debug("✅ Portfolios loaded. count=${list.length}", tag: 'PORTFOLIO');
    } catch (e, s) {
      _log.error("❌ LoadPortfolios: $e", tag: 'PORTFOLIO', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onSelectPortfolio(SelectPortfolio event, Emitter<PortfolioState> emit) {
    final exists = state.portfolios.any((p) => p.id == event.portfolioId);
    if (!exists) return;
    emit(state.copyWith(selectedPortfolioId: event.portfolioId));
  }

  Future<void> _onUpsertPortfolio(
    UpsertPortfolio event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      await _repository.upsertPortfolio(event.portfolio);

      final list = await _repository.getPortfolios();

      emit(
        state.copyWith(
          loading: false,
          portfolios: list,
          selectedPortfolioId: event.portfolio.id,
        ),
      );

      _log.debug(
        "✅ Portfolio upserted. id=${event.portfolio.id}",
        tag: 'PORTFOLIO',
      );
    } catch (e, s) {
      _log.error("❌ UpsertPortfolio: $e", tag: 'PORTFOLIO', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onDeletePortfolio(
    DeletePortfolio event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      await _repository.deletePortfolio(event.portfolioId);

      // silme sonrası eğer hepsi silindiyse tekrar default oluştur
      await _repository.ensureDefaultPortfolio();

      final list = await _repository.getPortfolios();

      final wasSelected = state.selectedPortfolioId == event.portfolioId;

      String? newSelectedId = state.selectedPortfolioId;
      if (wasSelected) {
        newSelectedId = list.isNotEmpty ? list.first.id : null;
      }

      emit(
        state.copyWith(
          loading: false,
          portfolios: list,
          selectedPortfolioId: newSelectedId,
          clearSelection: list.isEmpty,
        ),
      );

      _log.debug(
        "✅ Portfolio deleted. id=${event.portfolioId}",
        tag: 'PORTFOLIO',
      );
    } catch (e, s) {
      _log.error("❌ DeletePortfolio: $e", tag: 'PORTFOLIO', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
