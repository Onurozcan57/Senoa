import 'package:flutter/material.dart';
import 'package:senoa/AnaSayfa.dart';
import 'package:senoa/DiyAnaSayfa.dart';
import 'package:senoa/Diyetisyenim.dart';
import 'package:senoa/LoginScreen.dart';
import 'package:senoa/FeedPage.dart';
import 'package:senoa/YemekTarifleri.dart';
import 'Profile.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Diyanasayfa(),
    );
  }
}
