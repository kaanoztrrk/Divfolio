import '../../core/enum/hive_box_enum.dart';
import '../../service/hive_manager.dart';
import '../model/holding_model.dart';
import 'package:uuid/uuid.dart';

abstract class HoldingRepository {
  Future<List<HoldingModel>> getHoldings(String portfolioId);
  Future<HoldingModel?> getHolding(String holdingId);
  Future<HoldingModel> createHolding(HoldingModel draft);
  Future<HoldingModel> updateHolding(HoldingModel holding);
  Future<void> deleteHolding(String holdingId);
  Future<List<HoldingModel>> getAllHoldings();
}

class HiveHoldingRepository implements HoldingRepository {
  HiveHoldingRepository({HiveManager? hive}) : _hive = hive ?? HiveManager();

  final HiveManager _hive;
  final _uuid = const Uuid();

  String get _box => HiveBoxKey.holdings.name;

  @override
  Future<List<HoldingModel>> getHoldings(String portfolioId) async {
    final list = _hive.where<HoldingModel>(
      _box,
      (h) => h.portfolioId == portfolioId,
    )..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return list;
  }

  @override
  Future<HoldingModel?> getHolding(String holdingId) async {
    return _hive.get<HoldingModel>(_box, holdingId);
  }

  @override
  Future<HoldingModel> createHolding(HoldingModel draft) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    final holding = HoldingModel(
      id: id,
      portfolioId: draft.portfolioId,
      companyId: draft.companyId,
      companyName: draft.companyName,
      shares: draft.shares,
      avgCost: draft.avgCost,
      currencyCode: draft.currencyCode,
      createdAt: now,
      updatedAt: now,
    );

    await _hive.put(_box, id, holding);
    return holding;
  }

  @override
  Future<HoldingModel> updateHolding(HoldingModel holding) async {
    final existing = await getHolding(holding.id);
    if (existing == null) {
      throw StateError('Holding not found: ${holding.id}');
    }

    final updated = holding.copyWith(updatedAt: DateTime.now());
    await _hive.put(_box, holding.id, updated);
    return updated;
  }

  @override
  Future<void> deleteHolding(String holdingId) {
    return _hive.delete(_box, holdingId);
  }

  @override
  Future<List<HoldingModel>> getAllHoldings() async {
    final list = _hive.where<HoldingModel>(_box, (h) => true)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return list;
  }
}
