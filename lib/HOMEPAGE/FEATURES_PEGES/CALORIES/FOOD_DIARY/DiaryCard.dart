// This widget (DiaryCard) displays a bar chart showing the user's daily calorie intake 
// for the current week based on saved diary data. It also includes a button to navigate 
// to the detailed food diary page. When returning from that page, the chart refreshes.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesProvider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/FOOD_DIARY/DiaryPage.dart';

class DiaryCard extends StatefulWidget {
  const DiaryCard({super.key});

  @override
  State<DiaryCard> createState() => _DiaryCardState();
}

class _DiaryCardState extends State<DiaryCard> {
  final dateFormat = DateFormat('yyyy-MM-dd'); // Format for data lookup keys
  final labelFormat = DateFormat.E('en_US');   // Format for day labels (e.g. Mon, Tue)
  late final List<DateTime> fullWeek;          // List of 8 dates from Monday to today
  bool _isLoading = true;                      // Indicates if data is loading

  @override
  void initState() {
    super.initState();

    // Generate the list of days from Monday to today
    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));
    fullWeek = List.generate(8, (i) => monday.add(Duration(days: i)));

    _loadDataFromPrefs(); // Load saved calorie diary data
  }

  // Loads diary calorie data from shared preferences using the provider
  Future<void> _loadDataFromPrefs() async {
    final provider = Provider.of<Caloriesprovider>(context, listen: false);
    provider.diaryCaloriesMap.clear(); // Clear old data
    await provider.loadDiaryCaloriesFromPrefs(fullWeek); // Load new data for the week
    if (mounted) {
      setState(() {
        _isLoading = false; // Mark loading as complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the map of saved calorie values from the provider
    final diaryCaloriesMap = context.watch<Caloriesprovider>().diaryCaloriesMap;

    // Convert the calorie data into chart-friendly objects
    final chartData = fullWeek.map((date) {
      final label = '${labelFormat.format(date)}\n${date.day}'; // e.g. Mon\n1
      final key = dateFormat.format(date); // e.g. 2025-07-07
      final value = diaryCaloriesMap[key] ?? 0;
      return _DayCalories(day: label, calories: value);
    }).toList();

    return Card(
      color: Colors.grey[100],
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            // Show loading indicator while data is loading
            ? const Center(child: CircularProgressIndicator())
            // Show the chart and button when data is ready
            : Column(
                children: [
                  // Bar chart of daily food calories
                  SfCartesianChart(
                    title: const ChartTitle(
                      text: 'Weekly Food Calories',
                      alignment: ChartAlignment.center,
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: const NumericAxis(
                      title: AxisTitle(text: 'Calorie (kcal)'),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries<_DayCalories, String>>[
                      ColumnSeries<_DayCalories, String>(
                        dataSource: chartData,
                        xValueMapper: (data, _) => data.day,
                        yValueMapper: (data, _) => data.calories,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Button to go to the Food Diary page
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E5F8A),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      // Navigate to food diary and reload chart data when returning
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const FoodDiaryPage()),
                      );
                      await _loadDataFromPrefs(); // Refresh chart after diary update
                    },
                    child: const Text(
                      'Show Diary',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Model class to hold calorie data for a single day (used by chart)
class _DayCalories {
  final String day;      // Label (e.g., Mon\n1)
  final int calories;    // Number of calories logged

  _DayCalories({required this.day, required this.calories});
}
