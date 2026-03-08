import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotificationNewPackageTile extends StatefulWidget {
  bool isUnread;
  final String packageTitle;
  NotificationNewPackageTile(this.isUnread, this.packageTitle, {super.key});

  @override
  State<NotificationNewPackageTile> createState() =>
      _NotificationNewPackageTileState();
}

class _NotificationNewPackageTileState
    extends State<NotificationNewPackageTile> {
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
                color: const Color.fromARGB(255, 219, 234, 254),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(Icons.archive_outlined, color: Colors.blue),
            ),
            // info
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New Package Added",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'You have successfully created a new package named "${widget.packageTitle}".',
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
                color: const Color.fromARGB(255, 219, 234, 254),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(Icons.archive_outlined, color: Colors.blue),
            ),
            // info
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New Package Added",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'You have successfully created a new package named "Sigiriya".',
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
