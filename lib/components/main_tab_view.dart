import 'package:flutter/material.dart';
import 'settings_screen.dart';
import '../screens/guide/guide_dashboard.dart';
import '../screens/guide/guide_msg_screen.dart';
import '../screens/guide/guide_notification_screen.dart';
import '../screens/tourist/tourist_dashboard.dart';
import '../screens/tourist/tourist_msg_screen.dart';
import '../screens/tourist/tourist_notification_screen.dart';

// ignore: must_be_immutable
class MainTabView extends StatefulWidget {
  bool isTourist;
  MainTabView(this.isTourist, {super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: [
            widget.isTourist ? TouristDashboard() : GuideDashboard(),
            widget.isTourist ? TouristMsgScreen() : GuideMsgScreen(),
            widget.isTourist
                ? TouristNotificationScreen()
                : GuideNotificationScreen(),
            widget.isTourist ? Settings(true) : Settings(false),
          ],
        ),
        bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 248, 246),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(94, 0, 0, 0),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            labelColor: Colors.green,
            unselectedLabelColor: Color.fromARGB(255, 148, 163, 184),
            tabs: [
              Tab(icon: Icon(Icons.home, size: 30)),
              Tab(icon: Icon(Icons.email, size: 30)),
              Tab(icon: Icon(Icons.notifications_active, size: 30)),
              Tab(icon: Icon(Icons.person, size: 30)),
            ],
          ),
        ),
      ),
    );
  }
}
