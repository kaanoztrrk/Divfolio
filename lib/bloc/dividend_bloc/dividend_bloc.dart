import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/dividend_repository.dart';
import '../../service/log_service.dart';
import 'dividend_event.dart';
import 'dividend_state.dart';

class DividendBloc extends Bloc<DividendEvent, DividendState> {
  final DividendRepository _repository;
  final LogService _log = LogService.instance;
  late final StreamSubscription<void> _watchSub;

  DividendBloc(this._repository) : super(const DividendState()) {
    on<LoadDividends>(_onLoadDividends);
    on<LoadDividendsByCompany>(_onLoadDividendsByCompany);
    on<UpsertDividend>(_onUpsertDividend);
    on<DeleteDividend>(_onDeleteDividend);
    on<LoadDividendSummary>(_onLoadDividendSummary);
    on<ResetDividendState>((_, emit) => emit(const DividendState()));
    on<LoadAllDividends>(_onLoadAllDividends);
    _watchSub = _repository.watchChanges().listen((_) {
      final pid = state.selectedPortfolioId;
      if (pid != null) {
        add(LoadDividends(pid));
      } else {
        add(const LoadAllDividends());
      }
    });
  }

  Future<void> _onLoadAllDividends(
    LoadAllDividends event,
    Emitter<DividendState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final list = await _repository.getAllDividends();

      // Para birimi bazlı topla, asla tek sayıya indirme
      final totals = _groupByCurrency(list);

      emit(
        state.copyWith(
          loading: false,
          dividends: list,
          totalsByCurrency: totals,
        ),
      );

      _log.debug(
        "✅ LoadAllDividends | count=${list.length} | currencies=${totals.keys}",
        tag: 'DIVIDEND',
      );
    } catch (e, s) {
      _log.error("❌ LoadAllDividends: $e", tag: 'DIVIDEND', stackTrace: s);
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadDividends(
    LoadDividends event,
    Emitter<DividendState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final list = await _repository.getDividends(event.portfolioId);
      final totals = _groupByCurrency(list);
      final byCompanyByCurrency =
          await _repository // ← ekle
              .getNetDividendsByCompanyByCurrency(
                portfolioId: event.portfolioId,
              );

      emit(
        state.copyWith(
          loading: false,
          dividends: list,
          selectedPortfolioId: event.portfolioId,
          clearCompanyFilter: true,
          totalsByCurrency: totals,
          byCompanyByCurrency: byCompanyByCurrency, // ← ekle
        ),
      );
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
        holdingId: event.companyId,
      );
      final totals = _groupByCurrency(list);

      emit(
        state.copyWith(
          loading: false,
          dividends: list,
          selectedPortfolioId: event.portfolioId,
          selectedCompanyId: event.companyId,
          totalsByCurrency: totals,
        ),
      );

      _log.debug(
        "✅ Dividends by company loaded | count=${list.length}",
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
      final currentFilterCompanyId = state.selectedCompanyId;
      final keepCompanyFilter =
          currentFilterCompanyId != null &&
          currentFilterCompanyId == event.dividend.holdingId;

      final list = keepCompanyFilter
          ? await _repository.getDividendsByCompany(
              portfolioId: pid,
              holdingId: currentFilterCompanyId,
            )
          : await _repository.getDividends(pid);

      final totals = _groupByCurrency(list);

      // Summary de güncellenir — stale kalmaz
      final totalsByCurrencyFull = await _repository
          .getTotalNetDividendsByCurrency(portfolioId: pid);
      final byCompanyByCurrency = await _repository
          .getNetDividendsByCompanyByCurrency(portfolioId: pid);

      emit(
        state.copyWith(
          loading: false,
          dividends: list,
          selectedPortfolioId: pid,
          selectedCompanyId: keepCompanyFilter ? currentFilterCompanyId : null,
          totalsByCurrency: totalsByCurrencyFull,
          byCompanyByCurrency: byCompanyByCurrency,
        ),
      );

      _log.debug(
        "✅ Dividend upserted | id=${event.dividend.id}",
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
      if (pid == null) return emit(state.copyWith(loading: false));

      final cid = state.selectedCompanyId;
      final list = cid == null
          ? await _repository.getDividends(pid)
          : await _repository.getDividendsByCompany(
              portfolioId: pid,
              holdingId: cid,
            );

      final totalsByCurrency = await _repository.getTotalNetDividendsByCurrency(
        portfolioId: pid,
      );
      final byCompanyByCurrency = await _repository
          .getNetDividendsByCompanyByCurrency(portfolioId: pid);

      emit(
        state.copyWith(
          loading: false,
          dividends: list,
          totalsByCurrency: totalsByCurrency,
          byCompanyByCurrency: byCompanyByCurrency,
        ),
      );

      _log.debug(
        "✅ Dividend deleted | id=${event.dividendId}",
        tag: 'DIVIDEND',
      );
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
      print('totalsByCurrency after summary: $totalsByCurrency');
      print('byCompanyByCurrency after summary: $byCompanyByCurrency');

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

  /// Dividend listesini para birimi bazlı toplar.
  /// TRY ve USD asla birleştirilmez.
  Map<String, double> _groupByCurrency(List<dynamic> list) {
    final map = <String, double>{};
    for (final d in list) {
      final cc = d.currencyCode.trim().toUpperCase();
      map[cc] = (map[cc] ?? 0) + d.netAmount;
    }
    return map;
  }

  @override
  Future<void> close() {
    _watchSub.cancel();
    return super.close();
  }
}
