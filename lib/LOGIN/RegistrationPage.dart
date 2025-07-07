import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'dart:convert';
import 'package:werable_project/LOGIN/birth_date.dart'; 
import 'package:werable_project/UTILS/age_utils.dart'; 

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  DateTime? _selectedBirthDate; 

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final gender = _genderController.text.trim();
    final height = _heightController.text.trim();
    final weight = _weightController.text.trim();

    if ([username, password, confirm, firstName, lastName, gender, height, weight].any((e) => e.isEmpty)) { // he quitado age detras de lastname
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // validación --> evitar que el user se registre sin haber seleccionado una fecha de nacimiento
    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your birth date')),
      );
      return;
    }

    final birthDate = _selectedBirthDate!; 
    final calculatedAge = calculateAgeInYears(birthDate);

    final profile = {
      'firstName': firstName,
      'lastName': lastName,
      'age': calculatedAge.toString(),
      'birthDate': birthDate.toIso8601String(), 
      'gender': gender,
      'height': height,
      'weight': weight
    };

    final sp = await SharedPreferences.getInstance();
    await sp.setString('profile', jsonEncode(profile));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration successful!')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.underline, decorationColor: Colors.white)),
        backgroundColor:const Color(0xFF3E5F8A),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Username')),
              TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              TextField(controller: _confirmController, decoration: InputDecoration(labelText: 'Confirm Password'), obscureText: true),
              TextField(controller: _firstNameController, decoration: InputDecoration(labelText: 'First Name')),
              TextField(controller: _lastNameController, decoration: InputDecoration(labelText: 'Last Name')),
            
              //COSECHA
              const SizedBox(height: 12),
              BirthDatePicker(
                onDateSelected: (date) {
                  _selectedBirthDate = date;
                },
              ),

              Divider(color: Colors.grey[600]), // separete line

              // 2 options for gender
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.grey[200],
                ),
                child: DropdownButtonFormField<String>( // crea formulario desplegable - solo acepta string como tipo de valor
                  value: _genderController.text.isNotEmpty ? _genderController.text : null, // si gender no es empty ... - si no null
                  items: [
                    const DropdownMenuItem(value: 'F', child: Text('F')), 
                    const DropdownMenuItem(value: 'M', child: Text('M')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _genderController.text = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Gender'),
                ),
              ),

              TextField(controller: _heightController, decoration: InputDecoration(labelText: 'Height (cm)'), keyboardType: TextInputType.number),
              TextField(controller: _weightController, decoration: InputDecoration(labelText: 'Weight (kg)'), keyboardType: TextInputType.number),
            
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E5F8A),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: _register,
                child: Text('Register', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
