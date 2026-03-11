import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../app_config.dart';
import '../../widgets/notification_change_user_data_tile.dart';
import '../../widgets/notification_gallery_added_tile.dart';
import '../../widgets/notification_gallery_removed_tile.dart';
import '../../widgets/notification_guide_availability_tile.dart';
import '../../widgets/notification_new_package_tile.dart'
    show NotificationNewPackageTile;
import '../../widgets/notification_package_removed_tile.dart';
import '../../widgets/notification_registration_successful_tile.dart';

// types = registration/ package-added/ package-removed/ user-info-changed/ availability-status/ gallery-added/ gallery-removed

class NotificationScreen extends StatefulWidget {
  final String uid;
  const NotificationScreen(this.uid, {super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notificationList = [];
  List<dynamic> newNotificationList = [];
  List<dynamic> earlierNotificationList = [];

  Future<void> _getNotifications() async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.SERVER_URL}/api/notification/getNotifications"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"uid": widget.uid}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data['msg']);
        setState(() {
          notificationList = data['notifications'];
        });
        print(notificationList);
        // calling separateNotifications
        _separateNotifications();
        // calling setNotificationsToRead
        _setNotificationsToRead();
      } else {
        print(data['msg']);
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void _separateNotifications() {
    setState(() {
      setState(() {
        if (notificationList.isNotEmpty) {
          // sort by date
          notificationList.sort(
            (a, b) => b["createdAt"]['_seconds'].compareTo(
              a["createdAt"]['_seconds'],
            ),
          );
          // separate read and unread notifications
          for (int i = 0; i < notificationList.length; i++) {
            if (notificationList[i]['isUnread']) {
              newNotificationList.add(notificationList[i]);
            } else {
              earlierNotificationList.add(notificationList[i]);
            }
          }
        }
      });
      print("new Notification List: ${newNotificationList}");
      print("earlier Notification List: ${earlierNotificationList}");
    });
  }

  Future<void> _setNotificationsToRead() async {
    try {
      final response = await http.put(
        Uri.parse(
          "${AppConfig.SERVER_URL}/api/notification/updateNotifications",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"newNotificationList": newNotificationList}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data['msg']);
      } else {
        print(data['msg']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _clearNotifications() async {
    try {
      final response = await http.delete(
        Uri.parse(
          "${AppConfig.SERVER_URL}/api/notification/clearNotifications",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"notificationList": notificationList}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data['msg']);
      } else {
        print(data['msg']);
      }
      _getNotifications();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () {
              setState(() {
                _clearNotifications();
              });
            },
            icon: Text(
              "Clear All",
              style: TextStyle(
                color: const Color.fromARGB(255, 73, 178, 78),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          // if notification list is empty show a msg else show notifications
          child: notificationList.isEmpty
              ? SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(child: Text("No notifications to show.")),
                )
              : Container(
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
                      newNotificationList.isEmpty
                          ? SizedBox(
                              width: double.infinity,
                              height: 100,
                              child: Center(
                                child: Text("No new notifications to show"),
                              ),
                            )
                          : Column(
                              spacing: 10,
                              children: [
                                for (
                                  int i = 0;
                                  i < newNotificationList.length;
                                  i++
                                )
                                  newNotificationList[i]['type'] ==
                                          'registration'
                                      ? NotificationRegistrationSuccessfulTile(
                                          true,
                                          newNotificationList[i]['createdAt'],
                                        )
                                      : (newNotificationList[i]['type'] ==
                                                'package-added'
                                            ? NotificationNewPackageTile(
                                                true,
                                                newNotificationList[i]['packageTitle']
                                                    .toString(),
                                                newNotificationList[i]['createdAt'],
                                              )
                                            : (newNotificationList[i]['type'] ==
                                                      'package-removed'
                                                  ? NotificationPackageRemovedTile(
                                                      true,
                                                      newNotificationList[i]['packageTitle']
                                                          .toString(),
                                                      newNotificationList[i]['createdAt'],
                                                    )
                                                  : (newNotificationList[i]['type'] ==
                                                            'user-info-changed'
                                                        ? NotificationChangeUserDataTile(
                                                            true,
                                                            newNotificationList[i]['createdAt'],
                                                          )
                                                        : (newNotificationList[i]['type'] ==
                                                                  'availability-status'
                                                              ? NotificationGuideAvailabilityTile(
                                                                  true,
                                                                  newNotificationList[i]['msg']
                                                                      .toString(),
                                                                  newNotificationList[i]['createdAt'],
                                                                )
                                                              : (newNotificationList[i]['type'] ==
                                                                        'gallery-added'
                                                                    ? NotificationGalleryAddedTile(
                                                                        true,
                                                                        newNotificationList[i]['createdAt'],
                                                                      )
                                                                    : (newNotificationList[i]['type'] ==
                                                                              'gallery-removed'
                                                                          ? NotificationGalleryRemovedTile(
                                                                              true,
                                                                              newNotificationList[i]['createdAt'],
                                                                            )
                                                                          : Container())))))),
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
                      earlierNotificationList.isEmpty
                          ? SizedBox(
                              width: double.infinity,
                              height: 100,
                              child: Center(
                                child: Text("No earlier notifications to show"),
                              ),
                            )
                          : Column(
                              spacing: 10,
                              children: [
                                for (
                                  int i = 0;
                                  i < earlierNotificationList.length;
                                  i++
                                )
                                  earlierNotificationList[i]['type'] ==
                                          'registration'
                                      ? NotificationRegistrationSuccessfulTile(
                                          false,
                                          earlierNotificationList[i]['createdAt'],
                                        )
                                      : (earlierNotificationList[i]['type'] ==
                                                'package-added'
                                            ? NotificationNewPackageTile(
                                                false,
                                                earlierNotificationList[i]['packageTitle']
                                                    .toString(),
                                                earlierNotificationList[i]['createdAt'],
                                              )
                                            : (earlierNotificationList[i]['type'] ==
                                                      'package-removed'
                                                  ? NotificationPackageRemovedTile(
                                                      false,
                                                      earlierNotificationList[i]['packageTitle']
                                                          .toString(),
                                                      earlierNotificationList[i]['createdAt'],
                                                    )
                                                  : (earlierNotificationList[i]['type'] ==
                                                            'user-info-changed'
                                                        ? NotificationChangeUserDataTile(
                                                            false,
                                                            earlierNotificationList[i]['createdAt'],
                                                          )
                                                        : (earlierNotificationList[i]['type'] ==
                                                                  'availability-status'
                                                              ? NotificationGuideAvailabilityTile(
                                                                  false,
                                                                  earlierNotificationList[i]['msg']
                                                                      .toString(),
                                                                  earlierNotificationList[i]['createdAt'],
                                                                )
                                                              : (earlierNotificationList[i]['type'] ==
                                                                        'gallery-added'
                                                                    ? NotificationGalleryAddedTile(
                                                                        false,
                                                                        earlierNotificationList[i]['createdAt'],
                                                                      )
                                                                    : (earlierNotificationList[i]['type'] ==
                                                                              'gallery-removed'
                                                                          ? NotificationGalleryRemovedTile(
                                                                              false,
                                                                              earlierNotificationList[i]['createdAt'],
                                                                            )
                                                                          : Container())))))),
                              ],
                            ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
