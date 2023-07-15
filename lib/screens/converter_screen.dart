import 'package:flutter/material.dart';
import 'currency_list.dart';
import 'package:currency_calculator/widgets/grid_buttons.dart';

class Converter extends StatefulWidget {
  const Converter({super.key});

  @override
  ConverterState createState() => ConverterState();
}

class ConverterState extends State<Converter> {
  var value = 0;
  String currency1 = '';
  String currency2 = '';


  final List<String> buttons = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    ',',
    '0',
    'back',
  ];

  void navigateToNewScreen(BuildContext context, bool topCurrency ) {
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
          if(topCurrency == true){
            currency1 = value;
          }else{
            currency2  = value;
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
            color: Colors.red,
            value: value,
            currency: currency1,
            onPressed: () => navigateToNewScreen(context, true)
          ),
          CardOption(
            color: Colors.blue,
            value: value,
            currency: currency2,
              onPressed: () => navigateToNewScreen(context, false),
          ),
          GridButtons(buttons: buttons),
        ],
      ),
    );
  }
}



class CardOption extends StatelessWidget {
  const CardOption(
      {super.key,
      required this.color,
      required this.value,
      required this.currency,
      required this.onPressed});

  final Color color;
  final int value;
  final String currency;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$value",
                  style: const TextStyle(fontSize: 25),
                ),
                TextButton(
                  onPressed: onPressed,
                  child: Row(
                    children: [
                      Text(
                        currency,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
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
    );
  }
}
