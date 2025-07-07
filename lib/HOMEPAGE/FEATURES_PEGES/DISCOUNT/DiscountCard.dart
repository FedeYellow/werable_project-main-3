import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CART/ProviderCart.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISTANCE/DistanceProvider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISTANCE/DistanceData.dart';
import 'package:intl/intl.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISCOUNT/DiscountDialogs.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/PROFILE_CARD/profile_cards.dart';

class DiscountCard extends StatefulWidget {
  const DiscountCard({super.key});

  @override
  State<DiscountCard> createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {

  double totalDiscount = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchDistanceData();
  }

  void _fetchDistanceData() {
    final provider = Provider.of<DistanceProvider>(context, listen: false); // utilizo el distance provider que ya tengo
    final cart = Provider.of<CartProvider>(context, listen: false); // para ver si hay descuento en el card y ponerlo a 0
    final ieri = DateTime.now().subtract(const Duration(days: 1));
    final dayString = DateFormat('yyyy-MM-dd').format(ieri);

    provider.fetchData(dayString).then((_) { // lo pongo aqui arriba para que no se haga todo el rato en el built
      final steps = _calcolaDistanzaTotale(provider.distances);
      final discountPer5k = 0.25;
      final stepsPerDiscount = 5000;

      double calculatedDiscount = ((steps ~/ stepsPerDiscount) * discountPer5k);

      setState(() {
        // si ya hay descuento en el carrito - totalDiscount = 0
        totalDiscount = cart.discount > 0 ? 0.0 : calculatedDiscount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final distanceList = context.watch<DistanceProvider>().distances;
    final totalSteps = _calcolaDistanzaTotale(distanceList);

    const discountPer5k = 0.25; // lo necesito de nuevo para crear las rayitas
    
    // para la flechita, calculamos la posición relativa
    final progressRatio = totalSteps / 40000; // por ejemplo, max 50.000 pasos en el eje
    final progressRatioClamped = progressRatio.clamp(0.0, 1.0); // para que la flechita no se pase del límite del eje

    return Card(
      margin: const EdgeInsets.all(12),
      color:Colors.grey[100],
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

            Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final lineWidth = constraints.maxWidth; // ancho real del eje
                    final progressPosition = progressRatioClamped * lineWidth;

                    return SizedBox(
                      height: 70, // da altura al Stack para que la flecha no se pierda
                      child: Stack(
                        children: [
                          // la línea la bajo un poco para dejar sitio a la flecha
                          Positioned(
                            top: 30,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 4,
                              color: Color(0xFF3E5F8A),
                            ),
                        
                          ),
                          // las marcas
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
                          // flechita colocada arriba de la raya
                          Positioned(
                            top: 10, // más arriba, claramente visible
                            left: progressPosition - 12,
                            child: Icon(Icons.arrow_drop_down, size: 24, color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                    final cart = Provider.of<CartProvider>(context, listen: false); // listen: false - no quiero que el widget se modifica
                    if (totalDiscount > 0) {
                      final profile = await ProfileCard.loadProfile();
                      final profileName = profile['firstName'] ?? '';
                      cart.setDiscount(totalDiscount, profileName);
                      DiscountDialogs.showDiscountApplied(context, totalDiscount);
                      setState(() {
                        totalDiscount = 0.0;
                      });
                    } else {
                      DiscountDialogs.showNoDiscountAvailable(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3E5F8A),
                  ),
                  child: const Text('Apply Discount', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Calculo todos los pasos hechos ayer
  int _calcolaDistanzaTotale(List<Distancedata> lista) {
    int totalSteps = lista.fold(0, (suma, item) => suma + item.value);
    return totalSteps;
  }
}
