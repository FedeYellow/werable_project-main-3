import 'package:flutter/material.dart';

class DiscountDialogs {
  /// Muestra un diálogo de éxito cuando se aplica un descuento válido (> 0)
  static void showDiscountApplied(BuildContext context, double discountAmount) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: const Text(
            'Discount Applied',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A discount of ${discountAmount.toStringAsFixed(2)} € has been applied to your cart.', 
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('This discount was achieved thanks to your steps from yesterday. It is valid only for today and therefore it cannot be accumulated for other days.')
            ],
          ),

          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E5F8A),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 14),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        );
      },
    );
  }

  /// Muestra un diálogo informando que no hay descuentos
  static void showNoDiscountAvailable(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: const Text(
            'No Discounts Available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: const Text('There are no discounts available for today.'),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E5F8A),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 14),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        );
      },
    );
  }
}
