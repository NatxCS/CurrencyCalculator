import 'package:currency_calculator/widgets/calculator_keyboard.dart';
import 'package:flutter/material.dart';
import '../service/currency_exchange_repository.dart';
import '../widgets/card_option.dart';
import 'currency_list_screen.dart';

final List<String> buttons = [
  '1',
  '2',
  '3',
  'back',
  '4',
  '5',
  '6',
  'C',
  '7',
  '8',
  '9',
  '',
  '00',
  '0',
  '.',
];

class Converter extends StatefulWidget {
  const Converter({super.key});

  @override
  ConverterState createState() => ConverterState();
}

class ConverterState extends State<Converter> {
  final CurrencyRepository _currencyConverterService = CurrencyRepository();
  double amount = 0.0;
  double convertedAmount = 0.0;
  String fromCurrency = 'USD';
  String toCurrency = 'COP';
  String amountString = '0';
  bool commaPressed = false;

  String formatNumberWithCommas(String input) {
    List<String> parts = input.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? ".${parts[1]}" : "";

    int length = integerPart.length;
    int commaCount = (length - 1) ~/ 3;

    String result = "";

    for (int i = 0; i < length; i++) {
      result += integerPart[i];
      if ((length - i - 1) % 3 == 0 && commaCount > 0) {
        result += ",";
        commaCount--;
      }
    }

    return result + decimalPart;
  }

  void navigateToNewScreen(BuildContext context, bool topCurrency) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const CurrencyList(),
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          if (topCurrency == true) {
            fromCurrency = value;
          } else {
            toCurrency = value;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CardOption(
            value: formatNumberWithCommas(amountString),
            currency: fromCurrency,
            onButtonPressed: () => navigateToNewScreen(context, true),
            onCardPressed: () => _selectCurrency('from'),
          ),
          CardOption(
            value: formatNumberWithCommas(convertedAmount.toString()),
            currency: toCurrency,
            onButtonPressed: () => navigateToNewScreen(context, false),
            onCardPressed: () => _selectCurrency('to'),
          ),
         CalculatorKeys(amount: amount, convertedAmount: convertedAmount, amountString: amountString, commaPressed: commaPressed, onButtonPressed: onCustomButtonPressed)
        ],
      ),
    );
  }

  void _selectCurrency(String type) {
    if (type == 'from') {
      setState(() {
        String temp = fromCurrency;
        fromCurrency = toCurrency;
        toCurrency = temp;
      });
    } else if (type == 'to') {
      setState(() {
        String temp = toCurrency;
        toCurrency = fromCurrency;
        fromCurrency = temp;
      });
    }
    _updateConversion();
  }

  void onCustomButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        amount = 0.0;
        commaPressed = false;
        convertedAmount = 0.0;
        amountString = '0';
      } else if (buttonText == 'back') {
        if (amountString.isNotEmpty) {
          if (amountString.endsWith('.')) {
            commaPressed = false;
          }
          amountString = amountString.substring(0, amountString.length - 1);
          if (amountString.isEmpty) {
            amountString = '0';
          }
        }
      } else if (buttonText == '.') {
        if (!commaPressed) {
          amountString += '.';
          commaPressed = true;
        }
      } else if (buttonText == '00') {
        if (amountString == '0') {
          amountString = '0';
        } else {
          amountString += buttonText;
        }
      } else {
        if (amountString == '0') {
          amountString = buttonText;
        } else {
          amountString += buttonText;
        }
      }

      amount = double.tryParse(amountString) ?? 0.0;
    });
    _updateConversion();
  }

  void _updateConversion() async {
    try {
      Map<String, double> conversionRates =
          await _currencyConverterService.getConversionRates();
      double rate =
          conversionRates[toCurrency]! / conversionRates[fromCurrency]!;
      setState(() {
        convertedAmount = amount * rate;
      });
    } catch (e) {
      print('Error: $e');
    }
  }
}


