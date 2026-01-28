import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/hive_box_enum.dart';
import '../../../data/model/holding_model.dart';
import '../../../data/model/portfolio_model.dart';
import '../../../service/hive_manager.dart';

class HoldingFormState extends Equatable {
  const HoldingFormState({
    this.loading = false,
    this.error,
    this.portfolios = const [],
    this.selectedPortfolioId,
  });

  final bool loading;
  final String? error;

  final List<PortfolioModel> portfolios;
  final String? selectedPortfolioId;

  HoldingFormState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
    List<PortfolioModel>? portfolios,
    String? selectedPortfolioId,
  }) {
    return HoldingFormState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      portfolios: portfolios ?? this.portfolios,
      selectedPortfolioId: selectedPortfolioId ?? this.selectedPortfolioId,
    );
  }

  @override
  List<Object?> get props => [loading, error, portfolios, selectedPortfolioId];
}

class HoldingFormCubit extends Cubit<HoldingFormState> {
  HoldingFormCubit({HiveManager? hive})
    : _hive = hive ?? HiveManager(),
      super(const HoldingFormState());

  final HiveManager _hive;

  String get _portfoliosBox => HiveBoxKey.portfolios.name;
  String get _holdingsBox => HiveBoxKey.holdings.name;

  Future<void> loadPortfolios({String? initialSelectedId}) async {
    emit(state.copyWith(loading: true, clearError: true));

    try {
      final list = _hive.getAll<PortfolioModel>(_portfoliosBox)
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      String? selected = initialSelectedId?.trim();

      if (selected == null || selected.isEmpty) {
        selected = list.isEmpty ? null : list.first.id;
      } else {
        if (!list.any((p) => p.id == selected)) {
          selected = list.isEmpty ? null : list.first.id;
        }
      }

      emit(
        state.copyWith(
          loading: false,
          portfolios: list,
          selectedPortfolioId: selected,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void selectPortfolio(String portfolioId) {
    emit(state.copyWith(selectedPortfolioId: portfolioId));
  }

  Future<PortfolioModel> createPortfolio({
    required String name,
    required String baseCurrencyCode,
  }) async {
    emit(state.copyWith(loading: true, clearError: true));

    try {
      final n = name.trim();
      if (n.isEmpty) throw StateError('Portfolio name boş olamaz.');

      final id = 'pf-${DateTime.now().microsecondsSinceEpoch}';
      final model = PortfolioModel(
        id: id,
        name: n,
        baseCurrencyCode: baseCurrencyCode.trim().toUpperCase(),
        createdAt: DateTime.now(),
        updatedAt: null,
        notes: null,
      );

      await _hive.put(_portfoliosBox, model.id, model);

      await loadPortfolios(initialSelectedId: model.id);
      return model;
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
      rethrow;
    }
  }

  Future<void> saveHolding({
    required String portfolioId,
    required String companyId,
    required double shares,
    double? avgCost,
    String? currencyCode,
  }) async {
    emit(state.copyWith(loading: true, clearError: true));

    try {
      final pid = portfolioId.trim();
      final cid = companyId.trim();

      if (pid.isEmpty) throw StateError('Portfolio seçilmedi.');
      if (cid.isEmpty) throw StateError('Company ID boş olamaz.');
      if (shares.isNaN || shares.isInfinite) {
        throw StateError('Shares geçersiz.');
      }
      if (shares <= 0) throw StateError('Shares > 0 olmalı.');

      final key = '$pid|$cid';

      final model = HoldingModel(
        id: key,
        portfolioId: pid,
        companyId: cid,
        shares: shares,
        avgCost: avgCost,
        currencyCode: currencyCode?.trim().toUpperCase(),
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      await _hive.put(_holdingsBox, key, model);

      emit(state.copyWith(loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
      rethrow;
    }
  }
}
