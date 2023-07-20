import 'package:flutter/material.dart';
import 'currency_list.dart';

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

class Converter extends StatefulWidget {
  const Converter({super.key});

  @override
  ConverterState createState() => ConverterState();
}

class ConverterState extends State<Converter> {
  String input1 = '';
  String input2 = '0';
  String currency1 = '';
  String currency2 = '';

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
            currency1 = value;
          } else {
            currency2 = value;
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
              value: input1,
              currency: currency1,
              onPressed: () => navigateToNewScreen(context, true)),
          CardOption(
            color: Colors.blue,
            value: input2,
            currency: currency2,
            onPressed: () => navigateToNewScreen(context, false),
          ),
          Container(
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
                  return CustomButton('back');
                } else {
                  return CustomButton(buttons[index]);
                }
              },
            ),
          )
        ],
      ),
    );
  }
  Widget CustomButton(String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          getText(text);
        });
      },
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
          ? const Icon(Icons.arrow_back, color: Colors.black, size: 35)
          : Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
    );
  }

  getText(String text) {
    if (text == 'back') {
      input1 = input1.substring(0, input1.length - 1);
      if (input1.isEmpty) {
        input1 = '0';
      }
      return;
    }
    if(input1 == '0'){
      input1 = '';
    }
    input1 = input1 + text;
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
  final String value;
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
                  value,
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
