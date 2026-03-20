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
      width: MediaQuery.of(context).size.width * 0.43,
      height: 74,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(46, 0, 0, 0),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(25, 125, 212, 33),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Icon(
                  leadingIcon,
                  color: const Color.fromARGB(255, 125, 212, 33),
                  size: 25,
                ),
              ),
            ),

            SizedBox(width: 8),

            // name and value
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 100, 116, 139),
                  ),
                ),
                Text(
                  "$value $measure",
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
