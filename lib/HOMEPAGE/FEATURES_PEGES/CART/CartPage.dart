import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CART/ProviderCart.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/PROFILE_CARD/profile_cards.dart';

// This screen displays the user's cart.
// It shows a list of products added to the cart, any applied discounts, and the total price and calories.
// Users can remove items, and updates are saved in SharedPreferences.

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context); // Access the cart state

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your cart',
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
            Expanded(
              child: cart.products.isEmpty
                // If cart is empty but there's a discount applied, show it
                ? (cart.discount > 0
                  ? ListView(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.local_offer, color: Colors.black),
                          title: const Text(
                            'Discount applied',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '-€${cart.discount.toStringAsFixed(2)} applied to total',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    )
                  // If cart is empty and no discount, show a message
                  : const Center(child: Text('Your cart is empty')))
            
                // Otherwise show the list of products + discount item if applicable
                : ListView.builder(
                    itemCount: cart.products.length + (cart.discount > 0 ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < cart.products.length) {
                        final product = cart.products[index];
                        return ListTile(
                          leading: const Icon(Icons.shopping_cart, color: Colors.black),
                          title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Prize: €${product.price} - Seller: ${product.shopperName ?? "?"}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Expires: ${product.expiry}'),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  // Remove product from cart
                                  cart.remove(product);
                                  // Save updated cart in SharedPreferences
                                  final profile = await ProfileCard.loadProfile();
                                  final profileName = profile['firstName'] ?? '';
                                  cart.saveCartToPrefs(profileName);
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Show discount info as a separate item at the bottom
                        return ListTile(
                          leading: const Icon(Icons.local_offer, color: Colors.black),
                          title: const Text(
                            'Discount applied',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '-€${cart.discount.toStringAsFixed(2)} applied to total',
                            style: const TextStyle(color: Colors.green),
                          ),
                        );
                      }
                    },
                  ),
            ),

            // Display total price and total calories
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total: €${cart.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    'Calories: ${cart.totalCalories} kcal',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
