import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../screens/activities/activity_detail_screen.dart';

class ActivityTile extends StatelessWidget {
  final Activity activity;

  const ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(activity.coverImage, width: 60, fit: BoxFit.cover),
      title: Text(activity.name),
      subtitle: Text("${activity.district} • ${activity.category}"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ActivityDetailScreen(activityId: activity.id),
          ),
        );
      },
    );
  }
}
