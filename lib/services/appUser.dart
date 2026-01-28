class AppUser {
  // final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String gender;
  final String dob;
  final String type;

  AppUser({
    //required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
    required this.dob,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      //'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'gender': gender,
      'dob': dob,
      'type': type,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
