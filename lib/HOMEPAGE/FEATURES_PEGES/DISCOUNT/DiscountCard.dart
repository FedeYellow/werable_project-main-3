import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CART/ProviderCart.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISTANCE/DistanceProvider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISTANCE/DistanceData.dart';
import 'package:intl/intl.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISCOUNT/DiscountDialogs.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/PROFILE_CARD/profile_cards.dart';

// This widget shows a visual representation of how many steps the user took yesterday,
// and calculates a potential discount based on that. The user can then apply that
// discount to their cart using the "Apply Discount" button.

class DiscountCard extends StatefulWidget {
  const DiscountCard({super.key});

  @override
  State<DiscountCard> createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  double totalDiscount = 0.0; // The discount the user can apply today

  @override
  void initState() {
    super.initState();
    _fetchDistanceData(); // Load steps data from yesterday
  }

  // Loads yesterday's step data from the provider and calculates discount
  void _fetchDistanceData() {
    final provider = Provider.of<DistanceProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);

    final ieri = DateTime.now().subtract(const Duration(days: 1));
    final dayString = DateFormat('yyyy-MM-dd').format(ieri);

    provider.fetchData(dayString).then((_) {
      final steps = _calcolaDistanzaTotale(provider.distances);
      final discountPer5k = 0.25;
      final stepsPerDiscount = 5000;

      double calculatedDiscount = ((steps ~/ stepsPerDiscount) * discountPer5k);

      setState(() {
        // If a discount is already applied in the cart, don't double it
        totalDiscount = cart.discount > 0 ? 0.0 : calculatedDiscount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final distanceList = context.watch<DistanceProvider>().distances;
    final totalSteps = _calcolaDistanzaTotale(distanceList);

    const discountPer5k = 0.25;

    // Determine relative progress bar position for the arrow
    final progressRatio = totalSteps / 40000;
    final progressRatioClamped = progressRatio.clamp(0.0, 1.0); // limit max to 100%

    return Card(
      margin: const EdgeInsets.all(12),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Steps Discount',
              style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            // Custom progress bar with scale and arrow
            Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final lineWidth = constraints.maxWidth;
                    final progressPosition = progressRatioClamped * lineWidth;

                    return SizedBox(
                      height: 70,
                      child: Stack(
                        children: [
                          // Horizontal line representing the scale
                          Positioned(
                            top: 30,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 4,
                              color: const Color(0xFF3E5F8A),
                            ),
                          ),

                          // Step markers with discount labels
                          Positioned(
                            top: 30,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(9, (index) {
                                return Column(
                                  children: [
                                    Container(width: 2, height: 12, color: Colors.black),
                                    Text(
                                      '${(index * 5000)}\n€${(index * discountPer5k).toStringAsFixed(2)}',
                                      style: const TextStyle(color: Color(0xFF3E5F8A), fontSize: 10),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                );
                              }),
                            ),
                          ),

                          // Arrow showing user's current progress
                          Positioned(
                            top: 10,
                            left: progressPosition - 12, // offset to center the arrow
                            child: const Icon(Icons.arrow_drop_down, size: 24, color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Discount label and Apply button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total discount:  €${totalDiscount.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final cart = Provider.of<CartProvider>(context, listen: false);
                    if (totalDiscount > 0) {
                      final profile = await ProfileCard.loadProfile();
                      final profileName = profile['firstName'] ?? '';
                      cart.setDiscount(totalDiscount, profileName); // apply and save discount
                      DiscountDialogs.showDiscountApplied(context, totalDiscount);
                      setState(() {
                        totalDiscount = 0.0; // Reset after applying
                      });
                    } else {
                      DiscountDialogs.showNoDiscountAvailable(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E5F8A),
                  ),
                  child: const Text(
                    'Apply Discount',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Calculates the total number of steps from a list of Distancedata
  int _calcolaDistanzaTotale(List<Distancedata> lista) {
    return lista.fold(0, (sum, item) => sum + item.value);
  }
}
