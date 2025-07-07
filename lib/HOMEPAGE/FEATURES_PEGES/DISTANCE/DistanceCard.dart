import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISTANCE/DistanceProvider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISTANCE/DistanceData.dart';
import 'package:intl/intl.dart';

/// This widget displays the total number of steps taken on the previous day.
/// It uses a DistanceProvider to fetch and listen to distance data.
class DistanceCard extends StatefulWidget {
  const DistanceCard({super.key});

  @override
  State<DistanceCard> createState() => _DistanceCardState();
}

class _DistanceCardState extends State<DistanceCard> {
  @override
  void initState() {
    super.initState();
    _fetchDistanceData(); // Load data when the widget is initialized
  }

  /// Fetches the distance data from the provider for yesterday.
  void _fetchDistanceData() {
    final provider = Provider.of<DistanceProvider>(context, listen: false);
    final ieri = DateTime.now().subtract(const Duration(days: 1)); // "ieri" means "yesterday"
    final dayString = DateFormat('yyyy-MM-dd').format(ieri); // Format to string
    provider.fetchData(dayString); // Call fetch method from provider
  }

  @override
  Widget build(BuildContext context) {
    // Get the list of distance records from the provider
    final distanceList = context.watch<DistanceProvider>().distances;

    // Calculate total steps from the list
    int totalSteps = _calculateTotalSteps(distanceList);

    return Card(
      color: const Color(0xFF3E5F8A),
      margin: const EdgeInsets.all(12),
      child: ListTile(
        title: const Text(
          'Total distance from yesterday:',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${totalSteps.toStringAsFixed(0)} Steps',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// Calculates the total number of steps from the list of Distancedata.
  int _calculateTotalSteps(List<Distancedata> list) {
    int totalSteps = list.fold(0, (sum, item) => sum + item.value);
    return totalSteps;
  }
}
