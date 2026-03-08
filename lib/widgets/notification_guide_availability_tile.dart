import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotificationGuideAvailabilityTile extends StatefulWidget {
  bool isUnread;
  String status;
  NotificationGuideAvailabilityTile(this.isUnread, this.status, {super.key});

  @override
  State<NotificationGuideAvailabilityTile> createState() =>
      _NotificationGuideAvailabilityTileState();
}

class _NotificationGuideAvailabilityTileState
    extends State<NotificationGuideAvailabilityTile> {
  @override
  Widget build(BuildContext context) {
    // if notification not read
    if (widget.isUnread) {
      return Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(32, 125, 212, 33),
          border: Border(
            left: BorderSide(
              color: const Color.fromARGB(255, 125, 212, 33),
              width: 5,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10,
          children: [
            // icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 254, 243, 199),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.warning_amber,
                color: const Color.fromARGB(255, 217, 119, 6),
              ),
            ),
            // info
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Availability Status Changed.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'You are currently ${widget.status}.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            // time
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(83, 125, 212, 33),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                "2h ago",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // if notification already read
      return Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10,
          children: [
            // icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 254, 243, 199),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.warning_amber,
                color: const Color.fromARGB(255, 217, 119, 6),
              ),
            ),
            // info
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Availability Status Changed.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'You are currently not available.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            // time
            Text("2h ago", style: TextStyle(fontSize: 12)),
          ],
        ),
      );
    }
  }
}
