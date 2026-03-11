import 'package:flutter/material.dart';
import 'notification_all_tab.dart';
import 'notification_unread_tab.dart';

// TODO
// create stream builder
// get all notifications filtered by uid
// sort them from latest to oldest
// display notifications
// set isUnread = false if read the notification
// implement clear button to delete all notifications
// implement unread tab
// types = registration/ package-added/ package-removed/ user-info-changed/ availability-status/ gallery-added/ gallery-removed

class NotificationScreen extends StatefulWidget {
  final String uid;
  const NotificationScreen(this.uid, {super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 247, 248, 246),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 247, 248, 246),
          title: Text(
            "Notification",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Text(
                "Clear All",
                style: TextStyle(
                  color: const Color.fromARGB(255, 73, 178, 78),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.green,
            labelColor: Colors.black,
            unselectedLabelColor: Color.fromARGB(255, 148, 163, 184),
            tabs: [
              Text(
                "All",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              Text(
                "Unread",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [NotificationAllTab(), NotificationUnreadTab()],
        ),
      ),
    );
  }
}
