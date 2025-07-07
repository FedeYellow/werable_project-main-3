import 'package:intl/intl.dart';

// This class represents a single calorie entry within a week.
// It includes both the full date, the exact time, and the calorie value.
class CaloriesWeekData {
  final DateTime date; // Date only (e.g., 2025-07-07)
  final DateTime time; // Full timestamp (e.g., 2025-07-07 13:45:00)
  final int value;     // Calorie value (rounded integer)

  // Standard constructor
  CaloriesWeekData({
    required this.date,
    required this.time,
    required this.value,
  });

  /// Factory constructor to create an instance from a JSON map
  /// `dateStr` is provided separately (e.g., '2025-07-07')
  /// The JSON should include 'time' (e.g., '13:45:00') and 'value' (as String)
  factory CaloriesWeekData.fromJsonWithDate(String dateStr, Map<String, dynamic> json) {
    final String timeStr = json['time'];   // e.g., '13:45:00'
    final String valueStr = json['value']; // e.g., '230.6'

    // Combine date and time strings into a full DateTime object
    final DateTime fullDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$dateStr $timeStr');

    // Parse the date portion separately
    final DateTime dateOnly = DateFormat('yyyy-MM-dd').parse(dateStr);

    // Parse and round the calorie value
    final int parsedValue = double.parse(valueStr).round();

    return CaloriesWeekData(
      date: dateOnly,
      time: fullDateTime,
      value: parsedValue,
    );
  }

  // Useful for debugging: prints a readable version of the object
  @override
  String toString() =>
      'CaloriesWeekData(date: ${DateFormat('yyyy-MM-dd').format(date)}, '
      'time: ${DateFormat('HH:mm:ss').format(time)}, value: $value)';
}
