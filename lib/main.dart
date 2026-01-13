import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    DevicePreview(
      enabled: true, // set false for release
      builder: (context) => const TraampApp(),
    ),
  );
}

class TraampApp extends StatelessWidget {
  const TraampApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      title: 'Traamp',
      home: LoginScreen(),
    );
  }
}
