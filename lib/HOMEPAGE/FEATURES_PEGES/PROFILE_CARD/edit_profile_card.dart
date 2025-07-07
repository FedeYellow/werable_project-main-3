import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// EditProfileCard allows the user to update weight, height,
/// and MUAC (if under 5 years old). The data is retrieved from
/// SharedPreferences and saved back after editing.
/// 
/// - Weight and height are always editable.
/// - MUAC appears only if the child's age is less than 5.
/// - On save, the updated values are written to SharedPreferences
///   and the user is returned to the previous screen.


class EditProfileCard extends StatefulWidget {
  const EditProfileCard({Key? key}) : super(key: key);

  @override
  State<EditProfileCard> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfileCard> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _muacController = TextEditingController();

  int age = 99; // Used to determine whether to show MUAC field

  @override
  void initState() {
    super.initState();
    _loadProfile(); // Load saved profile data when the screen loads
  }

  /// Loads profile data from SharedPreferences and fills the form fields.
  Future<void> _loadProfile() async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.getString('profile');
    if (data != null) {
      final profile = jsonDecode(data);

      // Fill input fields with stored values, if any
      _weightController.text = profile['weight'] ?? '';
      _heightController.text = profile['height'] ?? '';
      _muacController.text = profile['muac'] ?? '';

      // Parse age to decide if MUAC field should be shown
      final _age = int.tryParse(profile['age'] ?? '');
      if (_age != null) {
        setState(() => age = _age);
      }
    }
  }

  /// Saves updated profile data to SharedPreferences.
  Future<void> _saveProfile() async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.getString('profile');
    if (data == null) return;

    final profile = jsonDecode(data);

    // Save form values into the profile object
    profile['weight'] = _weightController.text;
    profile['height'] = _heightController.text;
    profile['muac'] = _muacController.text;

    // Save the updated JSON string to shared prefs
    await sp.setString('profile', jsonEncode(profile));

    // Return to the previous screen after saving
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Weight input
              TextField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Edit weight (kg)',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // Height input
              TextField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Edit height (cm)',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // MUAC only for children under 5
              if (age < 5) ...[
                TextField(
                  controller: _muacController,
                  decoration: const InputDecoration(
                    labelText: 'Edit MUAC (cm)',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
              ],

              // Save button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E5F8A),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: _saveProfile,
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
