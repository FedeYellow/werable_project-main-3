import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CART/ProviderCart.dart';
import 'package:werable_project/VENDITORE/ProductModel.dart';
import 'package:werable_project/VENDITORE/ShopperModel.dart';


class ShopperPage extends StatelessWidget {
  final Shopper shopper;

  const ShopperPage({super.key, required this.shopper});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(shopper.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.underline, decorationColor: Colors.white),),
        backgroundColor: Color(0xFF3E5F8A),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: shopper.products.length,
          itemBuilder: (context, index) {
            final product = shopper.products[index];

            return Card(
              color: Colors.grey[100],
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.fastfood),
                title: Text(product.name,style: TextStyle(fontWeight: FontWeight.bold), ),
                subtitle: Text('Expiration: ${product.expiry}\nPrize: €${product.price}\nCalories: ${product.calories} kcal'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    final productWithShop = Product(
                      name: product.name,
                      price: product.price,
                      expiry: product.expiry,
                      shopperName: shopper.name,
                      calories: product.calories,
                    );
                    cart.add(productWithShop);
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
