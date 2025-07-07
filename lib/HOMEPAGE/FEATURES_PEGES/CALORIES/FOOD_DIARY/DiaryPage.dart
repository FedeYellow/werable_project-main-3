import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesProvider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/PROFILE_CARD/profile_cards.dart';

// This screen allows the user to track their food diary entries for the current week.
// Users can add meals with associated calories, and delete previously registered meals.
// Data is stored per day and linked to the user profile via SharedPreferences.

class FoodDiaryPage extends StatefulWidget {
  const FoodDiaryPage({super.key});

  @override
  State<FoodDiaryPage> createState() => _FoodDiaryPageState();
}

class _FoodDiaryPageState extends State<FoodDiaryPage> {
  // Format for keys (yyyy-MM-dd) and day labels (Mon, Tue, ...)
  final dateFormat = DateFormat('yyyy-MM-dd');
  final labelFormat = DateFormat.E('en_US');

  // Text controllers for user input
  final _foodController = TextEditingController();
  final _calorieController = TextEditingController();

  // Currently selected day for entry
  DateTime _selectedDate = DateTime.now();

  // Full week starting from Monday
  List<DateTime> fullWeek = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    fullWeek = List.generate(8, (i) => monday.add(Duration(days: i)));
    _selectedDate = now; // Default selected date is today
  }

  // Adds a new food entry with calories to SharedPreferences
  Future<void> _addFood() async {
    final food = _foodController.text.trim();
    final calories = int.tryParse(_calorieController.text) ?? 0;
    if (food.isEmpty || calories <= 0) return;

    final prefs = await SharedPreferences.getInstance();
    final profile = await ProfileCard.loadProfile();
    final profileName = profile['firstName'] ?? '';

    final key = dateFormat.format(_selectedDate);
    final foodListKey = 'diary_food_list_${profileName}_$key';
    final caloriesKey = 'diary_calories_${profileName}_$key';

    // Add the new entry to the existing list
    final list = prefs.getStringList(foodListKey) ?? [];
    list.add('$food: $calories kcal');
    await prefs.setStringList(foodListKey, list);

    // Update the total calories for that day
    final total = prefs.getInt(caloriesKey) ?? 0;
    await prefs.setInt(caloriesKey, total + calories);

    if (!mounted) return;

    // Refresh the provider data and clear inputs
    Provider.of<Caloriesprovider>(context, listen: false)
        .loadDiaryCaloriesFromPrefs(fullWeek);

    _foodController.clear();
    _calorieController.clear();
    setState(() {});
  }

  // Deletes a specific food entry and updates calorie total
  Future<void> _deleteFood(String label, int index) async {
    final prefs = await SharedPreferences.getInstance();
    final profile = await ProfileCard.loadProfile();
    final profileName = profile['firstName'] ?? '';

    // Identify the matching date from the label
    final date = fullWeek.firstWhere((d) => '${labelFormat.format(d)} ${d.day}' == label);
    final key = dateFormat.format(date);

    final foodListKey = 'diary_food_list_${profileName}_$key';
    final caloriesKey = 'diary_calories_${profileName}_$key';

    final list = prefs.getStringList(foodListKey) ?? [];
    final item = list[index];

    // Extract calorie value using regex
    final match = RegExp(r': (\d+) kcal').firstMatch(item);
    final kcal = int.tryParse(match?.group(1) ?? '0') ?? 0;

    list.removeAt(index);
    await prefs.setStringList(foodListKey, list);
    final total = prefs.getInt(caloriesKey) ?? 0;
    await prefs.setInt(caloriesKey, (total - kcal).clamp(0, 99999));

    // Refresh data
    Provider.of<Caloriesprovider>(context, listen: false)
        .loadDiaryCaloriesFromPrefs(fullWeek);
    setState(() {});
  }

  // Loads all meals from shared preferences for the full week
  Future<Map<String, List<String>>> _loadWeeklyDiary() async {
    final prefs = await SharedPreferences.getInstance();
    final profile = await ProfileCard.loadProfile();
    final profileName = profile['firstName'] ?? '';

    final Map<String, List<String>> map = {};
    for (final date in fullWeek) {
      final label = '${labelFormat.format(date)} ${date.day}';
      final key = dateFormat.format(date);
      final foodListKey = 'diary_food_list_${profileName}_$key';
      map[label] = prefs.getStringList(foodListKey) ?? [];
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Food Diary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF3E5F8A),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<Map<String, List<String>>>(
          future: _loadWeeklyDiary(), // Load data when widget builds
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

            final diary = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Input for food name
                TextField(
                  controller: _foodController,
                  decoration: const InputDecoration(labelText: 'Food'),
                ),
                const SizedBox(height: 8),

                // Input for calories
                TextField(
                  controller: _calorieController,
                  decoration: const InputDecoration(labelText: 'Calories'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),

                // Dropdown to select a day
                DropdownButtonFormField<DateTime>(
                  value: _selectedDate,
                  items: fullWeek.map((date) {
                    final label = '${labelFormat.format(date)} ${date.day}';
                    return DropdownMenuItem(
                      value: date,
                      child: Text(label),
                    );
                  }).toList(),
                  onChanged: (date) => setState(() => _selectedDate = date!),
                  decoration: const InputDecoration(labelText: 'Day'),
                ),
                const SizedBox(height: 8),

                // Add meal button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E5F8A),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: _addFood,
                  child: const Text(
                    'Add meal',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),

                // Meal list for the week
                ...diary.entries.map((entry) {
                  final label = entry.key;
                  final items = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                      if (items.isEmpty)
                        const Text('There is no meals registrated.')
                      else
                        ...items.asMap().entries.map((e) {
                          final i = e.key;
                          final item = e.value;

                          return ListTile(
                            title: Text(item),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteFood(label, i),
                            ),
                          );
                        }),
                      const Divider(),
                    ],
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
