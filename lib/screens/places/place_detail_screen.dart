import 'package:flutter/material.dart';
import '../../models/place_model.dart';
import '../../services/places_service.dart';

class PlaceDetailScreen extends StatelessWidget {
  final String placeId;
  const PlaceDetailScreen({required this.placeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Place Details"), centerTitle: true),
      body: FutureBuilder(
        future: PlacesService.getPlaceById(placeId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final Place place = snapshot.data!;

          return ListView(
            children: [
              // ---------- IMAGE SLIDER ----------
              SizedBox(
                height: 220,
                child: PageView(
                  children: place.images
                      .map<Widget>(
                        (img) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            img,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),

              // ---------- PLACE NAME ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  place.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ---------- SHORT DESCRIPTION ----------
              if (place.shortDesc != null && place.shortDesc!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    color: Colors.green[50],
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        place.shortDesc!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              // ---------- FULL DESCRIPTION ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  place.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),

              // ---------- LOCATION ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 20, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${place.district}, ${place.province}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ---------- ACTIVITIES ----------
              if (place.activities != null && place.activities!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "🛶 Activities",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...place.activities!.entries.map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                "• ${e.value}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              // ---------- BEST TIME TO VISIT ----------
              if (place.bestTimeToVisit != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    color: Colors.orange[50],
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "🌱 Best Time to Visit",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Season Note: ${place.bestTimeToVisit!['seasonNote'] ?? 'Not available'}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Best Hours: ${place.bestTimeToVisit!['timeOfDayNote'] ?? 'Not available'}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              // ---------- VISITING HOURS ----------
              if (place.visitingHours != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    color: Colors.blue[50],
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "⏰ Visiting Hours",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Time: ${place.visitingHours!['daily'] ?? 'Not available'}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Note: ${place.visitingHours!['note'] ?? 'Not available'}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
