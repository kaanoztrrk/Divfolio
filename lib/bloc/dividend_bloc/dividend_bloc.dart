import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/dividend_repository.dart';
import '../../service/log_service.dart';
import 'dividend_event.dart';
import 'dividend_state.dart';

class DividendBloc extends Bloc<DividendEvent, DividendState> {
  DividendBloc(this._repository) : super(const DividendState()) {
    on<LoadDividends>(_onLoadDividends);
    on<LoadDividendsByCompany>(_onLoadDividendsByCompany);
    on<UpsertDividend>(_onUpsertDividend);
    on<DeleteDividend>(_onDeleteDividend);
    on<LoadDividendSummary>(_onLoadDividendSummary);
    on<ResetDividendState>((event, emit) => emit(const DividendState()));
  }

  final DividendRepository _repository;
  final LogService _log = LogService.instance;

  Future<void> _onLoadDividends(
    LoadDividends event,
    Emitter<DividendState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final list = await _repository.getDividends(event.portfolioId);

      emit(
        state.copyWith(
          loading: false,
          dividends: list,
          selectedPortfolioId: event.portfolioId,
          clearCompanyFilter: true, // <-- ALL dividends ekranı
        ),
      );

      _log.debug("✅ Dividends loaded. count=${list.length}", tag: 'DIVIDEND');
    } catch (e, s) {
      _log.error("❌ LoadDividends: $e", tag: 'DIVIDEND', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadDividendsByCompany(
    LoadDividendsByCompany event,
    Emitter<DividendState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final list = await _repository.getDividendsByCompany(
        portfolioId: event.portfolioId,
        companyId: event.companyId,
      );

      emit(
        state.copyWith(
          loading: false,
          dividends: list,
          selectedPortfolioId: event.portfolioId,
          selectedCompanyId: event.companyId,
        ),
      );

      _log.debug(
        "✅ Dividends by company loaded. count=${list.length}",
        tag: 'DIVIDEND',
      );
    } catch (e, s) {
      _log.error(
        "❌ LoadDividendsByCompany: $e",
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
    emit(state.copyWith(loading: true, clearError: true));

    try {
      await _repository.upsertDividend(event.dividend);

      final pid = event.dividend.portfolioId;

      // Mevcut filtre var mı? Varsa sadece aynı company için ekleme yapıldıysa filtreyi koru.
      final currentFilterCompanyId = state.selectedCompanyId;
      final keepCompanyFilter =
          currentFilterCompanyId != null &&
          currentFilterCompanyId == event.dividend.companyId;

      final list = keepCompanyFilter
          ? await _repository.getDividendsByCompany(
              portfolioId: pid,
              companyId: currentFilterCompanyId,
            )
          : await _repository.getDividends(pid);

      emit(
        state.copyWith(
          loading: false,
          dividends: list,
          selectedPortfolioId: pid,
          selectedCompanyId: keepCompanyFilter ? currentFilterCompanyId : null,
        ),
      );

      _log.debug(
        "✅ Dividend upserted. id=${event.dividend.id}",
        tag: 'DIVIDEND',
      );
    } catch (e, s) {
      _log.error("❌ UpsertDividend: $e", tag: 'DIVIDEND', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteDividend(
    DeleteDividend event,
    Emitter<DividendState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearError: true));

    try {
      await _repository.deleteDividend(event.dividendId);

      final pid = state.selectedPortfolioId;
      if (pid == null) {
        emit(state.copyWith(loading: false));
        return;
      }

      final cid = state.selectedCompanyId;
      final list = (cid == null)
          ? await _repository.getDividends(pid)
          : await _repository.getDividendsByCompany(
              portfolioId: pid,
              companyId: cid,
            );

      emit(state.copyWith(loading: false, dividends: list));

      _log.debug("✅ Dividend deleted. id=${event.dividendId}", tag: 'DIVIDEND');
    } catch (e, s) {
      _log.error("❌ DeleteDividend: $e", tag: 'DIVIDEND', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadDividendSummary(
    LoadDividendSummary event,
    Emitter<DividendState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearError: true));

    try {
      final totalsByCurrency = await _repository.getTotalNetDividendsByCurrency(
        portfolioId: event.portfolioId,
        year: event.year,
      );

      final byCompanyByCurrency = await _repository
          .getNetDividendsByCompanyByCurrency(
            portfolioId: event.portfolioId,
            year: event.year,
          );

      emit(
        state.copyWith(
          loading: false,
          selectedPortfolioId: event.portfolioId,
          summaryYear: event.year,
          totalsByCurrency: totalsByCurrency,
          byCompanyByCurrency: byCompanyByCurrency,
        ),
      );

      _log.debug("✅ Dividend summary loaded.", tag: 'DIVIDEND');
    } catch (e, s) {
      _log.error("❌ LoadDividendSummary: $e", tag: 'DIVIDEND', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
