import 'package:hive/hive.dart';

part 'calculation_history.g.dart';

@HiveType(typeId: 1)
class CalculationHistory {
  @HiveField(0)
  String equation;

  @HiveField(1)
  String result;

  CalculationHistory({
    required this.equation,
    required this.result,
  });
}
