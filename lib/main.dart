import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesProvider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CART/ProviderCart.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISTANCE/DistanceProvider.dart';
import 'package:werable_project/HOMEPAGE/HomePage.dart';
import 'package:werable_project/LOGIN/LoginPage.dart';
import 'package:werable_project/LOGIN/RegistrationPage.dart';

/// Entry point of the application.
/// Initializes providers for state management and sets the root widget.
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => DistanceProvider()),
        ChangeNotifierProvider(create: (_) => Caloriesprovider()),
      ],
      child: const MyApp(),
    ),
  );
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impact Auth Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WelcomePage(),
    );
  }
}

/// WelcomePage shown on app launch.
/// Allows user to access the app or register as a user or seller.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  /// Checks if a valid access token exists (basic presence check).
  Future<bool> _hasValidToken() async {
    final sp = await SharedPreferences.getInstance();
    final access = sp.getString('access');
    return access != null && access.isNotEmpty;
  }

  /// Navigates to HomePage if a token exists, otherwise to LoginPage.
  void _navigateAsUser(BuildContext context) async {
    final hasToken = await _hasValidToken();
    if (hasToken) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  /// Navigates to the registration selection screen.
  void _navigateToRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WELCOME PAGE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF3E5F8A),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // User access button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E5F8A),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () => _navigateAsUser(context),
                child: const Text(
                  'Access as User',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              // Placeholder seller access button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E5F8A),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Seller page not available yet')),
                  );
                },
                child: const Text(
                  'Access as Seller',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              // Registration button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E5F8A),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () => _navigateToRegistration(context),
                child: const Text(
                  'Register',
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

/// Page where user selects whether to register as User or Seller.
/// Currently only User registration is available.
class RegistrationSelectionPage extends StatefulWidget {
  const RegistrationSelectionPage({Key? key}) : super(key: key);

  @override
  State<RegistrationSelectionPage> createState() => _RegistrationSelectionPageState();
}

class _RegistrationSelectionPageState extends State<RegistrationSelectionPage> {
  int selectedIndex = 0; // 0 = User, 1 = Seller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registration',
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
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Register as:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),

                // Toggle between User and Seller
                ToggleButtons(
                  isSelected: [selectedIndex == 0, selectedIndex == 1],
                  onPressed: (index) {
                    setState(() => selectedIndex = index);
                  },
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: const Color(0xFF3E5F8A),
                  color: Colors.black,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('User'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Seller'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Proceed to registration
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E5F8A),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    if (selectedIndex == 0) {
                      // Navigate to User registration
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationPage()),
                      );
                    } else {
                      // Seller registration not available
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registration as seller not available')),
                      );
                    }
                  },
                  child: const Text(
                    'Proceed',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
