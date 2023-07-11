import 'package:flutter/material.dart';

class Calculator extends StatelessWidget {
  const Calculator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Text(
          'Screen 2',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}