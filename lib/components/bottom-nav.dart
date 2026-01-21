import 'package:flutter/material.dart';

class BottomNav {
  static Widget bottom_navigation() {
    return BottomAppBar(
      height: 60,
      shape: CircularNotchedRectangle(),
      color: Colors.green,
      child: Container(
        padding: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            IconButton(
              icon: Icon(Icons.home_outlined, size: 40, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.email_outlined, size: 36, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_active_outlined,
                size: 36,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle_outlined,
                size: 35,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
