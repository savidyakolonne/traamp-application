import 'package:flutter/material.dart';

import '../../widgets/notification_guide_availability_tile.dart';
import '../../widgets/notification_change_user_data_tile.dart';
import '../../widgets/notification_gallery_added_tile.dart';
import '../../widgets/notification_gallery_removed_tile.dart';
import '../../widgets/notification_new_package_tile.dart';
import '../../widgets/notification_package_removed_tile.dart';
import '../../widgets/notification_registration_successful_tile.dart';

class NotificationAllTab extends StatefulWidget {
  const NotificationAllTab({super.key});

  @override
  State<NotificationAllTab> createState() => _NotificationAllTabState();
}

class _NotificationAllTabState extends State<NotificationAllTab> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          width: double.infinity,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // New
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Text(
                  "NEW",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromARGB(255, 148, 163, 184),
                  ),
                ),
              ),
              // New section
              Column(
                spacing: 10,
                children: [
                  // registration successful
                  NotificationRegistrationSuccessfulTile(false),

                  // package added
                  NotificationNewPackageTile(false, "Sigiriya"),
                ],
              ),
              // earlier
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Text(
                  "EARLIER",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromARGB(255, 148, 163, 184),
                  ),
                ),
              ),

              // earlier section
              Column(
                spacing: 10,
                children: [
                  // Changed used data
                  NotificationChangeUserDataTile(false),

                  // Changed guide availability
                  NotificationGuideAvailabilityTile(true, "not available"),

                  // package removed
                  NotificationPackageRemovedTile(false, "Sigiriya"),

                  // gallery added
                  NotificationGalleryAddedTile(false),

                  // gallery removed
                  NotificationGalleryRemovedTile(false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
