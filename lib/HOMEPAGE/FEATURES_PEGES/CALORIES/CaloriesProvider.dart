import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesData.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/WEEK/CaloriesWeekData.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/PROFILE_CARD/profile_cards.dart';
import 'package:werable_project/IMPACT/Login_server.dart';

// This ChangeNotifier class manages calories data for a user, both IN and OUT.
// It communicates with an API and SharedPreferences to store, fetch, and expose calories data.
// - "calories": full detailed log (for 1 day)
// - "weeklyCalories": list of calorie entries for a full week
// - "dailyCaloriesMap": calories OUT per day
// - "diaryCaloriesMap": calories IN per day
class Caloriesprovider extends ChangeNotifier {
  List<Caloriesdata> calories = [];               // Detailed daily calorie burn log
  List<CaloriesWeekData> weeklyCalories = [];     // All calorie entries from the week

  Map<String, int> dailyCaloriesMap = {};         // Calories OUT (per date, key = yyyy-MM-dd)
  Map<String, int> diaryCaloriesMap = {};         // Calories IN (from user input)
  bool isWeekDataLoaded = false;                  // Flag used for UI state

  /// Fetches detailed calories OUT data for a single day from server
  void fetchData(String day) async {
    final data = await Impact.fetchCaloriesData(day);
    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        calories.add(
          Caloriesdata.fromJson(data['data']['date'], data['data']['data'][i]),
        );
      }
      notifyListeners();
    }
  }

  /// Fetches calories OUT data for the entire week from server
  void fetchWeekData(String startDate, String endDate) async {
    final data = await Impact.fetchCaloriesWeekData(startDate, endDate);
    if (data != null) {
      weeklyCalories.clear();
      dailyCaloriesMap.clear();

      for (var day in data['data']) {
        String date = day['date'];
        for (var item in day['data']) {
          final entry = CaloriesWeekData.fromJsonWithDate(date, item);
          weeklyCalories.add(entry);

          final key = entry.date.toIso8601String().split('T').first;

          // Accumulate calories for the day
          dailyCaloriesMap.update(
            key,
            (value) => value + entry.value,
            ifAbsent: () => entry.value,
          );
        }
      }

      isWeekDataLoaded = true;
      notifyListeners();
    }
  }

  /// Loads previously stored calories OUT data from SharedPreferences
  Future<void> loadDailyCaloriesFromPrefs(List<DateTime> weekDates) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, int> loadedData = {};

    for (final date in weekDates) {
      final key = date.toIso8601String().split('T').first;
      loadedData[key] = prefs.getInt('daily_total_calories_$key') ?? 0;
    }

    dailyCaloriesMap = loadedData;
    notifyListeners();
  }

  /// Loads calories IN (food diary) from SharedPreferences for the current user
  Future<void> loadDiaryCaloriesFromPrefs(List<DateTime> weekDates) async {
    final prefs = await SharedPreferences.getInstance();
    diaryCaloriesMap.clear();

    final profile = await ProfileCard.loadProfile();
    final profileName = profile['firstName'] ?? '';

    for (final date in weekDates) {
      final key = date.toIso8601String().split('T').first;
      final diaryKey = 'diary_calories_${profileName}_$key';
      final value = prefs.getInt(diaryKey) ?? 0;

      if (value > 0) {
        diaryCaloriesMap[key] = value;
      }
    }

    notifyListeners();
  }

  /// Returns calories OUT (burned) for a specific date key (yyyy-MM-dd)
  int getDailyCalories(String dateKey) {
    return dailyCaloriesMap[dateKey] ?? 0;
  }

  /// Returns calories IN (consumed) for a specific date key (yyyy-MM-dd)
  int getDiaryCalories(String dateKey) {
    return diaryCaloriesMap[dateKey] ?? 0;
  }

  /// Clears all data in the provider (used on logout or refresh)
  void clearData() {
    calories.clear();
    weeklyCalories.clear();
    dailyCaloriesMap.clear();
    diaryCaloriesMap.clear();
    isWeekDataLoaded = false;
    notifyListeners();
  }
}
