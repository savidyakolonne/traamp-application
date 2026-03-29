import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'notification/notification_screen.dart';
import 'settings_screen.dart';
import '../screens/guide/guide_dashboard.dart';
import '../screens/tourist/tourist_dashboard.dart';

// ignore: must_be_immutable
class MainTabView extends StatefulWidget {
  final bool isTourist;
  String idToken;
  final Map<String, dynamic> userData;
  MainTabView(this.isTourist, this.idToken, this.userData, {super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [
            // dashboard
            widget.isTourist
                ? TouristDashboard(widget.idToken, widget.userData)
                : GuideDashboard(widget.idToken, widget.userData),
            // notification
            NotificationScreen(widget.userData["uid"] ?? userId),
            // settings
            widget.isTourist
                ? Settings(true, widget.idToken, widget.userData)
                : Settings(false, widget.idToken, widget.userData),
          ],
        ),
        bottomNavigationBar: Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 247, 248, 246),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(94, 0, 0, 0),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: SafeArea(
            child: const TabBar(
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              labelColor: Colors.green,
              unselectedLabelColor: Color.fromARGB(255, 148, 163, 184),
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.notifications_active)),
                Tab(icon: Icon(Icons.person)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
