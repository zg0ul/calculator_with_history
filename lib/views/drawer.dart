import 'package:calculator_with_history/calculation_history.dart';
import 'package:calculator_with_history/utils/show_flushbar.dart';
import 'package:flutter/material.dart';

class CalculatorDrawer extends StatefulWidget {
  final Function emptyHistory;
  final List<CalculationHistory> calculationHistory;
  final Function updateAnsHistory;
  const CalculatorDrawer({
    super.key,
    required this.emptyHistory,
    required this.calculationHistory,
    required this.updateAnsHistory,
    // required this.ansHistory,
  });

  @override
  State<CalculatorDrawer> createState() => _CalculatorDrawerState();
}

class _CalculatorDrawerState extends State<CalculatorDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                itemCount: widget.calculationHistory.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.updateAnsHistory(widget
                              .calculationHistory[index].result
                              .toString());
                        });
                        showFloatingFlushbar(
                            context: context, message: "Answer Copied!");
                      },
                      child: ListTile(
                        title: Container(
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
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        right: 16.0,
                                        bottom: 4,
                                      ),
                                      child: Text(
                                        widget
                                            .calculationHistory[index].result
                                            .toString(),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 8.0, left: 16.0),
                                      child: Text(
                                        widget.calculationHistory[index]
                                            .equation,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
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
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              children: [
                Divider(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextButton(
                    onPressed: () {
                      widget.emptyHistory();
                    },
                    child: Text(
                      "Clear History",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
