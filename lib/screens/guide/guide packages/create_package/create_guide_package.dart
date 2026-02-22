import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../appConfig.dart';
import '../guide_package.dart';
import 'guide_package_data.dart';
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
      submitAll();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  Future<void> submitAll() async {
    Map<String, dynamic> packageData = {};
    setState(() {
      packageData = {
        "uid": widget.uid,
        "packageTitle": guidePackageData.packageTitle,
        "category": guidePackageData.category,
        "shortDescription": guidePackageData.shortDescription,
        "description": guidePackageData.description,
        "location": guidePackageData.location,
        "languages": guidePackageData.languages,
        "duration": guidePackageData.duration,
        "availableDays": guidePackageData.availableDays,
        "season": guidePackageData.season,
        "price": guidePackageData.price,
        "minGuests": guidePackageData.minGuests,
        "maxGuests": guidePackageData.maxGuests,
        "havePrivateTourOption": guidePackageData.havePrivateTourOption,
        "haveGroupDiscounts": guidePackageData.haveGroupDiscounts,
        "startLocation": guidePackageData.startLocation,
        "endLocation": guidePackageData.endLocation,
        "stops": guidePackageData.stops,
        "packageInclude": guidePackageData.packageInclude,
        "packageExclude": guidePackageData.packageExclude,
      };
      print(packageData);
    });

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.SERVER_URL}/api/guidePackage/add-package"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(packageData),
      );

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

      final data = jsonDecode(response.body);
      print(data);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${data['msg']}'),
            backgroundColor: const Color.fromARGB(180, 76, 175, 79),
          ),
        );
        Navigator.pop(context, GuidePackage);
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
      appBar: AppBar(
        title: Text(
          "Create Guide Package",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.green,
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
