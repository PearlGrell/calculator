import 'package:flutter/material.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  String bmiResult = '0.0';
  String resultText = '';
  String totalStatus = '';
  bool showResult = false;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  Color resultColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;
    double screenWidth = mediaQuery.size.width;
    double dynamicPadding = screenHeight * 0.02;
    double dynamicSpacing = screenHeight * 0.03;
    double dynamicFontSize = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(dynamicPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: dynamicSpacing),
            Text(
              'BMI Calculator',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: dynamicSpacing * 1.5),
            TextField(
              keyboardType: TextInputType.number,
              controller: heightController,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.height),
              ),
            ),
            SizedBox(height: dynamicSpacing),
            TextField(
              keyboardType: TextInputType.number,
              controller: weightController,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.line_weight),
              ),
            ),
            SizedBox(height: dynamicSpacing * 1.5),
            ElevatedButton(
              onPressed: () {
                calculateBmi();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              ),
              child: Text(
                'Calculate BMI',
                style: TextStyle(fontSize: dynamicFontSize * 0.8),
              ),
            ),
            SizedBox(height: dynamicSpacing * 1.5),
            if(showResult)
              const Divider(),
            SizedBox(height: dynamicSpacing * 1.5),
            AnimatedOpacity(
              opacity: showResult ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(dynamicPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Your BMI is $bmiResult',
                        style: TextStyle(
                          fontSize: dynamicFontSize * 1.2,
                          fontWeight: FontWeight.bold,
                          color: resultColor,
                        ),
                      ),
                      SizedBox(height: dynamicSpacing),
                      Text(
                        resultText,
                        style: TextStyle(
                          fontSize: dynamicFontSize * 0.9,
                          color: resultColor,
                        ),
                      ),
                      SizedBox(height: dynamicSpacing),
                      Text(
                        totalStatus,
                        style: TextStyle(
                          fontSize: dynamicFontSize * 0.8,
                          color: resultColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calculateBmi() {
    double height = double.parse(heightController.text) / 100;
    double weight = double.parse(weightController.text);
    double bmi = weight / (height * height);
    setState(() {
      bmiResult = bmi.toStringAsFixed(1);
      showResult = true;

      if (bmi < 16) {
        resultText = 'Severely Underweight';
        resultColor = Colors.red;
        totalStatus = 'Seek medical advice.';
      } else if (bmi < 17) {
        resultText = 'Underweight';
        resultColor = Colors.orange;
        totalStatus = 'Consider gaining weight.';
      } else if (bmi < 18.5) {
        resultText = 'Mildly Underweight';
        resultColor = Colors.orange;
        totalStatus = 'You should consider a balanced diet.';
      } else if (bmi < 24.9) {
        resultText = 'Normal Weight';
        resultColor = Colors.green;
        totalStatus = 'Keep up the good work!';
      } else if (bmi < 29.9) {
        resultText = 'Overweight';
        resultColor = Colors.yellow;
        totalStatus = 'Consider losing some weight.';
      } else if (bmi < 34.9) {
        resultText = 'Obesity Class 1';
        resultColor = Colors.orange;
        totalStatus = 'Seek advice on losing weight.';
      } else if (bmi < 39.9) {
        resultText = 'Obesity Class 2';
        resultColor = Colors.red;
        totalStatus = 'Seek medical advice.';
      } else {
        resultText = 'Obesity Class 3';
        resultColor = Colors.redAccent;
        totalStatus = 'Seek medical advice immediately.';
      }
    });
  }
}
