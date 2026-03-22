import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
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
  runApp(TraampApp());
}

class TraampApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      title: 'Traamp',

      routes: {'/map': (context) => const MapScreen()},

      home: LoginScreen(),
    );
  }
}
