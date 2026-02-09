import 'package:flutter/material.dart';
import '../../services/places_service.dart';

class PlaceDetailScreen extends StatelessWidget {
  final String placeId;
  const PlaceDetailScreen({required this.placeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: PlacesService.getPlaceById(placeId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final place = snapshot.data!;

          return ListView(
            children: [
              // ---------- IMAGE SLIDER ----------
              SizedBox(
                height: 220,
                child: PageView(
                  children: place.images
                      .map<Widget>((img) => Image.network(img, fit: BoxFit.cover))
                      .toList(),
                ),
              ),

              // ---------- DETAILS ----------
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(place.description),
                    const SizedBox(height: 10),
                    Text("📍 ${place.district}, ${place.province}",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),

                    // ---------- ACTIVITIES ----------
                    if (place.activities != null && place.activities!.isNotEmpty)
                      ...[
                        const Text("🛶 Activities",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ...place.activities!.entries.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text("• ${e.value}"),
                        )),
                        const SizedBox(height: 20),
                      ],

                    // ---------- BEST TIME TO VISIT ----------
                    if (place.bestTimeToVisit != null)
                      ...[
                        const Text("🌱 Best Time to Visit",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                            "Season Note: ${place.bestTimeToVisit!['seasonNote'] ?? 'Not available'}"),
                        Text(
                            "Best Hours: ${place.bestTimeToVisit!['timeOfDayNote'] ?? 'Not available'}"),
                        const SizedBox(height: 20),
                      ],

                    // ---------- VISITING HOURS ----------
                    if (place.visitingHours != null)
                      ...[
                        const Text("⏰ Visiting Hours",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                            "Time: ${place.visitingHours!['daily'] ?? 'Not available'}"),
                        Text(
                            "Note: ${place.visitingHours!['note'] ?? 'Not available'}"),
                        const SizedBox(height: 20),
                      ],
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
