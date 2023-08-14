import 'package:calculator_with_history/constants/colors.dart';
import 'package:calculator_with_history/widgets/button.dart';
import 'package:flutter/material.dart';

class CreateButtons extends StatefulWidget {
  final String equation;
  final Function(String) updateEquation;
  final Function(String) equalPressed;
  final Function() makePercent;
  final Function() toggleSign;

  const CreateButtons({
    super.key,
    required this.equation,
    required this.updateEquation,
    required this.equalPressed,
    required this.makePercent, required this.toggleSign,
  });

  @override
  State<CreateButtons> createState() => CreateButtonsState();
}

class CreateButtonsState extends State<CreateButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Button(
              text: 'AC',
              color: extraColor,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('AC');
                });
              },
            ),
            Button(
              text: '±',
              color: extraColor,
              buttonTapped: () {
                setState(() {
                  widget.toggleSign();
                });
              },
            ),
            Button(
              text: '%',
              color: extraColor,
              buttonTapped: () {
                setState(() {
                  widget.makePercent();
                });
              },
            ),
            Button(
              text: '÷',
              color: operationsColor,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('÷');
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Button(
              text: '7',
              color: Theme.of(context).colorScheme.secondary,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('7');
                });
              },
            ),
            Button(
              text: '8',
              color: Theme.of(context).colorScheme.secondary,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('8');
                });
              },
            ),
            Button(
              text: '9',
              color: Theme.of(context).colorScheme.secondary,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('9');
                });
              },
            ),
            Button(
              text: 'x',
              color: operationsColor,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('x');
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Button(
              text: '4',
              color: Theme.of(context).colorScheme.secondary,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('4');
                });
              },
            ),
            Button(
              text: '5',
              color: Theme.of(context).colorScheme.secondary,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('5');
                });
              },
            ),
            Button(
              text: '6',
              color: Theme.of(context).colorScheme.secondary,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('6');
                });
              },
            ),
            Button(
              text: '-',
              color: operationsColor,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('-');
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Button(
              text: '1',
              color: Theme.of(context).colorScheme.secondary,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('1');
                });
              },
            ),
            Button(
              text: '2',
              color: Theme.of(context).colorScheme.secondary,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('2');
                });
              },
            ),
            Button(
              text: '3',
              color: Theme.of(context).colorScheme.secondary,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('3');
                });
              },
            ),
            Button(
              text: '+',
              color: operationsColor,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('+');
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Button(
              text: 'ANS',
              color: extraColor,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('ANS');
                });
              },
            ),
            Button(
              text: '0',
              color: Theme.of(context).colorScheme.secondary,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('0');
                });
              },
            ),
            Button(
              text: '.',
              color: Theme.of(context).colorScheme.secondary,
              buttonTapped: () {
                setState(() {
                  widget.updateEquation('.');
                });
              },
            ),
            Button(
              text: '=',
              color: operationsColor,
              buttonTapped: () {
                setState(() {
                  widget.equalPressed(widget.equation);
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
