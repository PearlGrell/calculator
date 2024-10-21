import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = "";
  String _output = "";
  bool _isEqualPressed = false;
  String? _activeButton;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.04;
    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: 5,
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                setState(() {
                  if (_input.isNotEmpty) {
                    _input = _input.substring(0, _input.length - 1);
                    _calculateLiveResult();
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.all(padding),
                alignment: Alignment.bottomRight,
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _input,
                      style: TextStyle(
                        fontSize: size.width * 0.07,
                        color: Colors.grey,
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Text(
                        _output,
                        style: TextStyle(
                          fontSize: _isEqualPressed ? size.width * 0.14 : size.width * 0.07,
                          fontWeight: FontWeight.bold,
                          color: _isEqualPressed
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 8,
            child: BottomSheet(
              onClosing: () {},
              showDragHandle: true,
              builder: (context) => Column(
                children: _buildButtonGrid(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildButtonGrid() {
    final buttonLabels = [
      ["AC", "clear", "%", "÷"],
      ["7", "8", "9", "×"],
      ["4", "5", "6", "-"],
      ["1", "2", "3", "+"],
      ["0", ".", "( )", "="]
    ];

    return buttonLabels.map((row) {
      return Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((label) => _buildButton(label)).toList(),
        ),
      );
    }).toList();
  }

  Widget _buildButton(String label) {
    final size = MediaQuery.of(context).size;
    final buttonSize = size.width * 0.2;
    final buttonFontSize = size.width * 0.056;

    Color buttonColor(String label) => ([
          "0",
          "1",
          "2",
          "3",
          "4",
          "5",
          "6",
          "7",
          "8",
          "9",
          ".",
          "( )"
        ].contains(label)
            ? Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.tertiaryContainer);

    Color onButtonColor(String label) => ([
          "0",
          "1",
          "2",
          "3",
          "4",
          "5",
          "6",
          "7",
          "8",
          "9",
          ".",
          "( )"
        ].contains(label)
            ? Theme.of(context).colorScheme.onSecondaryContainer
            : Theme.of(context).colorScheme.onTertiaryContainer);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.016),
        child: GestureDetector(
          onTap: () => _handleButtonPress(label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: buttonColor(label),
              borderRadius:
                  BorderRadius.circular(_activeButton == label ? 16.0 : 50.0),
            ),
            child: Center(
              child: _buildButtonContent(
                  label, buttonFontSize, onButtonColor(label)),
            ),
          ),
        ),
      ),
    );
  }

  void _handleButtonPress(String label) {
    setState(() {
      _activeButton = label;
      _isEqualPressed = false;

      if (label == 'AC') {
        _input = "";
        _output = "";
      } else if (label == '=') {
        _isEqualPressed = true;
        _calculateResult();
      } else if (label == 'clear') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
          _calculateLiveResult();
        }
      } else {
        if (label == "( )") {
          int openBrackets = '('.allMatches(_input).length;
          int closeBrackets = ')'.allMatches(_input).length;

          if (_input.isEmpty || RegExp(r'[÷×\-+()]$').hasMatch(_input)) {
            _input += "(";
          } else if (openBrackets > closeBrackets) {
            _input += ")";
          } else {
            _input += "(";
          }
        } else {
          _input += label;
        }
        _calculateLiveResult();
      }
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _activeButton = null;
      });
    });
  }

  void _calculateLiveResult() {
    if (_input.isNotEmpty) {
      String expression = _input.replaceAll("×", "*").replaceAll("÷", "/");
      try {
        final result = expression.interpret().toString();
        setState(() {
          _output = _formatOutput(result);
        });
      } catch (e) {
        setState(() {
          _output = "";
        });
      }
    }
  }

  void _calculateResult() {
    if (_input.isNotEmpty) {
      String expression = _input.replaceAll("×", "*").replaceAll("÷", "/");
      try {
        final result = expression.interpret().toString();
        setState(() {
          _output = _formatOutput(result);
        });
      } catch (e) {
        setState(() {
          _output = "Error";
        });
      }
    }
  }

  String _formatOutput(String output) {
    double? numOutput = double.tryParse(output);

    if (numOutput != null) {
      if (numOutput.abs() > 1000000 || numOutput.abs() < 0.000001) {
        return numOutput.toStringAsExponential(2);
      } else {
        if (numOutput == numOutput.toInt()) {
          return numOutput.toInt().toString();
        } else {
          return numOutput.toString();
        }
      }
    }

    return output;
  }

  Widget _buildButtonContent(
      String label, double fontSize, Color operatorColor) {
    switch (label) {
      case '+':
        return Icon(Icons.add, size: fontSize);
      case '-':
        return Icon(Icons.remove, size: fontSize);
      case '×':
        return Icon(Icons.close, size: fontSize);
      case '÷':
        return Text(
          "÷",
          style: TextStyle(
            fontSize: fontSize * 1.4,
            fontWeight: FontWeight.w300,
          ),
        );
      case 'AC':
        return Text(label,
            style: TextStyle(fontSize: fontSize * 0.8, color: operatorColor));
      case '%':
        return Icon(Icons.percent, size: fontSize);
      case 'clear':
        return Icon(Icons.backspace_outlined, size: fontSize);
      case '=':
        return Icon(Icons.drag_handle_outlined, size: fontSize);
      default:
        return Text(
          label,
          style: TextStyle(
              fontSize: label == "AC" ? fontSize * 0.8 : fontSize,
              color: operatorColor),
        );
    }
  }
}
