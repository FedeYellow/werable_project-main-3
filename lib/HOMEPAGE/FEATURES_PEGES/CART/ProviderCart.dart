import 'package:flutter/material.dart';
import 'package:werable_project/VENDITORE/ProductModel.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class CartProvider extends ChangeNotifier {
  final List<Product> _products = [];
  double _discount = 0.0;

  List<Product> get products => _products;
  double get discount => _discount;

  void setDiscount(double discountAmount, String profileName) {
    _discount = discountAmount;
    saveCartToPrefs(profileName);
    notifyListeners();
  }

  void add(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  double get total {
    final productsTotal = _products.fold(0.0, (double sum, item) => sum + double.parse(item.price)); // total prize without discount
    final discountedTotal = productsTotal - _discount;
    return discountedTotal;
  }

  int get totalCalories {
  return _products.fold(0, (sum, item) => sum + item.calories);
  }
   
  Future<void> clear() async {
    _products.clear();
    _discount = 0.0;
    final cartPrefs = await SharedPreferences.getInstance();
    await cartPrefs.remove('cartData'); // solo borro la data del carrito
    notifyListeners();
  }

  // guardar carrito + usuario en SharedPreferences
  Future<void> saveCartToPrefs(String profileName) async {
    final cartPrefs = await SharedPreferences.getInstance();

    // convierte cada producto en un mapa (json) - sharedpreferences no sabe guardar lo otro
    final productsJson = _products.map((p) => p.toJson()).toList();
    
    final cartData = jsonEncode({
      'products': productsJson,
      'discount': _discount,
      'profile': profileName,
    });

    await cartPrefs.setString('cartData', cartData);
  }

  // cargar carrito desde SharedPreferences
  Future<void> loadCartFromPrefs(String currentProfileName) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonStr = prefs.getString('cartData');

  if (jsonStr != null) {
    final data = jsonDecode(jsonStr);
    final savedProfile = data['profile'] ?? '';

    // ✅ Cancella il carrello se l'utente è cambiato
    if (savedProfile != currentProfileName) {
      await clear(); // importante usare await per attendere la rimozione
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
