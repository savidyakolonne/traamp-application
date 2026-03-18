import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String profilePic;
  final String name;
  final int rating;
  final String date;
  final String review;
  const ReviewCard({
    super.key,
    required this.name,
    required this.rating,
    required this.date,
    required this.review,
    required this.profilePic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(26, 76, 175, 79),
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // name, rating and date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name rating and prof pic
              Row(
                spacing: 10,
                children: [
                  // prof pic
                  CircleAvatar(
                    backgroundImage: profilePic.isEmpty
                        ? AssetImage('assets/images/avatar-male.avif')
                        : NetworkImage(profilePic),
                  ),

                  // name and rating
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // name
                      SizedBox(
                        width: 160,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // rating
                      Row(
                        children: List.generate(
                          rating,
                          (index) =>
                              Icon(Icons.star, color: Colors.amber, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // date
              SizedBox(width: 86, child: Text(date)),
            ],
          ),
          // review
          Text(
            review,
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
