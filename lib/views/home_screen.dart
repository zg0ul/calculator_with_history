import 'package:calculator_with_history/constants/colors.dart';
import 'package:calculator_with_history/theme/theme_model.dart';
import 'package:calculator_with_history/widgets/calculator_buttons.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String equation = ''; // State for the equation
  String userAnswer = '';
  String ans = '';

  // Function to update the equation string
  updateEquation(String newNumber) {
    setState(() {
      if (newNumber == 'AC') {
        equation = '';
        userAnswer = '';
        return;
      }
      equation += newNumber;
      return;
    });
  }

  // Function to calculate the answer
  void equalPressed(String equation) {
    // we don't use final because we will change it
    String userQuestion = equation;

    // we must replace the symbols to be able to calculate the equation
    userQuestion = userQuestion.replaceAll('x', '*'); // Replace x with *
    userQuestion = userQuestion.replaceAll('÷', '/'); // Replace ÷ with /
    userQuestion = userQuestion.replaceAll('ANS', ans);

    Parser p = Parser();
    Expression exp = p.parse(userQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    setState(() {
      equation = '';
      userAnswer = NumberFormat.decimalPattern().format(eval);
      ans = userAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModel themeNotifier, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Container(
                  width: 115,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // light theme icon
                      ExpandTapWidget(
                        tapPadding: const EdgeInsets.all(30),
                        onTap: () {
                          themeNotifier.isDarkTheme = false;
                        },
                        child: Icon(
                          Icons.wb_sunny_outlined,
                          color: themeNotifier.isDarkTheme
                              ? inactiveFgColor
                              : Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                      ),
                      // divider
                      const SizedBox(width: 5),
                      // dark theme icon
                      ExpandTapWidget(
                        tapPadding: const EdgeInsets.all(30),
                        onTap: () {
                          themeNotifier.isDarkTheme = true;
                        },
                        child: Icon(
                          FontAwesomeIcons.moon,
                          color: themeNotifier.isDarkTheme
                              ? Theme.of(context).colorScheme.secondary
                              : lightInactiveFgColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 60,
                        right: 28.0,
                        bottom: 6.0,
                      ),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          userAnswer,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 28.0,
                        bottom: 32.0,
                      ),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: SwipeDetector(
                          onSwipeLeft: (offset) {
                            setState(() {
                              if (equation.endsWith('ANS')) {
                                equation =
                                    equation.substring(0, equation.length - 3);
                              } else {
                                equation =
                                    equation.substring(0, equation.length - 1);
                              }
                            });
                          },
                          child: RichText(
                            textAlign: TextAlign.end,
                            text: TextSpan(
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                              children: _getEquationSpans(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Buttons container
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: CreateButtons(
                    equation: equation, // Pass the equation string
                    updateEquation: updateEquation, // Pass the function
                    equalPressed: equalPressed,
                    makePercent: makePercent,
                    toggleSign: toggleSign,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void toggleSign() {
    List<TextSpan> spans = _getEquationSpans();
    TextSpan lastOperator = spans[spans.length - 2];
    String? lastOperatorText = lastOperator.text;
    late final String modifiedOperator;

    if (lastOperatorText != null) {
      if (lastOperatorText == '+' || lastOperatorText == '') {
        modifiedOperator = '-';
      } else if (lastOperatorText == '-') {
        modifiedOperator = '+';
      }
      List<TextSpan> replacement = [
        TextSpan(
          text: modifiedOperator,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        // spans.last,
      ];
      spans.replaceRange(spans.length - 2, spans.length - 1, replacement);
      setState(() {
        // Rebuild the equation text by joining the spans
        equation = spans.map((span) => span.text).join();
      });
    }
  }

  void makePercent() {
    List<TextSpan> spans = _getEquationSpans();
    String? lastNumber = spans.last.text;

    if (lastNumber != null) {
      double numberAsDouble = double.tryParse(lastNumber) ?? 0.0;
      String modifiedNumber = (numberAsDouble / 100).toString();

      spans.removeLast(); // Remove the old last element
      spans.add(
        TextSpan(
          text: modifiedNumber,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      );
      setState(() {
        // Rebuild the equation text by joining the spans
        equation = spans.map((span) => span.text).join();
      });
    }
  }

  List<TextSpan> _getEquationSpans() {
    List<TextSpan> spans = [];
    String currentNumber = '';

    for (int i = 0; i < equation.length; i++) {
      String char = equation[i];

      if (char == '+' || char == '-' || char == 'x' || char == '÷') {
        spans.add(
          TextSpan(
            text: ' $currentNumber ',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        );
        spans.add(
          TextSpan(
            text: char,
            style: const TextStyle(color: operationsColor),
          ),
        ); // Change color for operators
        currentNumber = '';
      } else {
        currentNumber += char;
      }
    }

    spans.add(
      TextSpan(
        text: ' $currentNumber ',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
    );

    return spans;
  }
}
