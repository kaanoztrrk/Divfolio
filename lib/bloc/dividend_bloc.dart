import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/dividend_repository.dart';
import '../service/log_service.dart';
import 'dividend_event.dart';
import 'dividend_state.dart';

class DividendBloc extends Bloc<DividendEvent, DividendState> {
  final DivfolioRepository _repository;
  final LogService _log = LogService.instance;

  DividendBloc(this._repository) : super(const DividendState()) {
    on<LoadDividends>(_onLoadDividends);
    on<LoadDividendsByCompany>(_onLoadDividendsByCompany);
    on<UpsertDividend>(_onUpsertDividend);
    on<DeleteDividend>(_onDeleteDividend);
    on<LoadDividendSummary>(_onLoadDividendSummary);
    on<ResetDividendState>((event, emit) => emit(const DividendState()));
  }

  Future<void> _onLoadDividends(
    LoadDividends event,
    Emitter<DividendState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final list = _repository.getDividends(event.portfolioId);

      _log.debug("✅ Dividends loaded. count=${list.length}", tag: 'DIVIDEND');

      emit(
        state.copyWith(
          loading: false,
          dividends: list,
          selectedPortfolioId: event.portfolioId,
          selectedCompanyId: null,
          error: null,
        ),
      );
    } catch (e, s) {
      _log.error("❌ LoadDividends error: $e", tag: 'DIVIDEND', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadDividendsByCompany(
    LoadDividendsByCompany event,
    Emitter<DividendState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final list = _repository.getDividendsByCompany(
        portfolioId: event.portfolioId,
        companyId: event.companyId,
      );

      _log.debug(
        "✅ Dividends loaded by company. count=${list.length}",
        tag: 'DIVIDEND',
      );

      emit(
        state.copyWith(
          loading: false,
          dividends: list,
          selectedPortfolioId: event.portfolioId,
          selectedCompanyId: event.companyId,
          error: null,
        ),
      );
    } catch (e, s) {
      _log.error(
        "❌ LoadDividendsByCompany error: $e",
        tag: 'DIVIDEND',
        stackTrace: s,
      );
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onUpsertDividend(
    UpsertDividend event,
    Emitter<DividendState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      _repository.upsertDividend(event.dividend);

      _log.debug(
        "✅ Dividend upserted. id=${event.dividend.id}",
        tag: 'DIVIDEND',
      );

      // UI contextine göre refresh
      final pid = event.dividend.portfolioId;
      final cid = state.selectedCompanyId;

      final list = (cid == null)
          ? _repository.getDividends(pid)
          : _repository.getDividendsByCompany(portfolioId: pid, companyId: cid);

      emit(
        state.copyWith(
          loading: false,
          dividends: list,
          selectedPortfolioId: pid,
          error: null,
        ),
      );
    } catch (e, s) {
      _log.error("❌ UpsertDividend error: $e", tag: 'DIVIDEND', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteDividend(
    DeleteDividend event,
    Emitter<DividendState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      _repository.deleteDividend(event.dividendId);

      _log.debug("✅ Dividend deleted. id=${event.dividendId}", tag: 'DIVIDEND');

      // Refresh: state’de seçili portfolio yoksa sadece loading kapat
      final pid = state.selectedPortfolioId;
      if (pid == null) {
        emit(state.copyWith(loading: false, error: null));
        return;
      }

      final cid = state.selectedCompanyId;
      final list = (cid == null)
          ? _repository.getDividends(pid)
          : _repository.getDividendsByCompany(portfolioId: pid, companyId: cid);

      emit(state.copyWith(loading: false, dividends: list, error: null));
    } catch (e, s) {
      _log.error("❌ DeleteDividend error: $e", tag: 'DIVIDEND', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadDividendSummary(
    LoadDividendSummary event,
    Emitter<DividendState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final totalsByCurrency = _repository.getTotalNetDividendsByCurrency(
        portfolioId: event.portfolioId,
        year: event.year,
      );

      final byCompanyByCurrency = _repository
          .getNetDividendsByCompanyByCurrency(
            portfolioId: event.portfolioId,
            year: event.year,
          );

      _log.debug("✅ Dividend summary loaded.", tag: 'DIVIDEND');

      emit(
        state.copyWith(
          loading: false,
          selectedPortfolioId: event.portfolioId,
          summaryYear: event.year,
          totalsByCurrency: totalsByCurrency,
          byCompanyByCurrency: byCompanyByCurrency,
          error: null,
        ),
      );
    } catch (e, s) {
      _log.error(
        "❌ LoadDividendSummary error: $e",
        tag: 'DIVIDEND',
        stackTrace: s,
      );
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
