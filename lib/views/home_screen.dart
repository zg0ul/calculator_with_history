import 'package:calculator_with_history/calculation_history.dart';
import 'package:calculator_with_history/constants/colors.dart';
import 'package:calculator_with_history/theme/theme_model.dart';
import 'package:calculator_with_history/widgets/calculator_buttons.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
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
  String calculation = '';
  String ansHistory = '';
  List<CalculationHistory> calculationHistory = [];
  late Box<CalculationHistory> historyBox;

  @override
  void initState() {
    super.initState();
    historyBox = Hive.box('calculationHistory');
    calculationHistory = historyBox.values.toList();
  }

  @override
  void dispose() {
    if (historyBox.isOpen) {
      historyBox.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModel themeNotifier, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          drawer: Drawer(
            backgroundColor: Theme.of(context).colorScheme.background,
            width: 250,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35.0, bottom: 3),
                  child: Text(
                    "Calculation History",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ListView.builder(
                      itemCount: calculationHistory.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: ListTile(
                            title: Expanded(
                              child: Container(
                                // height: 48,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          calculationHistory[index]
                                              .result
                                              .toString(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                        Text(
                                          calculationHistory[index].equation,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //drawer icon
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 16),
                    child: Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.menu,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 20,
                          ),
                        ),
                      );
                    }),
                  ),
                  // theme switcher
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
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: SizedBox(width: 48),
                  ),
                ],
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
                          calculation,
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

  // Function to calculate the answer
  void equalPressed(String equation) {
    // we don't use final because we will change it
    String userQuestion = equation;

    // we must replace the symbols to be able to calculate the equation
    userQuestion = userQuestion.replaceAll('x', '*'); // Replace x with *
    userQuestion = userQuestion.replaceAll('÷', '/'); // Replace ÷ with /
    userQuestion = userQuestion.replaceAll('ANS', ansHistory);

    Parser p = Parser();
    Expression exp = p.parse(userQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    setState(() {
      calculation = NumberFormat.decimalPattern().format(eval);
      ansHistory = calculation;
      calculationHistory.insert(
          0, CalculationHistory(equation: equation, result: calculation));
      equation = '';
      if (calculationHistory.length > 10) {
        calculationHistory.removeLast();
      }
    });
    historyBox.add(CalculationHistory(
      equation: userQuestion,
      result: calculation,
    ));
  }

  // Function to update the equation string
  updateEquation(String newNumber) {
    setState(() {
      if (newNumber == 'AC') {
        equation = '';
        calculation = '';
        return;
      } else {
        equation += newNumber;
        return;
      }
    });
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
