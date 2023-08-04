import 'package:calculator_with_history/constants/colors.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: lightBackgroundColor,
    primaryContainer: lightContainerColor,
    secondaryContainer: lightButtonsColor, // for the buttons background color
    secondary: lightTextColor, // for the text color
  ),
);
