import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../app_config.dart';
import '../../../../models/guide_package_data.dart';
import '../guide_package.dart';
import 'info_tab.dart';
import 'pricing_tab.dart';
import 'route_tab.dart';
import 'shedule_tab.dart';

// ignore: must_be_immutable
class CreateGuidePackage extends StatefulWidget {
  String uid;
  CreateGuidePackage(this.uid, {super.key});

  @override
  State<CreateGuidePackage> createState() => _CreateGuidePackageState();
}

class _CreateGuidePackageState extends State<CreateGuidePackage> {
  int currentStep = 0;

  final guidePackageData = GuidePackageData();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();

  void nextStep() {
    if (currentStep == 0 && formKey1.currentState!.validate()) {
      setState(() => currentStep++);
    } else if (currentStep == 1 && formKey2.currentState!.validate()) {
      setState(() => currentStep++);
    } else if (currentStep == 2 && formKey3.currentState!.validate()) {
      setState(() => currentStep++);
    } else if (currentStep == 3 && formKey4.currentState!.validate()) {
      _submitAll();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  Future<void> _submitAll() async {
    try {
      var uri = Uri.parse(
        "${AppConfig.SERVER_URL}/api/guidePackage/add-package",
      );
      var request = http.MultipartRequest('POST', uri);

      // Add text fields
      request.fields['uid'] = widget.uid;
      request.fields['packageTitle'] = guidePackageData.packageTitle;
      request.fields['category'] = guidePackageData.category;
      request.fields['shortDescription'] = guidePackageData.shortDescription;
      request.fields['description'] = guidePackageData.description;
      request.fields['location'] = guidePackageData.location;
      request.fields['languages'] = jsonEncode(guidePackageData.languages);
      request.fields['duration'] = guidePackageData.duration;
      request.fields['availableDays'] = jsonEncode(
        guidePackageData.availableDays,
      );
      request.fields['season'] = guidePackageData.season;
      request.fields['price'] = guidePackageData.price.toString();
      request.fields['minGuests'] = guidePackageData.minGuests.toString();
      request.fields['maxGuests'] = guidePackageData.maxGuests.toString();
      request.fields['havePrivateTourOption'] = guidePackageData
          .havePrivateTourOption
          .toString();
      request.fields['haveGroupDiscounts'] = guidePackageData.haveGroupDiscounts
          .toString();
      request.fields['startLocation'] = guidePackageData.startLocation;
      request.fields['endLocation'] = guidePackageData.endLocation;
      request.fields['stops'] = jsonEncode(guidePackageData.stops);
      request.fields['packageInclude'] = jsonEncode(
        guidePackageData.packageInclude,
      );
      request.fields['packageExclude'] = jsonEncode(
        guidePackageData.packageExclude,
      );

      // Add cover image
      request.files.add(
        await http.MultipartFile.fromPath(
          'coverImage',
          guidePackageData.coverImage.path,
        ),
      );

      // Add multiple images
      for (var img in guidePackageData.images) {
        request.files.add(
          await http.MultipartFile.fromPath('images', img.path),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Trying to add your package... "),
              CircularProgressIndicator.adaptive(),
            ],
          ),
          backgroundColor: const Color.fromARGB(180, 76, 175, 79),
        ),
      );

      // Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);
      print(data);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Text('${data['msg']}'),
                CircularProgressIndicator.adaptive(),
              ],
            ),
            backgroundColor: const Color.fromARGB(180, 76, 175, 79),
          ),
        );
        Navigator.pop(context, GuidePackage(widget.uid));
      } else {
        print(data['msg']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error while creating package'),
            backgroundColor: const Color.fromARGB(180, 244, 67, 54),
          ),
        );
      }
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error while connecting to server'),
          backgroundColor: const Color.fromARGB(180, 244, 67, 54),
        ),
      );
    }
  }

  Step step1() {
    return Step(
      stepStyle: StepStyle(color: Colors.green),
      title: Text("Basic Info"),
      content: InfoTab(formKey1, guidePackageData),
      isActive: currentStep >= 0,
    );
  }

  Step step2() {
    return Step(
      stepStyle: StepStyle(color: Colors.green),
      title: Text("Schedule"),
      content: ScheduleTab(formKey2, guidePackageData),
      isActive: currentStep >= 1,
    );
  }

  Step step3() {
    return Step(
      stepStyle: StepStyle(color: Colors.green),
      title: Text("Pricing"),
      content: PricingTab(formKey3, guidePackageData),
      isActive: currentStep >= 2,
    );
  }

  Step step4() {
    return Step(
      stepStyle: StepStyle(color: Colors.green),
      title: Text("Route"),
      content: RouteTab(formKey4, guidePackageData),
      isActive: currentStep >= 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 248, 246),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 248, 246),
        title: Text(
          "Create Your Packages",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, GuidePackage(widget.uid));
          },
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 71, 85, 105)),
        ),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: currentStep,
        onStepTapped: (step) {}, //disable jumping
        onStepContinue: nextStep,
        onStepCancel: previousStep,
        steps: [step1(), step2(), step3(), step4()],
      ),
    );
  }
}
