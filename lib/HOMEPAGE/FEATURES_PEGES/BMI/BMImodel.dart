import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:convert';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/BMI/BMIdetails.dart';

// This widget displays a BMI (Body Mass Index) card which calculates and shows
// the user's BMI based on data stored in SharedPreferences. It also visually 
// presents the BMI value using a linear gauge and classifies the result 
// (e.g., Underweight, Normal, Overweight, Obese). A button is provided to 
// navigate to a detailed BMI information page.

class BMICard extends StatefulWidget {
  const BMICard({super.key});

  @override
  State<BMICard> createState() => _BMICardState();
}

class _BMICardState extends State<BMICard> {
  double? bmi; // Holds the calculated BMI value
  String status = ''; // Holds the BMI classification (e.g., Normal, Obese)

  @override
  void initState() {
    super.initState();
    _loadProfile(); // Loads the user's profile data and calculates BMI
  }

  // Loads profile data from SharedPreferences, calculates BMI, and updates state
  Future<void> _loadProfile() async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.getString('profile');
    if (data == null) return;

    final Map<String, dynamic> profile = jsonDecode(data);
    final double? weight = double.tryParse(profile['weight'] ?? '');
    final double? heightCm = double.tryParse(profile['height'] ?? '');
    final double? heightM = heightCm != null ? heightCm / 100 : null;

    // Calculate BMI if valid weight and height are available
    if (weight != null && heightM != null && heightM > 0) {
      final calculatedBmi = weight / (heightM * heightM);
      setState(() {
        bmi = calculatedBmi;
        status = _classifyBMI(calculatedBmi); // Classifies the BMI result
      });
    }
  }

  // Returns a string classification based on the BMI value
  String _classifyBMI(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: bmi == null
            ? const Text('BMI not available: missing or invalid data')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Body Mass Index (BMI)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Labels above the gauge indicating BMI categories
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Underweight', style: TextStyle(fontSize: 12)),
                      Text('Normal', style: TextStyle(fontSize: 12)),
                      Text('Overweight', style: TextStyle(fontSize: 12)),
                      Text('Obese', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Visual gauge representing the BMI range and user's value
                  SfLinearGauge(
                    minimum: 10,
                    maximum: 40,
                    showTicks: false,
                    showLabels: false,
                    animateAxis: true,
                    ranges: const <LinearGaugeRange>[
                      LinearGaugeRange(
                        startValue: 10,
                        endValue: 18.5,
                        color: Colors.blue,
                      ),
                      LinearGaugeRange(
                        startValue: 18.5,
                        endValue: 25,
                        color: Colors.green,
                      ),
                      LinearGaugeRange(
                        startValue: 25,
                        endValue: 30,
                        color: Colors.orange,
                      ),
                      LinearGaugeRange(
                        startValue: 30,
                        endValue: 40,
                        color: Colors.red,
                      ),
                    ],
                    markerPointers: <LinearMarkerPointer>[
                      LinearWidgetPointer(
                        value: bmi!,
                        position: LinearElementPosition.outside,
                        child: const Icon(Icons.arrow_drop_down, size: 28),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Displays BMI value and classification
                  Text('BMI: ${bmi!.toStringAsFixed(1)} - Status: $status'),

                  const SizedBox(height: 8),

                  // Button to navigate to a detailed BMI information page
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E5F8A),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => BMIDetails(bmi: bmi!),
                        ));
                      },
                      child: Text(
                        'More information',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
