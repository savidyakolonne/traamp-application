class Activity {
  final String id;
  final String name;
  final String category;
  final String district;
  final String province;
  final String coverImage;
  final List images;
  final Map location;
  final String description;
  final List keywords;

  Activity({
    required this.id,
    required this.name,
    required this.category,
    required this.district,
    required this.province,
    required this.coverImage,
    required this.images,
    required this.location,
    required this.description,
    required this.keywords,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      district: json['district'],
      province: json['province'],
      coverImage: json['coverImage'],
      images: json['images'] ?? [],
      location: json['location'],
      description: json['description'] ?? "",
      keywords: json['keywords'] ?? [],
    );
  }
}
