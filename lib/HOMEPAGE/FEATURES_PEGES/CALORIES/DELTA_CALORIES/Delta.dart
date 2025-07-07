import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesProvider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/DELTA_CALORIES/InfoPage.dart';

// This widget displays a weekly chart showing the calorie delta (calories in - calories out)
// for each day of the current week. It also calculates the total delta and classifies 
// the user's nutritional status accordingly.
class WeeklyCaloriesDeltaChartCard extends StatefulWidget {
  const WeeklyCaloriesDeltaChartCard({super.key});

  @override
  State<WeeklyCaloriesDeltaChartCard> createState() =>
      _WeeklyCaloriesDeltaChartCardState();
}

class _WeeklyCaloriesDeltaChartCardState extends State<WeeklyCaloriesDeltaChartCard> {
  final dateFormat = DateFormat('yyyy-MM-dd'); // Used to format dates as strings

  @override
  void initState() {
    super.initState();
    final provider = context.read<Caloriesprovider>();
    provider.clearData(); // Clear any existing data in the provider
    _loadDeltaData();     // Load and compute data for the current week
  }

  // Loads daily calories in and out for the current week from SharedPreferences
  Future<void> _loadDeltaData() async {
    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final fullWeek = List.generate(8, (i) => monday.add(Duration(days: i))); // 8 days including today

    final startStr = dateFormat.format(monday);
    final endStr = dateFormat.format(today);

    final provider = context.read<Caloriesprovider>();
    await provider.loadDiaryCaloriesFromPrefs(fullWeek);  // Load calories consumed
    await provider.loadDailyCaloriesFromPrefs(fullWeek);  // Load calories burned
    provider.fetchWeekData(startStr, endStr);              // Fetch combined data
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Caloriesprovider>();

    // Show loading indicator if data is not yet available
    if (!provider.isWeekDataLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    // Generate chart data from provider
    final chartData = _generateChartData(provider);

    // Calculate total weekly calorie delta
    final totalDelta = chartData.fold<int>(0, (sum, item) => sum + item.delta);

    // Determine user's weekly nutritional status
    String nutritionStatus;
    if (totalDelta > 0) {
      nutritionStatus = 'Overnutrition';
    } else if (totalDelta < 0) {
      nutritionStatus = 'Undernutrition';
    } else {
      nutritionStatus = 'Balanced nutrition';
    }

    final totalDeltaString = (totalDelta >= 0 ? '+' : '') + totalDelta.toString();

    return Card(
      color: Colors.grey[100],
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Line chart showing daily calorie delta for the week
            SfCartesianChart(
              title: const ChartTitle(
                text: 'Weekly Calorie Delta',
                alignment: ChartAlignment.center,
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )
              ),
              primaryXAxis: const CategoryAxis(
                labelStyle: TextStyle(fontSize: 10),
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Calorie Delta (kcal)'),
                minimum: -5000,
                maximum: 5000,
                interval: 1000,
                labelStyle: TextStyle(fontSize: 10),
                plotBands: <PlotBand>[
                  // Horizontal line at 0 to indicate balance
                  PlotBand(
                    isVisible: true,
                    start: 0,
                    end: 0,
                    borderColor: Colors.green,
                    borderWidth: 1,
                  ),
                ],
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: const Legend(isVisible: false),
              series: <CartesianSeries<_DayDelta, String>>[
                LineSeries<_DayDelta, String>(
                  dataSource: chartData,
                  xValueMapper: (data, _) => data.day,
                  yValueMapper: (data, _) => data.delta,
                  color: Colors.blue,
                  pointColorMapper: (data, _) =>
                      data.delta >= 0 ? Colors.green : Colors.red, // Green for surplus, red for deficit
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Display total calorie delta and nutrition status with an info button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    'Total Calorie Delta: $totalDeltaString kcal ($nutritionStatus)',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'Learn more about nutritional status',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NutritionInfoPage(), // Opens detailed info page
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Converts the weekly calorie data into a list of _DayDelta for chart plotting
  List<_DayDelta> _generateChartData(Caloriesprovider provider) {
    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final fullWeek = List.generate(8, (i) => monday.add(Duration(days: i)));

    return fullWeek.map((date) {
      final key = dateFormat.format(date);
      final caloriesOut = provider.getDailyCalories(key);       // Calories burned
      final caloriesIn = provider.diaryCaloriesMap[key] ?? 0;   // Calories consumed
      final delta = caloriesIn - caloriesOut;                   // Calorie balance
      final label = '${DateFormat.E('en_US').format(date)}\n${date.day}';
      return _DayDelta(day: label, delta: delta);
    }).toList();
  }
}

// Data model for daily calorie delta used in chart
class _DayDelta {
  final String day;
  final int delta;

  _DayDelta({required this.day, required this.delta});
}
