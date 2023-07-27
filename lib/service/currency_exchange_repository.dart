import 'package:dio/dio.dart';
import '../model/currency_model.dart';

class CurrencyRepository {
  final Dio _dio = Dio();
  Map<String, double>? _conversionRates;
  DateTime? _lastFetchedTime;
  static const apiKey = '879dda52c6b84fa60e989ca5';

  Future<CurrencyExchange> fetchCurrencyExchange({
    required String oldCurrency,
    required String newCurrency,
    required double amount,
  }) async {
    try {
      var path = 'https://v6.exchangerate-api.com/v6/$apiKey/pair/$oldCurrency/$newCurrency/$amount';

      final response = await _dio.get(path);

      final data = response.data;
      return CurrencyExchange.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch currency exchange: $e');
    }
  }

  Future<List<Currency>> fetchCurrenciesList() async {
    try {
      const currenciesURL = 'https://v6.exchangerate-api.com/v6/$apiKey/codes';

      final response = await _dio.get(currenciesURL);

      final data = response.data;
      List<Currency> currencies = [];
      if (data.containsKey('supported_codes')) {
        List<dynamic> supportedCodes = data['supported_codes'];
        currencies = supportedCodes.map((codeList) {
          if (codeList is List && codeList.length >= 2) {
            return Currency(code: codeList[0], name: codeList[1]);
          } else {
            throw Exception('Invalid currency data');
          }
        }).toList();
      }
      return currencies;
    } catch (e) {
      throw Exception('Failed to fetch currencies list: $e');
    }
  }



  Future<Map<String, double>> _fetchConversionRates() async {
    try {
      final response = await _dio.get('https://v6.exchangerate-api.com/v6/$apiKey/latest/USD');

      final data = response.data;
      Map<String, dynamic> ratesData = data["conversion_rates"];
      Map<String, double> conversionRates = Map<String, double>.from(ratesData.map(
            (key, value) => MapEntry(key, value.toDouble()),
      ));
      _lastFetchedTime = DateTime.now();
      return conversionRates;
    } catch (e) {
      throw Exception('Failed to fetch conversion rates: $e');
    }
  }

  Future<Map<String, double>> getConversionRates() async {
    // Check if conversion rates are available and not outdated (valid for an hour in this example)
    if (_conversionRates != null && _lastFetchedTime != null) {
      final currentTime = DateTime.now();
      final difference = currentTime.difference(_lastFetchedTime!);
      const updateInterval = Duration(hours: 1);

      if (difference < updateInterval) {
        // Rates are still valid; return cached rates
        return _conversionRates!;
      }
    }

    // Rates are outdated or not available; fetch the latest rates
    _conversionRates = await _fetchConversionRates();
    _lastFetchedTime = DateTime.now();

    return _conversionRates!;
  }
}
