import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:senoa/firebase_options.dart';
import 'package:senoa/AnaSayfa.dart';
import 'package:senoa/CanliDestekPage.dart';
import 'package:senoa/DiyAnaSayfa.dart';
import 'package:senoa/Diyetisyenim.dart';
import 'package:senoa/LoginScreen.dart';
import 'package:senoa/FeedPage.dart';
import 'package:senoa/YemekTarifleri.dart';
import 'package:senoa/diyetisyenler.dart';
import 'package:senoa/firebase_options.dart';
import 'Package:senoa/Profile.dart';
import 'package:senoa/ChatPage.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
