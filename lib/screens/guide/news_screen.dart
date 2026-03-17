import 'package:flutter/material.dart';
import '../../services/news_service.dart';
import '../../models/news_model.dart';
import '../../widgets/news_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<News>> newsFuture;

  @override
  void initState() {
    super.initState();
    newsFuture = NewsService.getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 248, 246),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 248, 246),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Tourism News",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<List<News>>(
        future: newsFuture,

        builder: (context, snapshot) {
          /// Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// Error
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading news"));
          }

          /// No Data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No news available"));
          }

          /// Data Loaded
          final newsList = snapshot.data!;

          return ListView.builder(
            itemCount: newsList.length,

            itemBuilder: (context, index) {
              return NewsCard(news: newsList[index]);
            },
          );
        },
      ),
    );
  }
}
