import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotificationPackageRemovedTile extends StatefulWidget {
  bool isUnread;
  final String packageTitle;
  final Map<dynamic, dynamic> date;
  NotificationPackageRemovedTile(
    this.isUnread,
    this.packageTitle,
    this.date, {
    super.key,
  });

  @override
  State<NotificationPackageRemovedTile> createState() =>
      _NotificationPackageRemovedTileState();
}

class _NotificationPackageRemovedTileState
    extends State<NotificationPackageRemovedTile> {
  String timeInString = "";

  void setupDateTime() {
    int secondsFirestore = widget.date['_seconds'];
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(
      secondsFirestore * 1000 + 737,
    );
    DateTime firestoreTime = DateTime.parse(dt.toString());
    DateTime now = DateTime.now().toUtc();
    Duration diff = now.difference(firestoreTime);
    int time = diff.inSeconds;

    setState(() {
      if (time > 2592000) {
        int temp = (time / 2592000).floor();
        timeInString = "$temp mon ago";
      } else if (time > 86400) {
        int temp = (time / 86400).floor();
        timeInString = "${temp}d ago";
      } else if (time > 3600) {
        int temp = (time / 3600).floor();
        timeInString = "${temp}h ago";
      } else if (time > 60) {
        int temp = (time / 60).floor();
        timeInString = "$temp mins ago";
      } else {
        timeInString = "NOW";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setupDateTime();
  }

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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 20,
            children: [
              // icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 228, 230),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(Icons.unarchive_outlined, color: Colors.red),
              ),
              // info
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Package Removed",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'You have successfully removed the "${widget.packageTitle}" package.',
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
                  timeInString,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // if notification already read
      return Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 20,
            children: [
              // icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 228, 230),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(Icons.unarchive_outlined, color: Colors.red),
              ),
              // info
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Package Removed",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'You have successfully removed the "Sigiriya" package.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              // time
              Text(timeInString, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }
  }
}
