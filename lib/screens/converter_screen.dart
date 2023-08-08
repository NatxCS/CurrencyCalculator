import 'package:flutter/material.dart';
import '../service/currency_exchange_repository.dart';
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
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(1.5),
            color: Colors.grey[400],
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of columns
                childAspectRatio: 1.5,
                crossAxisSpacing: 2.5,
                mainAxisSpacing: 2.5,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: buttons.length,
              itemBuilder: (BuildContext context, int index) {
                if (buttons[index] == 'back') {
                  return customButton('back',
                      onPressed: () => onCustomButtonPressed('back'));
                } else if (buttons[index] == 'C') {
                  return customButton('C',
                      onPressed: () => onCustomButtonPressed('C'));
                } else if (buttons[index] == '') {
                  return const SizedBox();
                } else {
                  return customButton(buttons[index],
                      onPressed: () => onCustomButtonPressed(buttons[index]));
                }
              },
            ),
          )
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

  Widget customButton(String text, {VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.green.withOpacity(0.2);
          }
          return Colors.transparent;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: text == 'back'
          ? const Icon(Icons.arrow_back, color: Colors.black)
          : Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
    );
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

class CardOption extends StatelessWidget {
  const CardOption(
      {super.key,
      required this.value,
      required this.currency,
      required this.onButtonPressed,
      required this.onCardPressed});

  final String value;
  final String currency;
  final VoidCallback onButtonPressed;
  final VoidCallback onCardPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onCardPressed,
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: const TextStyle(fontSize: 25),
                  ),
                  TextButton(
                    onPressed: onButtonPressed,
                    child: Row(
                      children: [
                        Text(
                          currency,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
