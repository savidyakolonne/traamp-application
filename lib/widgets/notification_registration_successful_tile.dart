import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotificationRegistrationSuccessfulTile extends StatefulWidget {
  bool isUnread;
  NotificationRegistrationSuccessfulTile(this.isUnread, {super.key});

  @override
  State<NotificationRegistrationSuccessfulTile> createState() =>
      _NotificationRegistrationSuccessfulTileState();
}

class _NotificationRegistrationSuccessfulTileState
    extends State<NotificationRegistrationSuccessfulTile> {
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
                color: const Color.fromARGB(83, 125, 212, 33),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(Icons.person_2_outlined, color: Colors.green),
            ),
            // info
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text(
                    "Registration Successful",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "Congratulations! You have successfully registered as a user.",
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
                "NOW",
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
                color: const Color.fromARGB(83, 125, 212, 33),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(Icons.person_2_outlined, color: Colors.green),
            ),
            // info
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text(
                    "Registration Successful",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "Congratulations! You have successfully registered as a user.",
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
