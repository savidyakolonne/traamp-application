import 'appUser.dart';

class Guide extends AppUser {
  final String phoneNumber;
  final String? guideCertificateType;
  final String? certificateNumber;
  final String nic;
  final String location;
  final String address;
  final String country;
  final double rating;
  final bool availability;

  Guide({
    required super.uid,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.gender,
    required super.dob,
    required super.type,
    required this.phoneNumber,
    required this.guideCertificateType,
    required this.certificateNumber,
    required this.nic,
    required this.location,
    required this.address,
    required this.country,
    required this.rating,
    required this.availability,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'phoneNumber': phoneNumber,
      'certificateType': guideCertificateType,
      'certificateNumber': certificateNumber,
      'nic': nic,
      'location': location,
      'address': address,
      'country': country,
      'rating': rating,
      'availability': availability,
    };
  }
}
