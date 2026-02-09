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
      appBar: AppBar(title: const Text("Activities")),
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
              future: ActivitiesService.getActivities(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                }

                final activities = snapshot.data!
                    .where((p) =>
                p.name.toLowerCase().contains(search) ||
                    p.district.toLowerCase().contains(search) ||
                    p.keywords.join(" ").toLowerCase().contains(search))
                    .toList();

                return ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (_, i) => ActivityTile(activity: activities[i]),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
