class Currency {
  final String code;
  final String name;
  Currency({required this.code, required this.name});
}

class CurrenciesList {
  final List<Currency> currencyList;

  CurrenciesList({
    required this.currencyList,
  });

  factory CurrenciesList.fromJson(Map<String, dynamic> json) {
    List<Currency> currencies = [];
    json['supported_codes'].forEach((code) {
      currencies.add(Currency(code: code, name: code));
    });
    return CurrenciesList(
      currencyList: currencies,
    );
  }
}


class CurrencyExchange {
  final double newAmount;
  final String oldCurrency;
  final String newCurrency;

  CurrencyExchange({
    required this.newAmount,
    required this.oldCurrency,
    required this.newCurrency,
  });

  factory CurrencyExchange.fromJson(Map<String, dynamic> json) {
    return CurrencyExchange(
      newAmount: json["conversion_result"],
      newCurrency: json["target_code"],
      oldCurrency: json["base_code"],
    );
  }
}