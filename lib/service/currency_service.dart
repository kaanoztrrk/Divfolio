// lib/core/services/currency_service.dart

import '../core/init/currency_init.dart';
import '../data/model/currency_model.dart';
import '../data/repository/portfolio_repository.dart';
// lib/core/services/currency_service.dart

class CurrencyService {
  final PortfolioRepository _portfolioRepository;

  CurrencyService(this._portfolioRepository);

  Future<CurrencyModel> getCurrencyForPortfolio(String portfolioId) async {
    final portfolio = await _portfolioRepository.getPortfolio(portfolioId);

    if (portfolio == null) return CurrencyDefaults.list.first; // fallback: USD

    return CurrencyDefaults.list.firstWhere(
      (c) => c.code == portfolio.baseCurrencyCode,
      orElse: () => CurrencyDefaults.list.first,
    );
  }
}
