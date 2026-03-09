class News {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      imageUrl: json["imageUrl"],
      date: json["date"],
    );
  }
}
