import 'dart:collection';

import '../../core/enum/hive_box_enum.dart';
import '../../service/hive_manager.dart';
import '../model/dividend_model.dart';

/// Hive / DB bağımsız sözleşme
abstract class DividendRepository {
  Future<List<DividendModel>> getDividends(String portfolioId);

  Future<List<DividendModel>> getDividendsByCompany({
    required String portfolioId,
    required String holdingId,
  });

  Future<void> upsertDividend(DividendModel dividend);

  Future<void> deleteDividend(String dividendId);

  Future<Map<String, double>> getTotalNetDividendsByCurrency({
    required String portfolioId,
    int? year,
  });

  Future<Map<String, Map<String, double>>> getNetDividendsByCompanyByCurrency({
    required String portfolioId,
    int? year,
  });
  Future<List<DividendModel>> getAllDividends();

  Stream<void> watchChanges();
}

/// HiveManager (dynamic box) ile çalışan implementasyon
///
/// - Box: HiveBoxKey.dividends.name
/// - Key: dividend.id
class HiveDividendRepository implements DividendRepository {
  HiveDividendRepository({HiveManager? hive}) : _hive = hive ?? HiveManager();

  final HiveManager _hive;

  String get _box => HiveBoxKey.dividends.name;

  @override
  Future<List<DividendModel>> getDividends(String portfolioId) async {
    final list = _hive.where<DividendModel>(
      _box,
      (d) => d.portfolioId == portfolioId,
    )..sort((a, b) => b.payDate.compareTo(a.payDate));
    return list;
  }

  @override
  Future<List<DividendModel>> getDividendsByCompany({
    required String portfolioId,
    required String holdingId,
  }) async {
    final list = _hive.where<DividendModel>(
      _box,
      (d) => d.portfolioId == portfolioId && d.holdingId == holdingId,
    )..sort((a, b) => b.payDate.compareTo(a.payDate));
    return list;
  }

  @override
  Future<void> upsertDividend(DividendModel dividend) async {
    await _hive.put(_box, dividend.id, dividend);
  }

  @override
  Future<void> deleteDividend(String dividendId) async {
    await _hive.delete(_box, dividendId);
  }

  @override
  Future<Map<String, double>> getTotalNetDividendsByCurrency({
    required String portfolioId,
    int? year,
  }) async {
    final list = await getDividends(portfolioId);

    final map = <String, double>{};
    for (final d in list) {
      if (year != null && d.payDate.year != year) continue;

      final cc = _normOrUnknown(d.currencyCode);
      map[cc] = (map[cc] ?? 0) + d.netAmount;
    }
    return _sortedByValueDesc(map);
  }

  @override
  Future<Map<String, Map<String, double>>> getNetDividendsByCompanyByCurrency({
    required String portfolioId,
    int? year,
  }) async {
    final list = await getDividends(portfolioId);
    for (final d in list) {
      print(
        'holdingId=${d.holdingId} '
        'shares=${d.sharesAtPayDate} '
        'divPerShare=${d.dividendPerShare} '
        'netOverride=${d.netOverride} '
        'netAmount=${d.netAmount} '
        'year=${d.payDate.year}',
      );
    }

    final result = <String, Map<String, double>>{};
    for (final d in list) {
      if (year != null && d.payDate.year != year) continue;

      final companyMap = result.putIfAbsent(
        d.holdingId,
        () => <String, double>{},
      );

      final cc = _normOrUnknown(d.currencyCode);
      companyMap[cc] = (companyMap[cc] ?? 0) + d.netAmount;
    }

    final holdingIds = result.keys.toList()
      ..sort((a, b) {
        final ta = result[a]!.values.fold<double>(0, (p, e) => p + e);
        final tb = result[b]!.values.fold<double>(0, (p, e) => p + e);
        return tb.compareTo(ta);
      });

    final sorted = <String, Map<String, double>>{};
    for (final id in holdingIds) {
      sorted[id] = _sortedByValueDesc(result[id]!);
    }
    return sorted;
  }

  String _normOrUnknown(String code) {
    final c = code.trim().toUpperCase();
    return c.isEmpty ? 'UNKNOWN' : c;
  }

  Map<String, double> _sortedByValueDesc(Map<String, double> input) {
    final keys = input.keys.toList()
      ..sort((a, b) => (input[b] ?? 0).compareTo(input[a] ?? 0));
    return LinkedHashMap.fromEntries(keys.map((k) => MapEntry(k, input[k]!)));
  }

  @override
  Future<List<DividendModel>> getAllDividends() async {
    final list = _hive.getAll<DividendModel>(_box)
      ..sort((a, b) => b.payDate.compareTo(a.payDate));
    return list;
  }

  @override
  Stream<void> watchChanges() {
    return _hive.watch(_box).map((_) => null);
  }
}
