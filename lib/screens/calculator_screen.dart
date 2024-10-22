import 'package:calculator/provider/history_database.dart';
import 'package:calculator/screens/extras_screen.dart';
import 'package:calculator/screens/history_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'package:material_symbols_icons/symbols.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = "";
  String _output = "";
  bool _result = false;
  bool _fx = false;
  String? _button;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.04;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            final history = await HistoryDatabase.instance.getHistory();
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => HistoryScreen(history: history),
              ),
            );
          },
          icon: const Icon(Symbols.history),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _fx = !_fx;
              });
            },
            icon: const Icon(Symbols.function),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const ExtrasScreen(),
                ),
              );
            },
            icon: const Icon(Symbols.more_vert),
          )
        ],
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: _fx ? 3 : 4,
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                setState(
                  () {
                    if (_input.isNotEmpty) {
                      _input = _input.substring(0, _input.length - 1);
                      _calculateLiveResult();
                    }
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(padding),
                alignment: Alignment.bottomRight,
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _fx
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            child: Text(
                              _input,
                              softWrap: !_fx,
                              style: TextStyle(
                                fontSize: size.width * 0.07,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.75),
                              ),
                            ),
                          )
                        : Text(
                            _input,
                            softWrap: !_fx,
                            style: TextStyle(
                              fontSize: size.width * 0.07,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.75),
                            ),
                          ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: size.width,
                        alignment: Alignment.bottomRight,
                        child: Text(
                          _output,
                          style: TextStyle(
                            fontSize: _result && !_fx
                                ? size.width * 0.14
                                : size.width * 0.07,
                            fontWeight: FontWeight.bold,
                            color: _result
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: _fx ? 16 : 8,
            child: GestureDetector(
              onPanUpdate: (details) {
                if (details.delta.dy < -10) {
                  setState(() {
                    _fx = true;
                  });
                } else if (details.delta.dy > 10) {
                  setState(() {
                    _fx = false;
                  });
                }
              },
              onPanEnd: (details) {
                if (details.velocity.pixelsPerSecond.dy < -500) {
                  setState(() {
                    _fx = true;
                  });
                } else if (details.velocity.pixelsPerSecond.dy > 500) {
                  setState(() {
                    _fx = false;
                  });
                }
              },
              child: BottomSheet(
                onClosing: () {},
                showDragHandle: true,
                builder: (context) {
                  return Column(
                    children: [
                      if (_fx) _buildAdditionalFunctionGrid(),
                      _buildStandardFunctionGrid(),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardFunctionGrid() {
    final buttonLabels = [
      ["AC", "clear", "%", "÷"],
      ["7", "8", "9", "×"],
      ["4", "5", "6", "-"],
      ["1", "2", "3", "+"],
      ["0", ".", "( )", "="]
    ];

    return Flexible(
      flex: 8,
      child: Column(
        children: buttonLabels.map((row) {
          return Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((label) => _buildButton(label)).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAdditionalFunctionGrid() {
    final additionalButtonLabels = [
      ["sin", "cos", "tan", "log"],
      ["ln", "√", "^", "!"]
    ];

    return Flexible(
      flex: 3,
      child: Column(
        children: additionalButtonLabels.map((row) {
          return Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((label) => _buildButton(label)).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButton(String label) {
    final size = MediaQuery.of(context).size;
    final buttonSize = size.width * 0.2;
    final buttonFontSize = size.width * 0.056;
    final buttonList = ["AC", "clear", "%", "÷", "×", "-", "+", "="];

    Color buttonColor(String label) => (buttonList.contains(label)
        ? Theme.of(context).colorScheme.tertiaryContainer
        : Theme.of(context).colorScheme.secondaryContainer);

    Color onButtonColor(String label) => (buttonList.contains(label)
        ? Theme.of(context).colorScheme.onTertiaryContainer
        : Theme.of(context).colorScheme.onSecondaryContainer);

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
                  BorderRadius.circular(_button == label ? 16.0 : 50.0),
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
    setState(
      () {
        _button = label;
        _result = false;

        if (label == 'AC') {
          _input = "";
          _output = "";
        } else if (label == '=') {
          _result = true;
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
          } else if (["sin", "cos", "tan", "log", "ln", "√"].contains(label)) {
            _input += "$label(";
          } else {
            _input += label;
          }
          _calculateLiveResult();
        }
      },
    );

    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        setState(
          () {
            _button = null;
          },
        );
      },
    );
  }

  void _calculateLiveResult() {
    if (_input.isNotEmpty) {
      String expression = _input
          .replaceAll("×", "*")
          .replaceAll("÷", "/")
          .replaceAll("√", "sqrt");
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

  String _getFormattedDate() {
    final now = DateTime.now();
    return "${now.day} ${getMonthName(now.month)}, ${now.year}";
  }

  String getMonthName(int monthNumber) {
    const List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    if (monthNumber < 1 || monthNumber > 12) {
      throw ArgumentError('Month number must be between 1 and 12.');
    }

    return monthNames[monthNumber - 1];
  }

  void _calculateResult() {
    if (_input.isNotEmpty) {
      String expression = _input
          .replaceAll("×", "*")
          .replaceAll("÷", "/")
          .replaceAll("√", "sqrt");
      try {
        final result = expression.interpret().toString();
        setState(() {
          _output = _formatOutput(result);
          String dateKey = _getFormattedDate();
          Map<String, String> historyItem = {
            'date': dateKey,
            'input': _input,
            'output': _output,
          };
          HistoryDatabase.instance.insertHistory(historyItem);
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
      if ((numOutput.abs() > 1000000 || numOutput.abs() < 0.000001) &&
          numOutput != 0) {
        return numOutput.toStringAsExponential(2);
      } else {
        if (numOutput == numOutput.toInt()) {
          return numOutput.toInt().toString();
        } else {
          return double.parse(numOutput.toStringAsFixed(6)).toString();
        }
      }
    }

    return output;
  }

  Widget _buildButtonContent(
      String label, double fontSize, Color operatorColor) {
    switch (label) {
      case '+':
        return Icon(Icons.add, size: fontSize, color: operatorColor);
      case '-':
        return Icon(Icons.remove, size: fontSize, color: operatorColor);
      case '×':
        return Icon(Icons.close, size: fontSize, color: operatorColor);
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
        return Icon(Icons.percent, size: fontSize, color: operatorColor);
      case 'clear':
        return Icon(Icons.backspace_outlined,
            size: fontSize, color: operatorColor);
      case '=':
        return Icon(Icons.drag_handle_outlined,
            size: fontSize, color: operatorColor);
      default:
        return Text(
          label,
          style: TextStyle(
            fontSize: label == "AC" ? fontSize * 0.8 : fontSize,
            color: operatorColor,
          ),
        );
    }
  }
}
