import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:werable_project/UTILS/nutrition_evaluator.dart';

class ChildNutritionCardDetails extends StatelessWidget {
  final String waStatus;
  final String haStatus;
  final String whStatus;
  final String muacStatus;
  final double? muacValue;

  const ChildNutritionCardDetails({
    Key? key,
    required this.waStatus,
    required this.haStatus,
    required this.whStatus,
    required this.muacStatus,
    this.muacValue,
  }) : super(key: key);


  double _mapStatusToValue(String status) {
    switch (status) {
      case 'Low':
        return 15;
      case 'Normal':
        return 50;
      case 'High':
        return 85;
      default:
        return 0;
    }
  }

  // Gauge genérico para los otros indicadores
  Widget _buildGenericGauge(String title, String status) {
    final value = _mapStatusToValue(status);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title, 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Low', style: TextStyle(fontSize: 12)),
            Text('Normal', style: TextStyle(fontSize: 12)),
            Text('High', style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        SfLinearGauge(
          minimum: 0,
          maximum: 100,
          showTicks: false,
          showLabels: false,
          ranges: const <LinearGaugeRange>[
            LinearGaugeRange(startValue: 0, endValue: 30, color: Colors.red),
            LinearGaugeRange(startValue: 30, endValue: 70, color: Colors.green),
            LinearGaugeRange(startValue: 70, endValue: 100, color: Colors.orange),
          ],
          markerPointers: <LinearMarkerPointer>[
            LinearWidgetPointer(
              value: value,
              position: LinearElementPosition.outside,
              child: const Icon(Icons.arrow_drop_down, size: 28),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // Gauge para MUAC con rangos clínicos
  Widget _buildMUACGauge() {
    
    final value = muacValue ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
          'Mid-Upper Arm Circumference (MUAC)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Severe', style: TextStyle(fontSize: 12)),
            Text('Moderate', style: TextStyle(fontSize: 12)),
            Text('Normal', style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        SfLinearGauge(
          minimum: 10,
          maximum: 18,
          showTicks: false,
          showLabels: false,
          ranges: const <LinearGaugeRange>[
            LinearGaugeRange(startValue: 0, endValue: 11, color: Colors.red),
            LinearGaugeRange(startValue: 11, endValue: 12.5, color: Colors.orange),
            LinearGaugeRange(startValue: 12.5, endValue: 18, color: Colors.green),
          ],
          markerPointers: <LinearMarkerPointer>[
            LinearWidgetPointer(
              value: value,
              position: LinearElementPosition.outside,
              child: const Icon(Icons.arrow_drop_down, size: 28),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final conclusion = NutritionEvaluator.Conclusion(
    waStatus: waStatus, 
    haStatus: haStatus, 
    whStatus: whStatus, 
    muacStatus: muacStatus,
    );

    final recommendations = NutritionEvaluator.Recommendations(
      waStatus: waStatus, 
      haStatus: haStatus, 
      whStatus: whStatus, 
      muacStatus: muacStatus,
    );

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Nutrition Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.underline, decorationColor: Colors.white),),
        backgroundColor: Color(0xFF3E5F8A),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            _buildGenericGauge('Weight for age (W/A)', waStatus),
            SizedBox(height: 25),
            _buildGenericGauge('Height for age (H/A)', haStatus),
            SizedBox(height: 25),
            _buildGenericGauge('Weight for height (W/H)', whStatus),
            SizedBox(height: 25),

            if (muacStatus != 'No data (edit profile)')
              _buildMUACGauge(),
              SizedBox(height: 25),

            Row(
              children: [
                Icon(Icons.assignment, color: Colors.blue),
                SizedBox(width: 6),
                Text("Conclusion:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              ],
            ),
            Text(conclusion),

            const SizedBox(height: 15),

            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 6),
                Text("Recommendations:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              ],
            ),
            Text(recommendations),

          ],
        ),
      ),
    );
  }
}
