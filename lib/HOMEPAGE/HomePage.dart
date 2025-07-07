import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/BMI/BMImodel.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesCard.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    // cargamos el carrito del usuario al abrir la Home
    Future.microtask(() async {
      final profile = await ProfileCard.loadProfile();
      final profileName = profile['firstName'] ?? '';
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.loadCartFromPrefs(profileName);
    });
  }

  Future<void> _logout(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('access');
    await sp.remove('refresh');

    // limpiar el carrito
    // Provider.of<CartProvider>(context, listen: false).clear();

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
        title: const Text('Homepage', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.underline, decorationColor: Colors.white)),
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
        color: Colors.grey[200], // color de fondo del body
        child: FutureBuilder<Map<String, String>>(
          future: ProfileCard.loadProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            final profile = snapshot.data ?? {};

            final ageYears = int.tryParse(profile['age'] ?? '0') ?? 0;

            // To put profile_card in months/years
            final birthDateStr = profile['birthDate'];

            // añado esto para que no explote si hay birthdate null - probando lo de la pantalla roja
              if (birthDateStr == null) {
                return const Center(child: Text('No profile data found. Please register.'));
              }
              final birthDate = DateTime.tryParse(birthDateStr);
              if (birthDate == null) {
                return const Center(child: Text('Invalid birth date in profile.'));
              }

            //final birthDate = DateTime.parse(birthDateStr!);
            final ageMY = formatAge(birthDate); // age in months or years

            if (profile.isEmpty) {
              return Center(child: Text('No user profiles found.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ProfileCard(
                    firstName: profile['firstName'] ?? '',
                    lastName: profile['lastName'] ?? '',
                    //age: profile['age'] ?? '',
                    age: ageMY, // x years / x months - cadena
                    numericAge: ageYears, // only the number
                    gender: profile['gender'] ?? '',
                    height: profile['height'] ?? '',
                    weight: profile['weight'] ?? '', 
                    muac: (profile['muac']?.isNotEmpty == true) ? profile['muac'] : null, // solo se pasa cuando se cumple el if en profilecard 
                    // - me aseguro de convertir cadenas vacías "" en null antes de pasarlas al widget
                    bottom: EditProfileButton(
                      onEdited: () => setState(() {}),
                    ),
                  ),
                
                  const SizedBox(height: 30), //Map Card
                  MapCard(),

                  const SizedBox(height: 20),
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
                        DistanceCard(),
                        DiscountCard(),
                        CaloricRequirementCard(),
                        WeeklyCaloriesChartCard(),
                        WeeklyCaloriesDeltaChartCard(),
                        DiaryCard(),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),

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
                        color:Color(0xFF3E5F8A),
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
