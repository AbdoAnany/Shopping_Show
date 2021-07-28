import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/routes.dart';
import 'package:panda1/screens/splash/splash_screen.dart';
import 'package:panda1/theme.dart';

import 'ad_State.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final infuture = MobileAds.instance.initialize();

  AdState(infuture);
  MobileAds.instance.initialize();
  Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping Show',
      theme: theme(),
      home: SplashScreen(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
