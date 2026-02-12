import 'package:flutter/material.dart';
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

  void submitAll() {
    final Map<String, dynamic> packageData = {
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Guide package created successfully.'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context, GuidePackage);
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
      content: SheduleTab(formKey2, guidePackageData),
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
        title: Text("Create Guide Package"),
        backgroundColor: Colors.green,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: currentStep,
        onStepTapped: (step) {}, //disable jumping
        onStepContinue: nextStep,
        onStepCancel: previousStep,
        steps: [step1(), step2(), step3(), step4()],
      ),
    );
  }
}
