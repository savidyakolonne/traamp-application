import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/map/map_screen.dart';
import 'services/login_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (!kIsWeb) {
  //   await dotenv.load(fileName: ".env");
  // }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LoginState.init();
  await FirebaseAppCheck.instance.activate(
    // ignore: deprecated_member_use
    androidProvider: kReleaseMode
        ? AndroidProvider.playIntegrity
        : AndroidProvider.debug,
  );

  runApp(TraampApp());
}

class TraampApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        brightness: Brightness.light, // lock to light mode
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),
      themeMode: ThemeMode.light,
      title: 'Traamp',

      routes: {'/map': (context) => const MapScreen()},

      home: LoginScreen(),
    );
  }
}
