import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DistanceData.dart';
import 'package:werable_project/IMPACT/Login_server.dart';

/// A ChangeNotifier class that manages distance/step data fetched from an external source.
class DistanceProvider extends ChangeNotifier {
  // A list of Distancedata objects representing steps taken at different times
  List<Distancedata> distances = [];

  /// Fetches distance data for a given [day] from the external server.
  ///
  /// - Clears existing `distances`.
  /// - Retrieves new data using the Impact API.
  /// - Parses and adds each item to the `distances` list.
  /// - Calculates total steps and stores them in SharedPreferences.
  /// - Notifies listeners so widgets depending on this provider will update.
  Future<void> fetchData(String day) async {
    distances.clear(); // Clear old data

    final data = await Impact.fetchDistanceData(day); // API call to get step data

    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        distances.add(
          Distancedata.fromJson(data['data']['date'], data['data']['data'][i]),
        );
      }

      // Calculate the total number of steps for the day
      final totalSteps = distances.fold<int>(0, (sum, item) => sum + item.value);

      // Save total steps in local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('totalSteps', totalSteps);

      // Notify listeners (e.g. UI widgets) that data has changed
      notifyListeners();
    }
  }

  /// Clears the list of distances and notifies listeners
  void clearData() {
    distances.clear();
    notifyListeners();
  }
}
