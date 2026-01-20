import 'dart:collection';

import '../model/company_model.dart';
import '../model/currency_model.dart';
import '../model/dividend_model.dart';
import '../model/holding_model.dart';
import '../model/portfolio_model.dart';

/// MVP için bağımsız repository (in-memory)
/// - referans bütünlüğü var
/// - holding uniq: (portfolioId, companyId)
/// - ticker index var: (exchange, ticker)
/// - now() enjekte edilebilir
class DivfolioRepository {
  DivfolioRepository({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  // ----------------------------
  // Storage (in-memory)
  // ----------------------------
  final Map<String, Portfolio> _portfolios = <String, Portfolio>{};
  final Map<String, Company> _companies = <String, Company>{};

  /// key = currencyCode (upper)
  final Map<String, Currency> _currencies = <String, Currency>{};

  /// Holdings: key = "$portfolioId|$companyId"
  final Map<String, Holding> _holdingsByPair = <String, Holding>{};

  /// Dividends: key = dividend.id
  final Map<String, Dividend> _dividends = <String, Dividend>{};

  /// Secondary index: key = "EXCHANGE|TICKER" (upper) -> companyId
  final Map<String, String> _companyIdByTickerKey = <String, String>{};

  // ----------------------------
  // Portfolio
  // ----------------------------
  UnmodifiableListView<Portfolio> getPortfolios() =>
      UnmodifiableListView(_portfolios.values.toList());

  Portfolio? getPortfolioById(String id) => _portfolios[id];

  void upsertPortfolio(Portfolio portfolio) {
    _portfolios[portfolio.id] = portfolio;
  }

  void deletePortfolio(String portfolioId) {
    _ensurePortfolioExists(portfolioId);

    _portfolios.remove(portfolioId);

    // cascade delete holdings + dividends
    _holdingsByPair.removeWhere((_, h) => h.portfolioId == portfolioId);
    _dividends.removeWhere((_, d) => d.portfolioId == portfolioId);
  }

  // ----------------------------
  // Company
  // ----------------------------
  UnmodifiableListView<Company> getCompanies() =>
      UnmodifiableListView(_companies.values.toList());

  Company? getCompanyById(String id) => _companies[id];

  Company? getCompanyByTicker({
    required String exchange,
    required String ticker,
  }) {
    final key = _tickerKey(exchange: exchange, ticker: ticker);
    final companyId = _companyIdByTickerKey[key];
    return companyId == null ? null : _companies[companyId];
  }

  void upsertCompany(Company company) {
    // Eski ticker index temizliği
    final old = _companies[company.id];
    if (old != null) {
      final oldKey = _tickerKey(exchange: old.exchange, ticker: old.ticker);
      _companyIdByTickerKey.remove(oldKey);
    }

    _companies[company.id] = company;

    final newKey = _tickerKey(
      exchange: company.exchange,
      ticker: company.ticker,
    );
    _companyIdByTickerKey[newKey] = company.id;
  }

  void deleteCompany(String companyId) {
    _ensureCompanyExists(companyId);

    // ticker index temizle
    final company = _companies[companyId]!;
    final key = _tickerKey(exchange: company.exchange, ticker: company.ticker);
    _companyIdByTickerKey.remove(key);

    _companies.remove(companyId);

    // cascade
    _holdingsByPair.removeWhere((_, h) => h.companyId == companyId);
    _dividends.removeWhere((_, d) => d.companyId == companyId);
  }

  // ----------------------------
  // Currency
  // ----------------------------
  UnmodifiableListView<Currency> getCurrencies() =>
      UnmodifiableListView(_currencies.values.toList());

  Currency? getCurrency(String code) => _currencies[code.trim().toUpperCase()];

  void upsertCurrency(Currency currency) {
    final code = currency.code.trim().toUpperCase();
    if (code.isEmpty) {
      throw ArgumentError('currency.code cannot be empty');
    }
    _currencies[code] = currency;
  }

  /// MVP: currency silme opsiyonel ama sağlam olması için "kullanımda mı" kontrolü var.
  void deleteCurrency(String code) {
    final c = code.trim().toUpperCase();
    if (!_currencies.containsKey(c)) return;

    final usedInHoldings = _holdingsByPair.values.any((h) {
      final cc = h.currencyCode?.trim().toUpperCase();
      return cc == c;
    });

    final usedInDividends = _dividends.values.any((d) {
      final cc = d.currencyCode?.trim().toUpperCase();
      return cc == c;
    });

    if (usedInHoldings || usedInDividends) {
      throw StateError(
        'Cannot delete currency $c: it is used by holdings/dividends.',
      );
    }

    _currencies.remove(c);
  }

  // ----------------------------
  // Holding (current state)
  // ----------------------------
  UnmodifiableListView<Holding> getHoldings(String portfolioId) {
    _ensurePortfolioExists(portfolioId);
    final list = _holdingsByPair.values
        .where((h) => h.portfolioId == portfolioId)
        .toList();
    return UnmodifiableListView(list);
  }

  Holding? getHolding({
    required String portfolioId,
    required String companyId,
  }) {
    final key = _holdingKey(portfolioId: portfolioId, companyId: companyId);
    return _holdingsByPair[key];
  }

  /// Hisse lotunu set eder.
  /// - shares < 0 => error
  /// - shares == 0 => holding siler (daha temiz)
  /// - referans kontrolü yapar
  Holding? setHoldingShares({
    required String portfolioId,
    required String companyId,
    required double shares,
    double? avgCost,
    String? currencyCode,
  }) {
    _ensurePortfolioExists(portfolioId);
    _ensureCompanyExists(companyId);

    if (shares.isNaN || shares.isInfinite) {
      throw ArgumentError('shares must be a finite number');
    }
    if (shares < 0) {
      throw ArgumentError('shares cannot be negative');
    }

    final cleanCurrency = _normalizeCurrencyOrNull(currencyCode);
    if (cleanCurrency != null) _ensureCurrencyExists(cleanCurrency);

    final key = _holdingKey(portfolioId: portfolioId, companyId: companyId);

    // shares == 0 => delete
    if (shares == 0) {
      _holdingsByPair.remove(key);
      return null;
    }

    final now = _now();
    final existing = _holdingsByPair[key];

    final updated = (existing == null)
        ? Holding(
            id: _makeId('hold'),
            portfolioId: portfolioId,
            companyId: companyId,
            shares: shares,
            avgCost: avgCost,
            currencyCode: cleanCurrency,
            createdAt: now,
            updatedAt: null,
          )
        : existing.copyWith(
            shares: shares,
            avgCost: avgCost ?? existing.avgCost,
            currencyCode: cleanCurrency ?? existing.currencyCode,
            updatedAt: now,
          );

    _holdingsByPair[key] = updated;
    return updated;
  }

  void deleteHolding({required String portfolioId, required String companyId}) {
    final key = _holdingKey(portfolioId: portfolioId, companyId: companyId);
    _holdingsByPair.remove(key);
  }

  // ----------------------------
  // Dividend (historical events)
  // ----------------------------
  UnmodifiableListView<Dividend> getDividends(String portfolioId) {
    _ensurePortfolioExists(portfolioId);

    final list =
        _dividends.values.where((d) => d.portfolioId == portfolioId).toList()
          ..sort((a, b) => b.payDate.compareTo(a.payDate));

    return UnmodifiableListView(list);
  }

  UnmodifiableListView<Dividend> getDividendsByCompany({
    required String portfolioId,
    required String companyId,
  }) {
    _ensurePortfolioExists(portfolioId);
    _ensureCompanyExists(companyId);

    final list =
        _dividends.values
            .where(
              (d) => d.portfolioId == portfolioId && d.companyId == companyId,
            )
            .toList()
          ..sort((a, b) => b.payDate.compareTo(a.payDate));

    return UnmodifiableListView(list);
  }

  void upsertDividend(Dividend dividend) {
    _ensurePortfolioExists(dividend.portfolioId);
    _ensureCompanyExists(dividend.companyId);

    final cleanCurrency = _normalizeCurrencyOrNull(dividend.currencyCode);
    if (cleanCurrency != null) _ensureCurrencyExists(cleanCurrency);

    _dividends[dividend.id] = dividend;
  }

  void deleteDividend(String dividendId) {
    _dividends.remove(dividendId);
  }

  // ----------------------------
  // Aggregations (MVP)
  // ----------------------------

  /// Net temettü toplamı: currency bazlı döner.
  /// year null => all time
  Map<String, double> getTotalNetDividendsByCurrency({
    required String portfolioId,
    int? year,
  }) {
    final list = getDividends(portfolioId);
    final map = <String, double>{};

    for (final d in list) {
      if (year != null && d.payDate.year != year) continue;

      final cc = _normalizeCurrencyOrNull(d.currencyCode) ?? 'UNKNOWN';
      map[cc] = (map[cc] ?? 0) + d.netAmount;
    }

    return _sortedByValueDesc(map);
  }

  /// companyId -> (currencyCode -> netTotal)
  Map<String, Map<String, double>> getNetDividendsByCompanyByCurrency({
    required String portfolioId,
    int? year,
  }) {
    final list = getDividends(portfolioId);
    final result = <String, Map<String, double>>{};

    for (final d in list) {
      if (year != null && d.payDate.year != year) continue;

      final companyMap = result.putIfAbsent(
        d.companyId,
        () => <String, double>{},
      );
      final cc = _normalizeCurrencyOrNull(d.currencyCode) ?? 'UNKNOWN';
      companyMap[cc] = (companyMap[cc] ?? 0) + d.netAmount;
    }

    // şirketleri, toplam net (tüm currency’ler) büyükten küçüğe sırala
    final keys = result.keys.toList()
      ..sort((a, b) {
        final ta = result[a]!.values.fold<double>(0, (p, e) => p + e);
        final tb = result[b]!.values.fold<double>(0, (p, e) => p + e);
        return tb.compareTo(ta);
      });

    final sorted = LinkedHashMap<String, Map<String, double>>();
    for (final k in keys) {
      sorted[k] = _sortedByValueDesc(result[k]!);
    }
    return sorted;
  }

  // ----------------------------
  // Guards
  // ----------------------------
  void _ensurePortfolioExists(String portfolioId) {
    if (!_portfolios.containsKey(portfolioId)) {
      throw StateError('Portfolio not found: $portfolioId');
    }
  }

  void _ensureCompanyExists(String companyId) {
    if (!_companies.containsKey(companyId)) {
      throw StateError('Company not found: $companyId');
    }
  }

  void _ensureCurrencyExists(String currencyCodeUpper) {
    final cc = currencyCodeUpper.trim().toUpperCase();
    if (!_currencies.containsKey(cc)) {
      throw StateError('Currency not found: $cc');
    }
  }

  // ----------------------------
  // Utils
  // ----------------------------
  String _makeId(String prefix) => '$prefix-${_now().microsecondsSinceEpoch}';

  String _holdingKey({
    required String portfolioId,
    required String companyId,
  }) => '$portfolioId|$companyId';

  String _tickerKey({required String exchange, required String ticker}) =>
      '${exchange.trim().toUpperCase()}|${ticker.trim().toUpperCase()}';

  String? _normalizeCurrencyOrNull(String? code) {
    final c = code?.trim();
    if (c == null || c.isEmpty) return null;
    return c.toUpperCase();
  }

  Map<String, double> _sortedByValueDesc(Map<String, double> input) {
    final keys = input.keys.toList()
      ..sort((a, b) => (input[b] ?? 0).compareTo(input[a] ?? 0));

    return LinkedHashMap.fromEntries(keys.map((k) => MapEntry(k, input[k]!)));
  }
}
