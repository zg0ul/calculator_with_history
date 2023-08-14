import 'package:calculator_with_history/theme/dark_theme.dart';
import 'package:calculator_with_history/theme/light_theme.dart';
import 'package:calculator_with_history/theme/theme_model.dart';
import 'package:calculator_with_history/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer(
        builder: (context, ThemeModel themeNotifier, child) {
          return MaterialApp(
            title: 'Calculator app with history',
            theme: themeNotifier.isDarkTheme ? darkTheme : lightTheme,
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
