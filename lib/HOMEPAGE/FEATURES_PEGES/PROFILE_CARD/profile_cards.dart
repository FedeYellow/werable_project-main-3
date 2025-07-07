import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// ProfileCard displays a user summary including basic health data and avatar.
/// Intended to be used inside user dashboard or home screens.
class ProfileCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String age;
  final String gender;
  final String height;
  final String weight;
  final int numericAge;
  final Widget? bottom;     // Optional widget below the profile (e.g. buttons)
  final String? muac;       // Mid-Upper Arm Circumference (optional, used for children under 5)

  const ProfileCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.numericAge,
    this.bottom,
    this.muac,
  });

  /// Loads the user's profile from SharedPreferences and returns it
  /// as a map of String keys and values. Used for hydration and persistence.
  static Future<Map<String, String>> loadProfile() async {
    final sp = await SharedPreferences.getInstance();
    final jsonString = sp.getString('profile');
    if (jsonString == null) return {};
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((key, value) => MapEntry(key, value.toString()));
  }

  /// Builds the widget tree for the profile card. Displays personal data,
  /// avatar, and optional additional content passed in `bottom`.
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$firstName $lastName',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Age: $age'),
                      Text('Gender: $gender'),
                      Text('Height: $height cm'),
                      Text('Weight: $weight kg'),

                      if (numericAge < 5)
                        Text('MUAC: ${muac ?? '-'} cm'),
                    ],  
                  ),
                ),
                const SizedBox(width: 16),
                ProfilePicture(
                  name: "$firstName $lastName",
                  radius: 35,
                  fontsize: 20,
                ),
              ],
            ),

            if (bottom != null) ...[
              const SizedBox(height: 10),
              bottom!,
            ],
          ],
        ),
      ),
    );
  }
}
