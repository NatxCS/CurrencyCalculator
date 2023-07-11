import 'package:flutter/material.dart';

import 'currency_list.dart';

class Converter extends StatefulWidget {
  final String chooseCurrency;

  const Converter({Key? key, required this.chooseCurrency}) : super(key: key);

  @override
  ConverterState createState() => ConverterState();
}

class ConverterState extends State<Converter> {
  var value = 0;
  var currency1 = "USD";
  var currency2 = "COP";

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

  void navigateToNewScreen(BuildContext context) {
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
    );
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
            onPressed: () => navigateToNewScreen(context),
          ),
          CardOption(
            color: Colors.blue,
            value: value,
            currency: currency2,
            onPressed: () {
              setState(() {
                if (currency2 == "USD") {
                  currency2 = "COP";
                } else if (currency2 == "COP") {
                  currency2 = "USD";
                }
              });
            },
          ),
          GridButtons(buttons: buttons),
        ],
      ),
    );
  }
}

class GridButtons extends StatelessWidget {
  const GridButtons({
    super.key,
    required this.buttons,
  });

  final List<String> buttons;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(1.5),
      color: Colors.grey[400],
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          childAspectRatio: 2.0,
          crossAxisSpacing: 2.5,
          mainAxisSpacing: 2.5,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: buttons.length,
        itemBuilder: (BuildContext context, int index) {
          if (buttons[index] == 'back') {
            return ElevatedButton(
              onPressed: () {},
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
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 35,
              ),
            );
          } else {
            return ElevatedButton(
              onPressed: () {},
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
              child: Text(
                buttons[index],
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            );
          }
        },
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
