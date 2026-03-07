import 'package:flutter/material.dart';
import 'settings_screen.dart';
import '../screens/guide/guide_dashboard.dart';
import '../screens/guide/guide_notification_screen.dart';
import '../screens/tourist/tourist_dashboard.dart';
import '../screens/tourist/tourist_notification_screen.dart';

class MainTabView extends StatefulWidget {
  final bool isTourist;
  final String idToken;
  const MainTabView(this.isTourist, this.idToken, {super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [
            widget.isTourist
                ? TouristDashboard(widget.idToken)
                : GuideDashboard(widget.idToken),
            widget.isTourist
                ? TouristNotificationScreen()
                : GuideNotificationScreen(),
            widget.isTourist
                ? Settings(true, widget.idToken)
                : Settings(false, widget.idToken),
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
              Tab(icon: Icon(Icons.notifications_active, size: 30)),
              Tab(icon: Icon(Icons.person, size: 30)),
            ],
          ),
        ),
      ),
    );
  }
}
