import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onestore/config/const_design.dart';
import 'package:onestore/screens/login_screen.dart';
import 'package:onestore/screens/register_email.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BAE STORE",
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kPrimaryColor,
        textTheme: const TextTheme(
          caption: TextStyle(
            fontSize: 16,
            fontFamily: 'Noto San Lao',
          ),
          headline1: TextStyle(
            fontSize: 72,
            fontFamily: 'Noto San Lao',
            fontWeight: FontWeight.bold,
          ),
          headline5: TextStyle(
            fontSize: 24,
            fontFamily: 'Noto San Lao',
            fontStyle: FontStyle.normal,
            // color: Colors.white,
          ),
          headline6: TextStyle(
            fontSize: 20,
            fontFamily: 'Noto San Lao',
            fontStyle: FontStyle.normal,
            // color: Colors.white,
          ),
          bodyText2: TextStyle(
            fontSize: 14,
            fontFamily: 'Noto San Lao',
            fontStyle: FontStyle.normal,
            // color: Colors.white,
          ),
          bodyText1: TextStyle(
            fontSize: 24,
            fontFamily: 'Noto San Lao',
            fontStyle: FontStyle.normal,
            // color: Colors.white,
          ),
        ),
      ),
      home: const LoginScreen(),
      routes: {
        RegistEmailScreen.routerName: (ctx) => const RegistEmailScreen(),
      },
    );
  }
}
