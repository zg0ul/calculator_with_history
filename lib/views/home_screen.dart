import 'package:calculator_with_history/calculation_history.dart';
import 'package:calculator_with_history/constants/colors.dart';
import 'package:calculator_with_history/theme/theme_model.dart';
import 'package:calculator_with_history/views/drawer.dart';
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
  static String ansHistory = '';
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
          drawer: CalculatorDrawer(
            updateAnsHistory: updateAnsHistory,
            emptyHistory: emptyHistory,
            calculationHistory: calculationHistory,
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

  void emptyHistory() {
    setState(() {
      calculationHistory = [];
      historyBox.clear();
    });
  }

  void toggleSign() {
    String operators = '+-x÷';
    String modifiedEquation = equation;

    // if the equation doesn't start with an operator, add a - sign since it originally indicates a positive number then toggle the sign
    if (!operators.contains(equation[0])) {
      modifiedEquation = "-$modifiedEquation";
    }

    for (int i = equation.length - 1; i >= 0; i--) {
      if (operators.contains(equation[i])) {
        modifiedEquation = modifiedEquation.replaceRange(
            i,
            i + 1,
            equation[i] == '+'
                ? '-'
                : (equation[i] == '-' ? '+' : equation[i]));
        break;
      }
    }

    setState(() {
      equation = modifiedEquation;
    });
  }

  // void toggleSign() {
  //   List<TextSpan> spans = _getEquationSpans();

  //   // Find the index of the operator to toggle
  //   int operatorIndex = spans.lastIndexWhere((span) =>
  //       span.text == ' + ' ||
  //       span.text == ' - ' ||
  //       span.text == ' x ' ||
  //       span.text == ' ÷ ');

  //   print(operatorIndex);
  //   if (operatorIndex >= 0) {
  //     TextSpan operatorSpan = spans[operatorIndex];
  //     String originalOperator = operatorSpan.text!;

  //     String modifiedOperator = '';
  //     if (originalOperator == ' + ') {
  //       modifiedOperator = '-';
  //     } else if (originalOperator == ' - ') {
  //       modifiedOperator = '+';
  //     }

  //     // Replace the operator span with the modified operator
  //     spans[operatorIndex] = TextSpan(
  //       text: modifiedOperator,
  //       style: TextStyle(color: Theme.of(context).colorScheme.secondary),
  //     );

  //     // Rebuild the equation text by joining the spans
  //     equation = spans.map((span) => span.text).join();

  //     setState(() {});
  //   }
  // }

  void makePercent() {
    String modifiedEquation = equation;
    List<String> operators = ['+', '-', 'x', '÷'];

    for (int i = equation.length - 1; i >= 0; i--) {
      String char = equation[i];
      if (operators.contains(char) || i == 0) {
        String number = equation.substring(i == 0 ? 0 : i + 1);
        double numberAsDouble = double.tryParse(number) ?? 0.0;
        String modifiedNumber = (numberAsDouble / 100).toString();

        modifiedEquation = modifiedEquation.replaceRange(
            i == 0 ? 0 : i + 1, equation.length, modifiedNumber);
        break;
      }
    }

    setState(() {
      equation = modifiedEquation;
    });
  }

  // void makePercent() {
  //   List<TextSpan> spans = _getEquationSpans();
  //   String? lastNumber = spans.last.text;

  //   if (lastNumber != null) {
  //     double numberAsDouble = double.tryParse(lastNumber) ?? 0.0;
  //     String modifiedNumber = (numberAsDouble / 100).toString();

  //     spans.removeLast(); // Remove the old last element
  //     spans.add(
  //       TextSpan(
  //         text: modifiedNumber,
  //         style: TextStyle(color: Theme.of(context).colorScheme.secondary),
  //       ),
  //     );
  //     setState(() {
  //       // Rebuild the equation text by joining the spans
  //       equation = spans.map((span) => span.text).join();
  //     });
  //   }
  // }

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
      updateAnsHistory(calculation);
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
        if (currentNumber.isNotEmpty) {
          spans.add(
            TextSpan(
              text: '$currentNumber',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          );
          currentNumber = '';
        }
        spans.add(
          TextSpan(
            text: ' $char ',
            style: const TextStyle(color: operationsColor),
          ),
        ); // Change color for operators
      } else {
        currentNumber += char;
      }
    }

    if (currentNumber.isNotEmpty) {
      spans.add(
        TextSpan(
          text: '$currentNumber',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      );
    }

    return spans;
  }

  getEquationText() {
    // responsible for getting the RichText to be displayed in the calculation history.
    return RichText(
      textAlign: TextAlign.end,
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        children: _getEquationSpans(),
      ),
    );
  }

  updateAnsHistory(String newAns) {
    setState(() {
      ansHistory = newAns;
    });
  }
}
