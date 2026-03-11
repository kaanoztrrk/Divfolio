import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/holding_model.dart';
import '../../data/repository/dividend_repository.dart';
import '../../data/repository/holding_repository.dart';
import '../../service/log_service.dart';
import 'holding_event.dart';
import 'holding_state.dart';

class HoldingBloc extends Bloc<HoldingEvent, HoldingState> {
  final HoldingRepository _repository;
  final DividendRepository _dividendRepository;
  final LogService _log = LogService.instance;
  late final StreamSubscription<void> _watchSub;

  HoldingBloc({
    required HoldingRepository holdingRepository,
    required DividendRepository dividendRepository,
  }) : _repository = holdingRepository,
       _dividendRepository = dividendRepository,
       super(const HoldingState()) {
    on<LoadHoldings>(_onLoadHoldings);
    on<UpdateHoldingForm>(_onUpdateHoldingForm);
    on<SubmitHolding>(_onSubmitHolding);
    on<DeleteHolding>(_onDeleteHolding);
    on<ResetHoldingForm>(_onResetHoldingForm);
    on<LoadAllHoldings>(_onLoadAllHoldings);
    _watchSub = _repository.watchChanges().listen((_) {
      final pid = state.selectedPortfolioId;
      if (pid != null) {
        add(LoadHoldings(pid));
      } else {
        add(const LoadAllHoldings());
      }
    });
  }

  Future<void> _onLoadHoldings(
    LoadHoldings event,
    Emitter<HoldingState> emit,
  ) async {
    _log.debug(
      "➡️ LoadHoldings | portfolioId=${event.portfolioId}",
      tag: 'HOLDING',
    );
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final list = await _repository.getHoldings(event.portfolioId);
      emit(
        state.copyWith(
          loading: false,
          holdings: list,
          selectedPortfolioId: event.portfolioId,
        ),
      );
      _log.debug("✅ Holdings loaded | count=${list.length}", tag: 'HOLDING');
    } catch (e, s) {
      _log.error("❌ LoadHoldings: $e", tag: 'HOLDING', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onUpdateHoldingForm(
    UpdateHoldingForm event,
    Emitter<HoldingState> emit,
  ) {
    emit(
      HoldingState(
        loading: state.loading,
        error: state.error,
        selectedPortfolioId: event.portfolioId ?? state.selectedPortfolioId,
        editingHolding: event.editingHolding ?? state.editingHolding,
        companyId: event.companyId ?? state.companyId,
        companyName: event.companyName ?? state.companyName,
        shares: event.shares ?? state.shares,
        avgCost: event.avgCost ?? state.avgCost,
        currencyCode: event.currencyCode ?? state.currencyCode,
        holdings: state.holdings,
      ),
    );
  }

  Future<void> _onSubmitHolding(
    SubmitHolding event,
    Emitter<HoldingState> emit,
  ) async {
    final pid = state.selectedPortfolioId;
    if (pid == null) {
      _log.error(
        "❌ SubmitHolding: selectedPortfolioId is NULL",
        tag: 'HOLDING',
      );
      return;
    }

    emit(state.copyWith(loading: true, clearError: true));
    try {
      final isCreate = state.editingHolding == null;

      if (isCreate) {
        await _repository.createHolding(
          HoldingModel(
            id: '',
            portfolioId: pid,
            companyId: state.companyId,
            companyName: state.companyName,
            shares: state.shares,
            avgCost: state.avgCost, // null olabilir, 0 değil
            currencyCode: state.currencyCode,
            createdAt: DateTime.now(),
          ),
        );
        print(
          'SubmitHolding → pid=$pid avgCost=${state.avgCost} shares=${state.shares}',
        );

        _log.debug(
          "➕ Holding created | companyId=${state.companyId}",
          tag: 'HOLDING',
        );
      } else {
        await _repository.updateHolding(
          state.editingHolding!.copyWith(
            companyId: state.companyId,
            companyName: state.companyName,
            shares: state.shares,
            avgCost: state.avgCost, // null olabilir, 0 değil
            currencyCode: state.currencyCode,
            updatedAt: DateTime.now(),
          ),
        );
        _log.debug(
          "✏️ Holding updated | id=${state.editingHolding!.id}",
          tag: 'HOLDING',
        );
      }

      final list = await _repository.getHoldings(pid);
      emit(
        state.copyWith(
          loading: false,
          holdings: list,
          clearEditingHolding: true,
        ),
      );
      _log.debug(
        "✅ SubmitHolding success | total=${list.length}",
        tag: 'HOLDING',
      );
    } catch (e, s) {
      _log.error("❌ SubmitHolding: $e", tag: 'HOLDING', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteHolding(
    DeleteHolding event,
    Emitter<HoldingState> emit,
  ) async {
    _log.debug("🗑️ DeleteHolding | id=${event.id}", tag: 'HOLDING');
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final pid = state.selectedPortfolioId;

      // 1. Bu holding'e ait dividend'leri sil
      if (pid != null) {
        final dividends = await _dividendRepository.getDividendsByCompany(
          portfolioId: pid,
          holdingId: event.id,
        );
        for (final d in dividends) {
          await _dividendRepository.deleteDividend(d.id);
        }
        _log.debug(
          "🗑️ Dividends deleted | count=${dividends.length}",
          tag: 'HOLDING',
        );
      }

      // 2. Holding'i sil
      await _repository.deleteHolding(event.id);

      if (pid == null) {
        emit(state.copyWith(loading: false));
        return;
      }

      final list = await _repository.getHoldings(pid);
      emit(state.copyWith(loading: false, holdings: list));
      _log.debug(
        "✅ Holding deleted | remaining=${list.length}",
        tag: 'HOLDING',
      );
    } catch (e, s) {
      _log.error("❌ DeleteHolding: $e", tag: 'HOLDING', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onResetHoldingForm(ResetHoldingForm event, Emitter<HoldingState> emit) {
    emit(
      state.copyWith(
        clearEditingHolding: true,
        companyId: '',
        companyName: '',
        shares: 0,
        avgCost: null,
        currencyCode: 'USD',
        clearError: true,
      ),
    );
  }

  Future<void> _onLoadAllHoldings(
    LoadAllHoldings event,
    Emitter<HoldingState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final list = await _repository.getAllHoldings();
      emit(state.copyWith(loading: false, holdings: list));
    } catch (e, s) {
      _log.error("❌ LoadAllHoldings: $e", tag: 'HOLDING', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _watchSub.cancel();
    return super.close();
  }
}
