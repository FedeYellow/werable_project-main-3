import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:werable_project/VENDITORE/ShopperData.dart';
import 'package:werable_project/VENDITORE/ShopperPage.dart';


class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Map', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.underline, decorationColor: Colors.white),),
        backgroundColor: Color(0xFF3E5F8A),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(45.4064, 11.8768), // Centro Padova
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: shoppers.map((shopper) {
              return Marker(
                point: shopper.location,
                width: 60,
                height: 60,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: Colors.grey[100],
                        title: Text(shopper.name),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(child: Text(shopper.address)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.phone, color: Colors.green),
                                const SizedBox(width: 8),
                                Text(shopper.phone),
                              ],
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ShopperPage(shopper: shopper),
                                  ),
                                );
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.list_alt, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('See products'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3E5F8A),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                            ),
                            
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      shopper.name[0], // Iniziale dello shop
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
