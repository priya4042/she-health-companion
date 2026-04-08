import 'package:hive/hive.dart';

part 'water_model.g.dart';

@HiveType(typeId: 4)
class WaterIntake extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final int glasses;

  @HiveField(3)
  final DateTime timestamp;

  WaterIntake({
    required this.id,
    required this.date,
    required this.glasses,
    required this.timestamp,
  });
}
