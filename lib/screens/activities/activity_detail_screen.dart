import 'package:flutter/material.dart';
import '../../models/activity_model.dart';
import '../../services/activities_service.dart';

class ActivityDetailScreen extends StatelessWidget {
  final String activityId;
  const ActivityDetailScreen({required this.activityId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Activity Details"), centerTitle: true),
      body: FutureBuilder(
        future: ActivitiesService.getActivityById(activityId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final Activity activity = snapshot.data!;

          return ListView(
            children: [
              // ---------- IMAGE SLIDER ----------
              SizedBox(
                height: 220,
                child: PageView(
                  children: activity.images
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

              // ---------- ACTIVITY NAME ----------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  activity.name,
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
              if (activity.shortDesc != null && activity.shortDesc!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    color: Colors.green[50],
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        activity.shortDesc!,
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
                  activity.description,
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
                        "${activity.district}, ${activity.province}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ---------- BEST TIME ----------
              if (activity.bestTime != null)
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
                            "🌱 Best Time",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Season Note: ${activity.bestTime!['seasonNote'] ?? 'Not available'}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Best Hours: ${activity.bestTime!['timeOfDayNote'] ?? 'Not available'}",
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
