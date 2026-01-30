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
            return const Center(child: CircularProgressIndicator());
          }

          final place = snapshot.data!;

          return ListView(
            children: [
              SizedBox(
                height: 220,
                child: PageView(
                  children: place.images
                      .map<Widget>((img) => Image.network(img, fit: BoxFit.cover))
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name, style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 8),
                    Text(place.description),
                    const SizedBox(height: 10),
                    Text("📍 ${place.district}, ${place.province}"),
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
