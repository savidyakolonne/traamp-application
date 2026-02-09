import 'package:flutter/material.dart';
import '../../services/places_service.dart';
import '../../widgets/place_tile.dart';

class PlacesListScreen extends StatefulWidget {
  @override
  State<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Places")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by name, location, keyword",
              ),
              onChanged: (v) => setState(() => search = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: PlacesService.getPlaces(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                }

                final places = snapshot.data!
                    .where((p) =>
                p.name.toLowerCase().contains(search) ||
                    p.district.toLowerCase().contains(search) ||
                    p.keywords.join(" ").toLowerCase().contains(search))
                    .toList();

                return ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (_, i) => PlaceTile(place: places[i]),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
