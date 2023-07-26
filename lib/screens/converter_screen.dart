import 'package:flutter/material.dart';
import 'currency_list_screen.dart';

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
  String input2 = '';
  String currency1 = '';
  String currency2 = '';
  bool topCurrency = true;
  bool downCurrency = false;
  String currentInput = 'input1';

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

  changeFocus(bool value) {
    setState(() {
      if (value == true) {
        topCurrency = false;
        downCurrency = true;
        currentInput = 'input1';
      } else {
        topCurrency = true;
        downCurrency = false;
        currentInput = 'input2';
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
              chooseFocus: () {
                setState(() {
                  currentInput = 'input1';
                });
                changeFocus(true);
              },
              focus: topCurrency,
              value: input1,
              currency: currency1,
              onPressed: () => navigateToNewScreen(context, topCurrency)),
          CardOption(
            chooseFocus: () {
              setState(() {
                currentInput = 'input1';
              });
              changeFocus(false);
            },
            focus: downCurrency,
            value: input2,
            currency: currency2,
            onPressed: () => navigateToNewScreen(context, downCurrency),
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
                  return customButton('back');
                } else {
                  return customButton(buttons[index]);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget customButton(String text) {
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

  void getText(String text) {
    if (text == 'back') {
      setState(() {
        if (currentInput == 'input1') {
          input1 = input1.substring(0, input1.length - 1);
          if (input1.isEmpty) {
            input1 = '0';
          }
        } else {
          input2 = input2.substring(0, input2.length - 1);
          if (input2.isEmpty) {
            input2 = '0';
          }
        }
      });
      return;
    }

    if (currentInput == 'input1') {
      if (input1 == '0') {
        input1 = '';
      }
      setState(() {
        input1 = input1 + text;
      });
    } else {
      if (input2 == '0') {
        input2 = '';
      }
      setState(() {
        input2 = input2 + text;
      });
    }
  }
}

class CardOption extends StatefulWidget {
  const CardOption(
      {super.key,
      required this.value,
      required this.currency,
      required this.onPressed,
      required this.chooseFocus,
      required this.focus});

  final String value;
  final String currency;
  final VoidCallback onPressed;
  final VoidCallback chooseFocus;
  final bool focus;

  @override
  State<CardOption> createState() => _CardOptionState();
}

class _CardOptionState extends State<CardOption> {
  void toggleFocus() {
    widget.chooseFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: toggleFocus,
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
              color: widget.focus == false ? Colors.grey : Colors.grey[20],
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.value,
                    style: const TextStyle(fontSize: 25),
                  ),
                  TextButton(
                    onPressed: widget.onPressed,
                    child: Row(
                      children: [
                        Text(
                          widget.currency,
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
