import 'appUser.dart';

class Guide extends AppUser {
  final String phoneNumber;
  final String? guideCertifateType;
  final String? certificateNumber;
  final String nic;
  final String location;
  final String address;
  final String country;

  Guide({
    required super.uid,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.gender,
    required super.dob,
    required this.phoneNumber,
    required this.guideCertifateType,
    required this.certificateNumber,
    required this.nic,
    required this.location,
    required this.address,
    required this.country,
  }) : super(type: 'guide');

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'touristData': {
        'phoneNumber': phoneNumber,
        'certificateType': guideCertifateType,
        'certificateNumber': certificateNumber,
        'nic': nic,
        'location': location,
        'address': address,
        'country': country,
      },
    };
  }
}
