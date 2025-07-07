import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CART/ProviderCart.dart';
import 'package:werable_project/VENDITORE/ProductModel.dart';
import 'package:werable_project/VENDITORE/ShopperModel.dart';

/// A page displaying a list of products offered by a specific [Shopper].
/// Users can add products to their cart directly from this screen.
class ShopperPage extends StatelessWidget {
  final Shopper shopper;

  const ShopperPage({super.key, required this.shopper});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false); // Access cart provider (no rebuild on change)

    return Scaffold(
      appBar: AppBar(
        title: Text(
          shopper.name,
          style: const TextStyle(
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
        color: Colors.grey[200], // Background color
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: shopper.products.length, // Number of products
          itemBuilder: (context, index) {
            final product = shopper.products[index];

            return Card(
              color: Colors.grey[100],
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.fastfood), // Product icon
                title: Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Expiration: ${product.expiry}\n'
                  'Prize: €${product.price}\n'
                  'Calories: ${product.calories} kcal',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    // Add a new product with attached shopper info
                    final productWithShop = Product(
                      name: product.name,
                      price: product.price,
                      expiry: product.expiry,
                      shopperName: shopper.name,
                      calories: product.calories,
                    );

                    // Add product to cart
                    cart.add(productWithShop);

                    // Show feedback to user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} added to the cart')),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
