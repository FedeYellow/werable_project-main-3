import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:werable_project/UTILS/nutrition_utils.dart';
import 'package:werable_project/UTILS/age_utils.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/NUTRITION_CARD/ChildNutritionCardDetails.dart';


class ChildNutritionCard extends StatefulWidget {
  const ChildNutritionCard({super.key});

  @override
  State<ChildNutritionCard> createState() => _ChildNutritionCardState();
}

class _ChildNutritionCardState extends State<ChildNutritionCard> {
  double? weight;
  double? height;
  int? age;
  double? muac;
  String waStatus = '';
  String haStatus = '';
  String whStatus = '';
  String muacStatus = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.getString('profile');
    if (data == null) return;

    final Map<String, dynamic> profile = jsonDecode(data);
    weight = double.tryParse(profile['weight'] ?? '');
    height = double.tryParse(profile['height'] ?? '');

    age = int.tryParse(profile['age'] ?? '');
    
    // age in months
    final birthDate = DateTime.parse(profile['birthDate']);
    final ageInMonths = calculateAgeInMonths(birthDate);

    muac = double.tryParse(profile['muac'] ?? '');

    
    if (weight != null && height != null && age != null) {
      setState(() {
        waStatus = classifyWA(weight!, ageInMonths);
        haStatus = classifyHA(height!, ageInMonths);
        whStatus = classifyWH(weight!, height!);
      });
    }

    if (muac != null) {
      setState(() {
        muacStatus = classifyMUAC(muac!);
      });
    } else {
      setState(() {
        muacStatus = 'No data (edit profile)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: (weight == null || height == null || age == null)
            ? const Text('Child data missing or invalid')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Child Nutrition Status (0–5 years)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('• Weight for the age (W/A): ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(waStatus),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('• Height for the age (H/A): ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(haStatus),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('• Weight for the height (W/H): ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(whStatus),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: '• Mid-Upper Arm Circumference (MUAC): ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: muac != null
                                  ? '${muac!.toStringAsFixed(1)} cm ($muacStatus)'
                                  : 'No data (edit profile)',
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (muac == null) const SizedBox(width: 4),

                      // Button info - how to measure muac
                      if (muac == null)
                        Tooltip(
                          message: "How to measure MUAC",
                          preferBelow: false,
                          verticalOffset: 15,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: const Icon(Icons.info_outline),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  backgroundColor: Colors.grey[200],
                                  title: const Text(
                                    "How to measure MUAC", 
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  content: const Text(
                                    "Use a flexible tape halfway between shoulder and elbow "
                                    "on the left arm, with the arm relaxed. Then edit the profile to add it.",
                                  ),
                                  actions: [
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF3E5F8A),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        textStyle: const TextStyle(fontSize: 14),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E5F8A),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChildNutritionCardDetails(
                              waStatus: waStatus,
                              haStatus: haStatus,
                              whStatus: whStatus,
                              muacStatus: muacStatus,
                              muacValue: muac,
                            ),
                          ),
                        );
                      },
                      child: const Text('More information', style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
