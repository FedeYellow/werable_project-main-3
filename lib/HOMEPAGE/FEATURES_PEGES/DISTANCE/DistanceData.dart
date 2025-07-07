import 'package:intl/intl.dart';

/// A model class representing step data (distance) at a specific time.
class Distancedata {
  final DateTime time; // The exact timestamp (date + time) of the step entry.
  final int value;     // The number of steps recorded at that time.

  /// Standard constructor
  Distancedata({required this.time, required this.value});

  /// Named constructor that creates an instance from a JSON object.
  /// 
  /// - [date] is a string representing the full date, e.g., "2025-07-07"
  /// - [json] contains keys:
  ///     - "time": string, e.g., "14:35:00"
  ///     - "value": string representing an integer, e.g., "245"
  ///
  /// It combines date and time to build a complete DateTime object.
  Distancedata.fromJson(String date, Map<String, dynamic> json)
      : time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
        value = int.parse(json["value"]);

  /// String representation for debugging/logging.
  @override
  String toString() {
    return 'StepData(time: $time, value: $value)';
  }
}
