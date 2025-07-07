import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/BMI/BMImodel.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/DELTA_CALORIES/Delta.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/FOOD_DIARY/DiaryCard.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/WEEK/CaloriesChartWeekCard.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CART/CartPage.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CART/ProviderCart.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISTANCE/DistanceCard.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/MAP/map_card.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/PROFILE_CARD/profile_cards.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/RECOMMENDED_CALORIES/PalCard.dart';
import 'package:werable_project/LOGIN/LoginPage.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/PROFILE_CARD/edit_profile_button.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/NUTRITION_CARD/ChildNutritionCard.dart';
import 'package:werable_project/UTILS/age_utils.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISCOUNT/DiscountCard.dart';

/// HomePage is the main screen displayed after login.
/// It shows the user's profile, personalized nutrition and activity data,
/// and access to other feature cards like BMI, calorie tracking, distance, and a cart.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    // Load the user's cart based on their profile when HomePage is initialized
    Future.microtask(() async {
      final profile = await ProfileCard.loadProfile();
      final profileName = profile['firstName'] ?? '';
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.loadCartFromPrefs(profileName);
    });
  }

  /// Logs the user out: clears tokens and cart data, then navigates back to LoginPage.
  Future<void> _logout(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('access');
    await sp.remove('refresh');

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Homepage',
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
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Container(
        color: Colors.grey[200], // Page background color
        child: FutureBuilder<Map<String, String>>(
          future: ProfileCard.loadProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            final profile = snapshot.data ?? {};

            final ageYears = int.tryParse(profile['age'] ?? '0') ?? 0;

            // Get formatted age from birthDate (e.g., "2 years" or "10 months")
            final birthDateStr = profile['birthDate'];

            if (birthDateStr == null) {
              return const Center(child: Text('No profile data found. Please register.'));
            }

            final birthDate = DateTime.tryParse(birthDateStr);
            if (birthDate == null) {
              return const Center(child: Text('Invalid birth date in profile.'));
            }

            final ageMY = formatAge(birthDate); // e.g., "3 years"

            if (profile.isEmpty) {
              return Center(child: Text('No user profiles found.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile card at the top
                  ProfileCard(
                    firstName: profile['firstName'] ?? '',
                    lastName: profile['lastName'] ?? '',
                    age: ageMY,
                    numericAge: ageYears,
                    gender: profile['gender'] ?? '',
                    height: profile['height'] ?? '',
                    weight: profile['weight'] ?? '',
                    muac: (profile['muac']?.isNotEmpty == true) ? profile['muac'] : null,
                    bottom: EditProfileButton(
                      onEdited: () => setState(() {}), // Refresh UI when profile is edited
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Display different cards depending on age
                  (ageYears < 5)
                    ? const Column(
                        children: [
                          ChildNutritionCard(),
                          DiaryCard(),
                        ],
                      )
                    : const Column(
                        children: [
                          BMICard(),
                          CaloricRequirementCard(),
                          DiaryCard(),
                          WeeklyCaloriesChartCard(),
                          WeeklyCaloriesDeltaChartCard(),
                          DistanceCard(),
                          DiscountCard(),
                          SizedBox(height: 30),
                          MapCard(),
                        ],
                      ),
                ],
              ),
            );
          },
        ),
      ),

      // Floating action button with cart icon and badge showing item count
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, _) {
          final totalItems = cart.products.length + (cart.discount > 0 ? 1 : 0);

          return Stack(
            children: [
              FloatingActionButton(
                backgroundColor: const Color(0xFF3E5F8A),
                foregroundColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
                child: const Icon(Icons.shopping_cart_checkout),
              ),

              // Badge showing number of items in cart
              if (totalItems > 0)
                Positioned(
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$totalItems',
                      style: const TextStyle(
                        color: Color(0xFF3E5F8A),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
