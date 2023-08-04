import 'package:calculator_with_history/constants/colors.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: backgroundColor,
    primaryContainer: containerColor,
    secondaryContainer: buttonsColor, // for the buttons background color
    secondary: textColor, // for the text color
  ),
);
