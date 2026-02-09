import 'package:flutter/material.dart';

import '../components/settings_screen.dart';
import 'guide/guide_dashboard.dart';
import 'guide/guide_msg_screen.dart';
import 'guide/guide_notification_screen.dart';
import 'tourist/tourist_dashboard.dart';
import 'tourist/tourist_msg_screen.dart';
import 'tourist/tourist_notification_screen.dart';

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
        bottomNavigationBar: BottomAppBar(
          color: Colors.green,
          child: const TabBar(
            dividerColor: Colors.green,
            indicatorColor: Colors.black,
            tabs: [
              Tab(
                icon: Icon(Icons.home_outlined, size: 30, color: Colors.black),
              ),
              Tab(
                icon: Icon(Icons.email_outlined, size: 30, color: Colors.black),
              ),
              Tab(
                icon: Icon(
                  Icons.notifications_active_outlined,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.settings_outlined,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
