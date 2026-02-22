import 'package:flutter/material.dart';
import '../../services/places_service.dart';
import '../../widgets/place_tile.dart';

class PlacesListScreen extends StatefulWidget {
  @override
  State<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  String search = "";

  final Color primaryGreen = const Color(0xFF7DC06C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5F7),

      // ✅ COLORED APP BAR
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Places",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),

      body: Column(
        children: [
          // ✅ STYLED SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by name, location, keyword",
                prefixIcon: Icon(Icons.search, color: primaryGreen),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: primaryGreen, width: 2),
                ),
              ),
              onChanged: (v) => setState(() => search = v.toLowerCase()),
            ),
          ),

          // ✅ LIST
          Expanded(
            child: FutureBuilder(
              future: PlacesService.getPlaces(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                final places = snapshot.data!
                    .where(
                      (p) =>
                          p.name.toLowerCase().contains(search) ||
                          p.district.toLowerCase().contains(search) ||
                          p.keywords.join(" ").toLowerCase().contains(search),
                    )
                    .toList();

                if (places.isEmpty) {
                  return const Center(
                    child: Text(
                      "No places found",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: places.length,
                  itemBuilder: (_, i) => PlaceTile(place: places[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
