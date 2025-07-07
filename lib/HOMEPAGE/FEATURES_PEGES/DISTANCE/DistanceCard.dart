import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISTANCE/DistanceProvider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISTANCE/DistanceData.dart';
import 'package:intl/intl.dart';

class DistanceCard extends StatefulWidget {
  const DistanceCard({super.key});

  @override
  State<DistanceCard> createState() => _DistanceCardState();
}

class _DistanceCardState extends State<DistanceCard> {
  @override
  void initState() {
    super.initState();
    _fetchDistanceData();
  }

  void _fetchDistanceData() {
    final provider = Provider.of<DistanceProvider>(context, listen: false);
    final ieri = DateTime.now().subtract(const Duration(days: 1));
    final dayString = DateFormat('yyyy-MM-dd').format(ieri);
    provider.fetchData(dayString);
  }

  @override
  Widget build(BuildContext context) {
    final distanceList = context.watch<DistanceProvider>().distances;

    int Step = _calcolaDistanzaTotale(distanceList);

    return Card(
      color: Color(0xFF3E5F8A),
      margin: const EdgeInsets.all(12),
      child: ListTile(
        title: const Text('Total distance from yesterday: ', style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('${Step.toStringAsFixed(0)} Steps', style:TextStyle(color: Colors.white)),
      ),
    );
  }

  int _calcolaDistanzaTotale(List<Distancedata> lista) {
    int totalSteps = lista.fold(0, (somma, item) => somma + item.value);
    return totalSteps;
  }
}
