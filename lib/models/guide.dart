import 'dart:io';
import '../services/appUser.dart';

class Guide extends AppUser {
  final String phoneNumber;
  final String? guideCertificateType;
  final String? certificateNumber;
  final File? uploadedCertificatePath;
  final String nic;
  final String location;
  final String address;
  final String country;
  final double rating;
  final bool availability;

  Guide({
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.password,
    required super.gender,
    required super.dob,
    required super.type,
    required this.phoneNumber,
    this.guideCertificateType,
    this.certificateNumber,
    required this.uploadedCertificatePath, // optional
    required this.nic,
    required this.location,
    required this.address,
    required this.country,
    required this.rating,
    required this.availability,
  });

  // ------------------------------------------------------------------------------------------------------ for the find guide - savidyakolonne

  factory Guide.fromMap(Map<String, dynamic> map) {
    return Guide(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      password: '', // password won't come from backend
      gender: map['gender'] ?? '',
      dob: map['dob'] ?? '',
      type: map['type'] ?? 'guide',
      phoneNumber: map['phoneNumber'] ?? '',
      guideCertificateType: map['guideCertificateType'],
      certificateNumber: map['certificateNumber'],
      uploadedCertificatePath: null, // backend does not provide file
      nic: map['nic'] ?? '',
      location: map['location'] ?? '',
      address: map['address'] ?? '',
      country: map['country'] ?? '',
      rating: double.tryParse(map['rating']?.toString() ?? '0') ?? 0,
      availability: map['availability'] ?? false,
    );
  }

  // ------------------------------------------------------------------------------------------------------

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'phoneNumber': phoneNumber,
      'guideCertificateType': guideCertificateType,
      'certificateNumber': certificateNumber,
      'uploadedCertificatePath': uploadedCertificatePath?.path,
      'nic': nic,
      'location': location,
      'address': address,
      'country': country,
      'rating': rating,
      'availability': availability,
    };
  }
}
