import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../app_config.dart';
import '../../widgets/review_card.dart';

class RatingListScreen extends StatefulWidget {
  final String guideId;
  const RatingListScreen(this.guideId, {super.key});

  @override
  State<RatingListScreen> createState() => _RatingListScreenState();
}

class _RatingListScreenState extends State<RatingListScreen> {
  List<dynamic> reviews = [];

  // to format date
  String formatTimestamp(int seconds) {
    // Convert Firestore _seconds (epoch seconds) into DateTime
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000,
      isUtc: true,
    );
    // Format into 'dd/MM/yyyy'
    return DateFormat('dd/MM/yyyy').format(dt.toLocal());
  }

  // fetch reviews from DB
  Future<void> getReviews() async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.SERVER_URL}/api/reviews/get-reviews-by-id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"guideId": widget.guideId}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data['msg']);
        setState(() {
          reviews = data['data'];
        });
      } else {
        print(data['msg']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 248, 246),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 248, 246),
        title: Text(
          "Reviews & Ratings",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: RefreshIndicator(
          onRefresh: getReviews,
          child: SingleChildScrollView(
            child: reviews.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(child: Text("No reviews to show")),
                  )
                : Column(
                    spacing: 10,
                    children: [
                      for (int i = 0; i < reviews.length; i++)
                        ReviewCard(
                          name: reviews[i]['reviewerName'].toString(),
                          rating: reviews[i]['rating'],
                          date: formatTimestamp(
                            reviews[i]['createdAt']["_seconds"],
                          ),
                          review: reviews[i]['review'].toString(),
                          profilePic: reviews[i]['profPic'].toString(),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
