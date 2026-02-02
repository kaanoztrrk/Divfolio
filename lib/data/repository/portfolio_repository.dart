import '../../core/enum/hive_box_enum.dart';
import '../../service/hive_manager.dart';
import '../model/portfolio_model.dart';

/// Hive / DB bağımsız sözleşme
abstract class PortfolioRepository {
  Future<List<PortfolioModel>> getPortfolios();

  Future<PortfolioModel?> getPortfolio(String portfolioId);

  Future<void> upsertPortfolio(PortfolioModel portfolio);

  Future<void> deletePortfolio(String portfolioId);

  Future<void> ensureDefaultPortfolio();
}

/// HiveManager (dynamic box) ile çalışan implementasyon
///
/// - Box: HiveBoxKey.portfolios.name
/// - Key: portfolio.id
class HivePortfolioRepository implements PortfolioRepository {
  HivePortfolioRepository({HiveManager? hive}) : _hive = hive ?? HiveManager();

  final HiveManager _hive;

  String get _box => HiveBoxKey.portfolios.name;

  @override
  Future<List<PortfolioModel>> getPortfolios() async {
    final list = _hive.where<PortfolioModel>(_box, (_) => true)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return list;
  }

  @override
  Future<PortfolioModel?> getPortfolio(String portfolioId) async {
    final list = _hive.where<PortfolioModel>(_box, (p) => p.id == portfolioId);
    return list.isEmpty ? null : list.first;
  }

  @override
  Future<void> upsertPortfolio(PortfolioModel portfolio) async {
    final now = DateTime.now();

    final toSave = PortfolioModel(
      id: portfolio.id,
      name: portfolio.name,
      baseCurrencyCode: portfolio.baseCurrencyCode,
      createdAt: portfolio.createdAt,
      updatedAt: portfolio.updatedAt ?? now,
      notes: portfolio.notes,
    );

    await _hive.put(_box, toSave.id, toSave);
  }

  @override
  Future<void> deletePortfolio(String portfolioId) async {
    await _hive.delete(_box, portfolioId);
  }

  @override
  Future<void> ensureDefaultPortfolio() async {
    // Box boşsa 1 tane default oluştur
    final list = _hive.where<PortfolioModel>(_box, (_) => true);
    if (list.isNotEmpty) return;

    final now = DateTime.now();

    await upsertPortfolio(
      PortfolioModel(
        id: "main_id",
        name: "Main Portfolio",
        baseCurrencyCode: "USD",
        createdAt: now,
        updatedAt: now,
        notes: null,
      ),
    );
  }
}
