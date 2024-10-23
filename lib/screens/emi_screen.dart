import 'dart:math';

import 'package:flutter/material.dart';

class EmiScreen extends StatefulWidget {
  const EmiScreen({super.key});

  @override
  State<EmiScreen> createState() => _EmiScreenState();
}

class _EmiScreenState extends State<EmiScreen> {

  String monthlyEmi = '0.0';
  String totalInterestPaid = '0.0';
  String totalAmountPaid = '0.0';

  TextEditingController loanAmountController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  TextEditingController loanTenureController = TextEditingController();

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
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(dynamicPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: dynamicSpacing),
            Text(
              'EMI Calculator',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: dynamicSpacing * 1.5),
            TextField(
              keyboardType: TextInputType.number,
              controller: loanAmountController,
              decoration: InputDecoration(
                labelText: 'Loan Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.attach_money),
              ),
            ),
            SizedBox(height: dynamicSpacing),
            TextField(
              keyboardType: TextInputType.number,
              controller: interestRateController,
              decoration: InputDecoration(
                labelText: 'Interest Rate (%)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.percent),
              ),
            ),
            SizedBox(height: dynamicSpacing),
            TextField(
              keyboardType: TextInputType.number,
              controller: loanTenureController,
              decoration: InputDecoration(
                labelText: 'Loan Tenure (Years)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: dynamicSpacing * 1.5),
            ElevatedButton(
              onPressed: () {
                calculateEmi();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              ),
              child: Text(
                'Calculate EMI',
                style: TextStyle(fontSize: dynamicFontSize * 0.8),
              ),
            ),
            SizedBox(height: dynamicSpacing * 1.5),
            Center(
              child: Column(
                children: [
                  const Divider(),
                  SizedBox(height: dynamicSpacing * 1.5),
                  Card(
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
                            'Details',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: dynamicFontSize,
                            ),
                          ),
                          SizedBox(height: dynamicSpacing),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Monthly EMI:'),
                              Text(monthlyEmi),
                            ],
                          ),
                          SizedBox(height: dynamicSpacing * 0.5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Interest Paid:'),
                              Text(totalInterestPaid),
                            ],
                          ),
                          SizedBox(height: dynamicSpacing * 0.5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount Paid:'),
                              Text(totalAmountPaid),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calculateEmi() {
    double loanAmount = double.parse(loanAmountController.text);
    double interestRate = double.parse(interestRateController.text);
    double loanTenure = double.parse(loanTenureController.text);

    double monthlyInterestRate = interestRate / 12 / 100;
    double numberOfMonths = loanTenure * 12;

    double monthlyEmi = (loanAmount * monthlyInterestRate *
      (pow(1 + monthlyInterestRate, numberOfMonths))) /
      (pow(1 + monthlyInterestRate, numberOfMonths) - 1);
    double totalAmountPaid = monthlyEmi * numberOfMonths;
    double totalInterestPaid = totalAmountPaid - loanAmount;

    setState(() {
      this.monthlyEmi = monthlyEmi.toStringAsFixed(2);
      this.totalInterestPaid = totalInterestPaid.toStringAsFixed(2);
      this.totalAmountPaid = totalAmountPaid.toStringAsFixed(2);
    });
  }
}
