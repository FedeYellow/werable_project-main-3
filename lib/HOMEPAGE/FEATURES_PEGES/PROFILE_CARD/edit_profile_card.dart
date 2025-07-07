import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class EditProfileCard extends StatefulWidget {
  const EditProfileCard({Key? key}) : super(key: key);

  @override
  State<EditProfileCard> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfileCard> {

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _muacController = TextEditingController(); 

  int age = 99;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.getString('profile');
    if (data != null) {
      final profile = jsonDecode(data);
      _weightController.text = profile['weight'] ?? '';
      _heightController.text = profile['height'] ?? ''; 

      _muacController.text = profile['muac'] ?? ''; // edit muac only in child <5
      final _age = int.tryParse(profile['age'] ?? ''); // para poder decir cuando aparece lo de editar el muac

      if (_age != null) {
        setState(() { // avisar al framework que tu widget cambió datos que afectan a su presentación en pantalla
          age = _age;
        });
      }

    }
  }

  Future<void> _saveProfile() async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.getString('profile');
    if (data == null) return;

    final profile = jsonDecode(data);
    profile['weight'] = _weightController.text;
    profile['height'] = _heightController.text;  
    profile['muac'] = _muacController.text;

    await sp.setString('profile', jsonEncode(profile));

    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile',  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.underline, decorationColor: Colors.white),),
        backgroundColor: Color(0xFF3E5F8A),
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
              TextField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Edit weight (kg)', labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10), 
              TextField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Edit height (cm)', labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              if (age < 5) ...[
                TextField(
                  controller: _muacController,
                  decoration: const InputDecoration(labelText: 'Edit MUAC (cm)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20)
              ],

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E5F8A),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),),
                onPressed: _saveProfile,
                child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
