// holding_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/holding_model.dart';
import '../../data/repository/holding_repository.dart';
import '../../service/log_service.dart';
import 'holding_event.dart';
import 'holding_state.dart';

class HoldingBloc extends Bloc<HoldingEvent, HoldingState> {
  final HoldingRepository _repo;
  final LogService _log = LogService.instance;

  HoldingBloc(this._repo) : super(const HoldingState()) {
    on<LoadHoldings>(_load);
    on<UpdateHoldingForm>(_updateForm);
    on<SubmitHolding>(_submit);
    on<DeleteHolding>(_delete);
  }

  Future<void> _load(LoadHoldings e, Emitter<HoldingState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final list = await _repo.getHoldings(e.portfolioId);
      emit(
        state.copyWith(
          loading: false,
          holdings: list,
          selectedPortfolioId: e.portfolioId,
        ),
      );
      _log.debug("✅ Holdings loaded. count=${list.length}", tag: 'HOLDING');
    } catch (err, st) {
      _log.error(err.toString(), tag: 'HoldingBloc', stackTrace: st);
      emit(state.copyWith(loading: false, error: err.toString()));
    }
  }

  void _updateForm(UpdateHoldingForm e, Emitter<HoldingState> emit) {
    emit(
      state.copyWith(
        editingHolding: e.editingHolding ?? state.editingHolding,
        selectedPortfolioId:
            e.portfolioId ?? state.selectedPortfolioId, // <-- eklendi
        companyId: e.companyId,
        companyName: e.companyName,
        shares: e.shares,
        avgCost: e.avgCost,
        currencyCode: e.currencyCode,
        payDate: e.payDate,
      ),
    );
  }

  Future<void> _submit(SubmitHolding e, Emitter<HoldingState> emit) async {
    if (state.selectedPortfolioId == null) return;

    emit(state.copyWith(loading: true));
    try {
      if (state.editingHolding == null) {
        await _repo.createHolding(
          HoldingModel(
            id: '', // repo overwrite
            portfolioId: state.selectedPortfolioId!,
            companyId: state.companyId,
            companyName: state.companyName,
            shares: state.shares,
            avgCost: state.avgCost ?? 0,
            currencyCode: state.currencyCode ?? 'USD',
            payDate: state.payDate,
            createdAt: DateTime.now(),
          ),
        );
      } else {
        await _repo.updateHolding(
          state.editingHolding!.copyWith(
            companyId: state.companyId,
            companyName: state.companyName,
            shares: state.shares,
            avgCost: state.avgCost ?? 0,
            currencyCode: state.currencyCode ?? 'USD',
            payDate: state.payDate,
          ),
        );
      }

      final list = await _repo.getHoldings(state.selectedPortfolioId!);
      emit(
        state.copyWith(loading: false, holdings: list, editingHolding: null),
      );
    } catch (err, st) {
      _log.error(err.toString(), tag: 'HoldingBloc', stackTrace: st);
      emit(state.copyWith(loading: false, error: err.toString()));
    }
  }

  Future<void> _delete(DeleteHolding e, Emitter<HoldingState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      await _repo.deleteHolding(e.id);
      // TODO: burada bağlı dividendleri temizle (cascade)
      emit(state.copyWith(loading: false));
      _log.debug("✅ Holding deleted. id=${e.id}", tag: 'HoldingBloc');
    } catch (err, st) {
      _log.error(err.toString(), tag: 'HoldingBloc', stackTrace: st);
      emit(state.copyWith(loading: false, error: err.toString()));
    }
  }
}
