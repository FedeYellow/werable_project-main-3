import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/MAP/Map_const.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/MAP/Map.dart';
import 'package:werable_project/VENDITORE/ShopperData.dart';

/// A card widget showing a mini map preview with markers for available shopper locations.
/// Includes a button to open the full map page.
class MapCard extends StatelessWidget {
  const MapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section showing the number of available stops (shoppers)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(Icons.store, color: Colors.black87),
                const SizedBox(width: 8),
                Text(
                  '${shoppers.length} stops available',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Map section inside a stack with a floating button to open the full map
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                // Map widget with markers
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    options: MapOptions(
                      center: defaultMapCenter, // Initial map center
                      zoom: 14.0,
                    ),
                    children: [
                      // Base map tile layer
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.app',
                      ),

                      // Marker layer using shopper locations
                      MarkerLayer(
                        markers: shoppers.map((shopper) {
                          return Marker(
                            point: shopper.location,
                            width: 20,
                            height: 20,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // Button to navigate to full map page
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E5F8A),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to full-screen map
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MapPage()),
                      );
                    },
                    icon: const Icon(Icons.map, color: Colors.white),
                    label: const Text(
                      "Open map",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
