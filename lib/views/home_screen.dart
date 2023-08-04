import 'package:calculator_with_history/widgets/calculator_buttons.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String equation = ''; // State for the equation

  // Function to update the equation string
  void updateEquation(String newEquation) {
    setState(() {
      if (newEquation == '') {
        equation = '';
        return;
      }
      equation += newEquation;
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
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 28.0,
                      bottom: 32.0,
                    ),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        equation,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                updateEquation: updateEquation, // Pass the update function
              ),
            ),
          ),
        ],
      ),
    );
  }
}
