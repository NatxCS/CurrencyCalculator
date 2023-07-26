import 'package:dio/dio.dart';
import '../model/currency_model.dart';

class CurrencyRepository {
  final Dio _dio = Dio();
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
}
