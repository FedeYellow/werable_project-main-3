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
  final dateFormat = DateFormat('yyyy-MM-dd');
  final labelFormat = DateFormat.E('en_US');
  late final List<DateTime> fullWeek;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));
    fullWeek = List.generate(8, (i) => monday.add(Duration(days: i)));
    _loadDataFromPrefs();
  }

  Future<void> _loadDataFromPrefs() async {
    final provider = Provider.of<Caloriesprovider>(context, listen: false);
    provider.diaryCaloriesMap.clear();
    await provider.loadDiaryCaloriesFromPrefs(fullWeek);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final diaryCaloriesMap = context.watch<Caloriesprovider>().diaryCaloriesMap;

    final chartData = fullWeek.map((date) {
      final label = '${labelFormat.format(date)}\n${date.day}';
      final key = dateFormat.format(date);
      final value = diaryCaloriesMap[key] ?? 0;
      return _DayCalories(day: label, calories: value);
    }).toList();

    return Card(
      color: Colors.grey[100],
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E5F8A),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const FoodDiaryPage()),
                      );
                      await _loadDataFromPrefs();
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

class _DayCalories {
  final String day;
  final int calories;

  _DayCalories({required this.day, required this.calories});
}
