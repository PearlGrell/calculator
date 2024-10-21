import 'package:calculator/screens/calculator_screen.dart';
import 'package:calculator/themes/text_themes.dart';
import 'package:calculator/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const Calculator());

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  @override
  void initState() {
    _setPreferredOrientations();
    super.initState();
  }

  void _setPreferredOrientations() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, 'Poppins', 'ABeeZee');
    return MaterialApp(
      title: "Calculator",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: MaterialTheme.lightScheme(), textTheme: textTheme),
      darkTheme: ThemeData(
          colorScheme: MaterialTheme.darkScheme(), textTheme: textTheme),
      home: const CalculatorScreen(),
    );
  }
}
