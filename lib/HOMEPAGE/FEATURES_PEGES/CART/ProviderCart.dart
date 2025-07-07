import 'package:flutter/material.dart';
import 'package:werable_project/VENDITORE/ProductModel.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// This provider manages the shopping cart state, including:
// - list of selected products
// - applied discount
// - total price and total calories
// - saving/loading cart to/from SharedPreferences (per user)

class CartProvider extends ChangeNotifier {
  final List<Product> _products = [];  // Current products in the cart
  double _discount = 0.0;              // Applied discount on the cart

  List<Product> get products => _products;
  double get discount => _discount;

  /// Sets the discount and saves the updated cart for the current user
  void setDiscount(double discountAmount, String profileName) {
    _discount = discountAmount;
    saveCartToPrefs(profileName); // Save the updated discount
    notifyListeners();
  }

  /// Adds a product to the cart
  void add(Product product) {
    _products.add(product);
    notifyListeners();
  }

  /// Removes a product from the cart
  void remove(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  /// Calculates the total price after applying the discount
  double get total {
    final productsTotal = _products.fold(
      0.0,
      (double sum, item) => sum + double.parse(item.price), // price is stored as String
    );
    final discountedTotal = productsTotal - _discount;
    return discountedTotal;
  }

  /// Calculates the total calories from all products in the cart
  int get totalCalories {
    return _products.fold(0, (sum, item) => sum + item.calories);
  }

  /// Clears the cart and discount, and removes it from SharedPreferences
  Future<void> clear() async {
    _products.clear();
    _discount = 0.0;
    final cartPrefs = await SharedPreferences.getInstance();
    await cartPrefs.remove('cartData'); // Only remove the cart data, not user info
    notifyListeners();
  }

  /// Saves the current cart to SharedPreferences, associated with a profile name
  Future<void> saveCartToPrefs(String profileName) async {
    final cartPrefs = await SharedPreferences.getInstance();

    // Convert each product to JSON format
    final productsJson = _products.map((p) => p.toJson()).toList();

    final cartData = jsonEncode({
      'products': productsJson,
      'discount': _discount,
      'profile': profileName,
    });

    await cartPrefs.setString('cartData', cartData);
  }

  /// Loads the cart from SharedPreferences for the current user
  Future<void> loadCartFromPrefs(String currentProfileName) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('cartData');

    if (jsonStr != null) {
      final data = jsonDecode(jsonStr);
      final savedProfile = data['profile'] ?? '';

      // If the cart was saved under a different profile, clear it
      if (savedProfile != currentProfileName) {
        await clear(); // Important to wait for the clear operation to finish
        return;
      }

      final productsList = data['products'] as List;
      _products.clear();
      _products.addAll(productsList.map((p) => Product.fromJson(p)).toList());

      _discount = data['discount'] ?? 0.0;

      notifyListeners();
    }
  }
}
