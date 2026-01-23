import 'package:flutter/material.dart';

import '../screens/guide/guide_dashboard.dart';
import '../screens/guide/guide_msg_screen.dart';
import '../screens/guide/guide_notification_screen.dart';
import '../screens/guide/guide_settings_screen.dart';
import '../screens/tourist/tourist_msg_screen.dart';
import '../screens/tourist/tourist_notification_screen.dart';
import '../screens/tourist/tourist_settings_screen.dart';
import '../screens/tourist/tourist_dashboard.dart';

class BottomNav {
  late bool isTourist;

  BottomNav(this.isTourist);

  Widget bottom_nav(BuildContext context) {
    return BottomAppBar(
      color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.home_outlined, size: 40, color: Colors.black),
            onPressed: () {
              // check condition to route tourist or guide dashboards
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return isTourist ? TouristDashboard() : GuideDashboard();
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.email_outlined, size: 36, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return isTourist ? TouristMsgScreen() : GuideMsgScreen();
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_active_outlined,
              size: 36,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return isTourist
                        ? TouristNotificationScreen()
                        : GuideNotificationScreen();
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, size: 35, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return isTourist ? TouristSettings() : GuideSettings();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
