import 'package:flutter/material.dart';
import 'package:weather/feature/feature_splash/presentation/screen/splash_screen.dart';

import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init locator
  await setup();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.tealAccent,
        fontFamily: 'Franklin',
      ),
      home: const SplashScreen(),
    ),
  );
}
