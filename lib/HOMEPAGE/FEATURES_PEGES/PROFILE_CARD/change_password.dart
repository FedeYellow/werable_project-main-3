import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:werable_project/IMPACT/Login_server.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();

  bool _isLoading = false;

  Future<void> _changePassword() async {
    setState(() => _isLoading = true);

    final sp = await SharedPreferences.getInstance();
    print("ACCESS: ${sp.getString('access')}");
    print("REFRESH: ${sp.getString('refresh')}");
    var token = sp.getString('access');

    // check expiration
    if (JwtDecoder.isExpired(token!)) {
      await Impact.refreshTokens();
      token = sp.getString('access');
    }

    const url = 'https://impact.dei.unipd.it/bwthw/gate/v1/change_password/';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final body = jsonEncode({
      'old_password': _currentPassController.text,
      'new_password': _newPassController.text,
    });

    final response = await http.put(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CHANGE PASSWORD SUCCESSFUL")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response.body}")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
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
        child: Column(
          children: [
            TextField(
              controller: _currentPassController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPassController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E5F8A),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: _changePassword,
                    child: const Text(
                      'Change Password',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
