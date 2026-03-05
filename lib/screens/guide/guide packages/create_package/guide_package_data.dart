import 'dart:io';

class GuidePackageData {
  String uid = "";
  String packageTitle = "";
  String category = "";
  String shortDescription = "";
  String description = "";
  String location = "";
  List<String> languages = [];
  late File coverImage;
  List<File> images = [];
  String duration = "";
  List<String> availableDays = [];
  String season = "";
  double price = 0.0;
  int minGuests = 0;
  int maxGuests = 0;
  bool havePrivateTourOption = false;
  bool haveGroupDiscounts = false;
  String startLocation = "";
  String endLocation = "";
  List<String> stops = [];
  List<String> packageInclude = [];
  List<String> packageExclude = [];
}