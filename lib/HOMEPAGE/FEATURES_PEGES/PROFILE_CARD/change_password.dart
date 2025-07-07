import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:werable_project/IMPACT/Login_server.dart';

/// A page that allows the user to change their password
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentPassController = TextEditingController(); // input for current password
  final _newPassController = TextEditingController();     // input for new password

  bool _isLoading = false; // to show loading indicator while processing request

  /// Handles password change logic, including token refresh
  Future<void> _changePassword() async {
    setState(() => _isLoading = true);

    final sp = await SharedPreferences.getInstance();
    var token = sp.getString('access');

    // 🔐 If token is expired, refresh it first
    if (JwtDecoder.isExpired(token!)) {
      await Impact.refreshTokens();
      token = sp.getString('access');
    }

    // API endpoint to change password
    const url = 'https://impact.dei.unipd.it/bwthw/gate/v1/change_password/';

    // Set request headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    // Build request body with the current and new password
    final body = jsonEncode({
      'old_password': _currentPassController.text,
      'new_password': _newPassController.text,
    });

    // 🔁 Make the HTTP PUT request
    final response = await http.put(Uri.parse(url), headers: headers, body: body);

    // ✅ Handle result
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CHANGE PASSWORD SUCCESSFUL")),
      );
      Navigator.pop(context); // Go back to previous screen
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
            // 🔑 Current password input
            TextField(
              controller: _currentPassController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // 🆕 New password input
            TextField(
              controller: _newPassController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            // 🔄 Show loading or submit button
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
