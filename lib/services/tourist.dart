import 'appUser.dart';

class Tourist extends AppUser {
  final String country;

  Tourist({
    required super.uid,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.gender,
    required super.dob,
    required this.country,
  }) : super(type: 'tourist');

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'touristData': {'country': country},
    };
  }
}
