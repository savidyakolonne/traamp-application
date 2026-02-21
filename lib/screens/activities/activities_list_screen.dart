import 'package:flutter/material.dart';
import '../../services/activities_service.dart';
import '../../widgets/activity_tile.dart';

class ActivitiesListScreen extends StatefulWidget {
  @override
  State<ActivitiesListScreen> createState() => _ActivitiesListScreenState();
}

class _ActivitiesListScreenState extends State<ActivitiesListScreen> {
  String search = "";

  final Color primaryGreen = const Color(0xFF7DC06C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5F7),

      // ✅ MATCHING GREEN APP BAR
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Activities",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),

      body: Column(
        children: [
          // ✅ MATCHING SEARCH FIELD
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

          // ✅ MATCHING LIST STYLE
          Expanded(
            child: FutureBuilder(
              future: ActivitiesService.getActivities(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                final activities = snapshot.data!
                    .where(
                      (p) =>
                          p.name.toLowerCase().contains(search) ||
                          p.district.toLowerCase().contains(search) ||
                          p.keywords.join(" ").toLowerCase().contains(search),
                    )
                    .toList();

                if (activities.isEmpty) {
                  return const Center(
                    child: Text(
                      "No activities found",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: activities.length,
                  itemBuilder: (_, i) => ActivityTile(activity: activities[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
