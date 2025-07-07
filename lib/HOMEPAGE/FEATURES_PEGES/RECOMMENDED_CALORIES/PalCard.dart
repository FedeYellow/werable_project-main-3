import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/PROFILE_CARD/profile_cards.dart';

class CaloricRequirementCard extends StatefulWidget {
  const CaloricRequirementCard({super.key});

  @override
  State<CaloricRequirementCard> createState() => _CaloricRequirementCardState();
}

class _CaloricRequirementCardState extends State<CaloricRequirementCard> {
  int? bmr;
  String activityLevel = 'Sedentary';
  String? gender;

  final Map<String, double> activityMultipliers = {
    'Sedentary': 1.2,
    'Lightly Active': 1.375,
    'Moderately Active': 1.55,
    'Very Active': 1.725,
    'Extra Active': 1.9,
  };

  final Map<String, String> activityToDays = {
    'Sedentary': '0 days per week',
    'Lightly Active': '1/2 days per week',
    'Moderately Active': '3/4 days per week',
    'Very Active': '5/6 days per week',
    'Extra Active': 'every day',
  };

  @override
  void initState() {
    super.initState();
    _loadUserDataAndCalculateBMR();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _askUserForActivityLevel(context);
    });
  }

  Future<void> _loadUserDataAndCalculateBMR() async {
    final profile = await ProfileCard.loadProfile();

    final double weight = double.tryParse(profile['weight'] ?? '') ?? 0;
    final double height = double.tryParse(profile['height'] ?? '') ?? 0;
    final String genderValue = (profile['gender'] ?? 'm').toLowerCase();
    final int age = int.tryParse(profile['age'] ?? '') ?? 0;

    final sp = await SharedPreferences.getInstance();
    final String activity = sp.getString('activity_level') ?? 'Sedentary';

    double calculatedBMR;
    if (genderValue == 'm') {
      calculatedBMR = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      calculatedBMR = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }

    final int finalBmr = calculatedBMR.round();
    final double multiplier = activityMultipliers[activity] ?? 1.2;
    final int caloricNeed = (finalBmr * multiplier).round();

    await _saveCaloricParams(bmr: finalBmr, caloricNeed: caloricNeed);

    setState(() {
      bmr = finalBmr;
      activityLevel = activity;
      gender = genderValue;
    });
  }

  Future<void> _saveCaloricParams({required int bmr, required int caloricNeed}) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt('bmr', bmr);
    await sp.setInt('caloric_need', caloricNeed);
  }

  Future<void> _saveActivityLevel(String level) async {
    final sp = await SharedPreferences.getInstance();

    // obtener el nombere del perfil actual
    final profile = await ProfileCard.loadProfile();
    final profileName = profile['firstName'] ?? '';

    await sp.setString('activity_level', level);

    // para lo del nombre:
    await sp.setString('activity_level_user', profileName);

    await _loadUserDataAndCalculateBMR();
  }

  Future<void> _askUserForActivityLevel(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    final existingLevel = sp.getString('activity_level');

    // first name:
    final savedUser = sp.getString('activity_level_user');

    // obtengo nombre actual:
    final profile = await ProfileCard.loadProfile();
    final profileName = profile['firstName'] ?? '';

    // solo lo pide si no existe o es otro user
    if (existingLevel != null && savedUser == profileName) return;
    //if (existingLevel != null) return; antes

    String selected = 'Sedentary';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[100],
          title: const Text('Select your activity level'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<String>(
                isExpanded: true,
                value: selected,
                dropdownColor: Colors.grey[100],
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black, // color texto seleccionado
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selected = value);
                  }
                },
                items: activityMultipliers.keys.map((level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E5F8A),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () async {
                await _saveActivityLevel(selected);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildInfoRow(String label, String value, {FontWeight weight = FontWeight.normal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, fontWeight: weight)),
          Text(value, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double multiplier = activityMultipliers[activityLevel] ?? 1.2;
    final int caloricNeed = ((bmr ?? 0) * multiplier).round();
    final String activityDays = activityToDays[activityLevel] ?? '-';

    return Card(
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Caloric Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            DropdownButton<String>(
              isExpanded: true,
              value: activityLevel,
              dropdownColor: Colors.grey[100],
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black, // color texto seleccionado
              ),
              onChanged: (String? newValue) {
                if (newValue != null) _saveActivityLevel(newValue);
              },
              items: activityMultipliers.keys.map((String level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level, style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            if (bmr != null) ...[
              buildInfoRow('BMR', '$bmr kcal/day', weight: FontWeight.w500),
              buildInfoRow('Caloric Need', '$caloricNeed kcal/day', weight: FontWeight.w500),
              buildInfoRow('Training Days', activityDays),
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: const Text(
                    'More Info',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (gender == 'm') 
                            const Text(
                              'BMR (men):\n88.362 + (13.397 × kg) + (4.799 × cm) - (5.677 × age)',
                              style: TextStyle(fontSize: 12),
                            )
                          else 
                            const Text(
                              'BMR (women):\n447.593 + (9.247 × kg) + (3.098 × cm) - (4.330 × age)',
                              style: TextStyle(fontSize: 12),
                            ),
                          const SizedBox(height: 4),
                          const Text(
                            'Caloric Need = BMR × Activity Level (PAL)',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
