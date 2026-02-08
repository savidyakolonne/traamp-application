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
            return const Center(child: CircularProgressIndicator());
          }

          final activity = snapshot.data!;

          return ListView(
            children: [
              SizedBox(
                height: 220,
                child: PageView(
                  children: activity.images
                      .map<Widget>((img) => Image.network(img, fit: BoxFit.cover))
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activity.name, style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 8),
                    Text(activity.description),
                    const SizedBox(height: 10),
                    Text("📍 ${activity.district}, ${activity.province}"),
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
