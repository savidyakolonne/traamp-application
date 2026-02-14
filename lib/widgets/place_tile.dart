import 'package:flutter/material.dart';
import '../models/place_model.dart';
import '../screens/places/place_detail_screen.dart';

class PlaceTile extends StatelessWidget {
  final Place place;

  const PlaceTile({required this.place});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(place.coverImage, width: 60, fit: BoxFit.cover),
      title: Text(place.name),
      subtitle: Text("${place.district} • ${place.category}"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaceDetailScreen(placeId: place.id),
          ),
        );
      },
    );
  }
}
