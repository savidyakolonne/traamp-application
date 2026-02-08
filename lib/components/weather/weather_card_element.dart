import 'package:flutter/material.dart';

class WeatherCardElement {
  static Widget card(
    BuildContext context,
    IconData leadingIcon,
    String title,
    dynamic value,
    String measure,
  ) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        color: const Color.fromARGB(87, 255, 255, 255),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Icon(leadingIcon, color: Colors.white, size: 35),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 15)),
                Text(
                  "${value} ${measure}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
