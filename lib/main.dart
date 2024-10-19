import 'package:calculator/screens/calculator_screen.dart';
import 'package:flutter/material.dart';
void main() => runApp(const Calculator());

class Calculator extends StatelessWidget {
  const Calculator({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Calculator",
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}
