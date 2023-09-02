import 'package:flutter/material.dart';

class CalculatorKeys extends StatelessWidget {
  CalculatorKeys({super.key, required this.amount, required this.convertedAmount, required this.amountString, required this.commaPressed,required this.onButtonPressed});

  late final double amount;
  late final double convertedAmount;
  late final String amountString;
  late final bool commaPressed;
  final Function(String) onButtonPressed;

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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(1.5),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        color: Colors.grey[400],
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Number of columns
            childAspectRatio: 1.10,
            crossAxisSpacing: 2.5,
            mainAxisSpacing: 3.5,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: buttons.length,
          itemBuilder: (BuildContext context, int index) {
            if (buttons[index] == 'back') {
              return customButton('back',
                  onPressed: () => onButtonPressed('back'));
            } else if (buttons[index] == 'C') {
              return customButton('C',
                  onPressed: () => onButtonPressed('C'));
            } else if (buttons[index] == '') {
              return const SizedBox();
            } else {
              return customButton(buttons[index],
                  onPressed: () => onButtonPressed(buttons[index]));
            }
          },
        ),
      ),
    );
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
}