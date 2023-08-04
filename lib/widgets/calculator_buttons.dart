import 'package:calculator_with_history/constants/colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Color color;

  const Button({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CreateButtons extends StatefulWidget {
  final String equation;
  final Function(String) updateEquation;

  const CreateButtons(
      {super.key, required this.equation, required this.updateEquation});

  @override
  State<CreateButtons> createState() => CreateButtonsState();
}

class CreateButtonsState extends State<CreateButtons> {
  String equation = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('');
                });
              },
              child: const Button(
                text: 'AC',
                color: extraColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  equation += '(';
                });
              },
              child: const Button(
                text: '(',
                color: extraColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  equation += ')';
                });
              },
              child: const Button(
                text: ')',
                color: extraColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('÷');
                });
              },
              child: const Button(
                text: '÷',
                color: operationsColor,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('7');
                });
              },
              child: const Button(
                text: '7',
                color: numbersColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('8');
                });
              },
              child: const Button(
                text: '8',
                color: numbersColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('9');
                });
              },
              child: const Button(
                text: '9',
                color: numbersColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('x');
                });
              },
              child: const Button(
                text: 'x',
                color: operationsColor,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('4');
                });
              },
              child: const Button(
                text: '4',
                color: numbersColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('5');
                });
              },
              child: const Button(
                text: '5',
                color: numbersColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('6');
                });
              },
              child: const Button(
                text: '6',
                color: numbersColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('-');
                });
              },
              child: const Button(
                text: '-',
                color: operationsColor,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('1');
                });
              },
              child: const Button(
                text: '1',
                color: numbersColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('2');
                });
              },
              child: const Button(
                text: '2',
                color: numbersColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('3');
                });
              },
              child: const Button(
                text: '3',
                color: numbersColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('+');
                });
              },
              child: const Button(
                text: '+',
                color: operationsColor,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Button(
              text: 'ANS',
              color: extraColor,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('0');
                });
              },
              child: const Button(
                text: '0',
                color: numbersColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.updateEquation('.');
                });
              },
              child: const Button(
                text: '.',
                color: numbersColor,
              ),
            ),
            const Button(
              text: '=',
              color: operationsColor,
            ),
          ],
        ),
      ],
    );
  }
}
