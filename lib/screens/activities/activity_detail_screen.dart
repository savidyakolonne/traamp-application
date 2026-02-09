import 'package:flutter/material.dart';
import '../../services/activities_service.dart';

class ActivityDetailScreen extends StatelessWidget {
  final String activityId;
  const ActivityDetailScreen({required this.activityId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: ActivitiesService.getActivityById(activityId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final activity = snapshot.data!;

          return ListView(
            children: [
              // ----------- IMAGES SLIDER ----------
              SizedBox(
                height: 220,
                child: PageView(
                  children: activity.images
                      .map<Widget>(
                        (img) => Image.network(img, fit: BoxFit.cover),
                  )
                      .toList(),
                ),
              ),

              // ----------- DETAILS SECTION ----------
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Activity Name
                    Text(
                      activity.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(activity.description),
                    const SizedBox(height: 10),

                    // Location
                    Text(
                      "📍 ${activity.district}, ${activity.province}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),

                    // ---------------- NEW FIELDS ----------------
                    if (activity.bestTime != null) ...[
                      // Season Note
                      const Text(
                        "🌱 Season Note",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(activity.bestTime!['seasonNote'] ?? "Not available"),
                      const SizedBox(height: 16),

                      // Best Hours
                      const Text(
                        "⏰ Best Hours",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                          activity.bestTime!['timeOfDayNote'] ?? "Not available"),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
