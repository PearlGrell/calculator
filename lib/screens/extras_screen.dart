import 'package:calculator/screens/bmi_screen.dart';
import 'package:calculator/screens/emi_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExtrasScreen extends StatelessWidget {
  const ExtrasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.04;

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
        centerTitle: true,
        title: const Text("Extras"),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: padding,
          mainAxisSpacing: padding,
          children: [
            _buildGridItem(
              Icons.monetization_on,
              'EMI',
              context,
              const EmiScreen(),
            ),
            _buildGridItem(
              Icons.fitness_center,
              'BMI',
              context,
              const BmiScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
      IconData icon, String title, BuildContext context, Widget page) {
    final size = MediaQuery.of(context).size;
    final cardSize = size.width * 0.4;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => page,
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: cardSize,
          height: cardSize,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: size.width * 0.1,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: size.width * 0.036,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
