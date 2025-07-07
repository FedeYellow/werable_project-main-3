import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/PROFILE_CARD/profile_cards.dart';
import 'package:werable_project/HOMEPAGE/HomePage.dart';
import 'package:werable_project/IMPACT/Login_server.dart';
import 'package:werable_project/LOGIN/RegistrationPage.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    
    // en el caso de que se intente iniciar sesion cuando aun no te has registrado - cambios:
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final response = await http.post(
      Uri.parse(url),
      body: {'username': username, 'password': password},
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // comprobación para evitar null
      if (decoded is Map && decoded['access'] != null && decoded['refresh'] != null) {
        final sp = await SharedPreferences.getInstance();
        await sp.setString('access', decoded['access']);
        await sp.setString('refresh', decoded['refresh']);

        // comprobar si existe profile
        final profile = await ProfileCard.loadProfile();
        if (profile.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No profile found. Please register first.')),
          );
          return; // no navegamos al HomePage
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      // no se si hace falta tanta mierda
      } else {
        // 200 OK but missing tokens
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not log in. Are you registered?')),
        );
      }
    } else if (response.statusCode == 401) {
      // user not registered or wrong password
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please check credentials.')),
      );
    } else { 
      // por si hay otros errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server error: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Login',style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
        )),
        backgroundColor: const Color(0xFF3E5F8A),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E5F8A),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: _login,
                    child: Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                child: Text("Don't have an account? Register here", style: TextStyle(color: Color(0xFF3E5F8A))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
