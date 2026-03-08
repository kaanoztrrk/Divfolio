import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../data/model/portfolio_model.dart';
import '../../data/repository/dividend_repository.dart';
import '../../data/repository/holding_repository.dart';
import '../../data/repository/portfolio_repository.dart';
import '../../service/log_service.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final PortfolioRepository _repository;
  final HoldingRepository _holdingRepository;
  final DividendRepository _dividendRepository;
  final LogService _log = LogService.instance;
  final _uuid = const Uuid();

  PortfolioBloc({
    required PortfolioRepository portfolioRepository,
    required HoldingRepository holdingRepository,
    required DividendRepository dividendRepository,
  }) : _repository = portfolioRepository,
       _holdingRepository = holdingRepository,
       _dividendRepository = dividendRepository,
       super(const PortfolioState()) {
    on<LoadPortfolios>(_onLoadPortfolios);
    on<SelectPortfolio>(_onSelectPortfolio);
    on<UpsertPortfolio>(_onUpsertPortfolio);
    on<DeletePortfolio>(_onDeletePortfolio);
    on<ResetPortfolioState>((_, emit) => emit(const PortfolioState()));
  }

  Future<void> _onLoadPortfolios(
    LoadPortfolios event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      await _ensureDefaultPortfolio();
      final list = await _repository.getPortfolios();

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
      // 1. Bu portfolio'nun tüm holding'lerini al
      final holdings = await _holdingRepository.getHoldings(event.portfolioId);

      // 2. Her holding'in dividend'lerini sil
      for (final holding in holdings) {
        final dividends = await _dividendRepository.getDividendsByCompany(
          portfolioId: event.portfolioId,
          holdingId: holding.id,
        );
        for (final dividend in dividends) {
          await _dividendRepository.deleteDividend(dividend.id);
        }
        _log.debug(
          "🗑️ Dividends deleted for holding=${holding.id}",
          tag: 'PORTFOLIO',
        );
      }

      // 3. Holding'leri sil
      for (final holding in holdings) {
        await _holdingRepository.deleteHolding(holding.id);
      }
      _log.debug(
        "🗑️ Holdings deleted for portfolio=${event.portfolioId}",
        tag: 'PORTFOLIO',
      );

      // 4. Portfolio'yu sil
      await _repository.deletePortfolio(event.portfolioId);

      // 5. Gerekirse default portfolio oluştur
      await _ensureDefaultPortfolio();

      final list = await _repository.getPortfolios();
      final newSelectedId = state.selectedPortfolioId == event.portfolioId
          ? (list.isNotEmpty ? list.first.id : null)
          : state.selectedPortfolioId;

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

  /// UUID ile default portfolio oluşturur.
  /// Hardcoded "main_id" yerine her cihazda benzersiz ID üretilir.
  Future<void> _ensureDefaultPortfolio() async {
    final list = await _repository.getPortfolios();
    if (list.isNotEmpty) return;

    final now = DateTime.now();
    await _repository.upsertPortfolio(
      PortfolioModel(
        id: _uuid.v4(),
        name: 'Main Portfolio',
        baseCurrencyCode: 'USD',
        createdAt: now,
        updatedAt: now,
        notes: null,
      ),
    );

    _log.debug("✅ Default portfolio created.", tag: 'PORTFOLIO');
  }
}
