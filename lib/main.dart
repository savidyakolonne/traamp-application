import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'screens/auth/login_screen.dart';

void main() => runApp(
  DevicePreview(
    builder: (context) => TraampApp(), // Wrap your app
  ),
);

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
