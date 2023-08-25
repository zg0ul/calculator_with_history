import 'package:calculator_with_history/boxes.dart';
import 'package:calculator_with_history/calculation_history.dart';
import 'package:calculator_with_history/theme/dark_theme.dart';
import 'package:calculator_with_history/theme/light_theme.dart';
import 'package:calculator_with_history/theme/theme_model.dart';
import 'package:calculator_with_history/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  // initialize hive
  await Hive.initFlutter();
  Hive.registerAdapter(CalculationHistoryAdapter());

  // open the box
  calculationBox = await Hive.openBox<CalculationHistory>('calculationHistory');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
