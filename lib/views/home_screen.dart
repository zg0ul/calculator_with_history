import 'package:calculator_with_history/constants/colors.dart';
import 'package:calculator_with_history/widgets/calculator_buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
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
              ),
            ),
          ),
        ],
      ),
    );
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
