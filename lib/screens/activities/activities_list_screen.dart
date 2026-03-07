import 'package:flutter/material.dart';
import '../../services/activities_service.dart';
import '../../widgets/activity_tile.dart';

class ActivitiesListScreen extends StatefulWidget {
  @override
  State<ActivitiesListScreen> createState() => _ActivitiesListScreenState();
}

class _ActivitiesListScreenState extends State<ActivitiesListScreen> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🔙 Back + Title (Same style as Places)
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
                        "Activities",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔍 Rounded Search Bar
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
                  decoration: InputDecoration(
                    hintText: "Search by name, location, keyword",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.tune_rounded),
                      onPressed: () {},
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onChanged: (v) => setState(() => search = v.toLowerCase()),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 📋 Activities List (Logic unchanged)
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: activities.length,
                    itemBuilder: (_, i) =>
                        ActivityTile(activity: activities[i]),
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
