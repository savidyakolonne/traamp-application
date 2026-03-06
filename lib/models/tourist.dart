import '../services/appUser.dart';

class Tourist extends AppUser {
  final String country;

  Tourist({
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.password,
    required super.gender,
    required super.dob,
    required super.type,
    required this.country,
  });

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap(), 'country': country};
  }
}
