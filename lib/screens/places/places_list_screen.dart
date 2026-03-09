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
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🔙 Back + Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Places",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // balance center
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔍 Rounded Search Bar with Filter Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: TextField(
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    hintText: "Search by name, location, keyword",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search),

                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onChanged: (v) => setState(() => search = v.toLowerCase()),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 📍 List Section (Same Logic)
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: places.length,
                    itemBuilder: (_, i) => PlaceTile(place: places[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
