import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 25),
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