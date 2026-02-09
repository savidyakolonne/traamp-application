class Place {
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
  final Map<String, String>? activities;       // map of activityName: description
  final Map<String, String>? bestTimeToVisit;  // seasonNote + timeOfDayNote
  final Map<String, String>? visitingHours;
  final String shortDesc;

  Place({
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
    this.activities,
    this.bestTimeToVisit,
    this.visitingHours,
    required this.shortDesc,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
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
      shortDesc: json['shortDesc'],
      activities: json['activities'] != null
          ? Map<String, String>.from(json['activities'])
          : null,
      bestTimeToVisit: json['bestTimeToVisit'] != null
          ? Map<String, String>.from(json['bestTimeToVisit'])
          : null,
      visitingHours: json['visitingHours'] != null
          ? Map<String, String>.from(json['visitingHours'])
          : null,
    );
  }
}
