import 'package:flutter/material.dart';
import 'package:senoa/AnaSayfa.dart';
import 'package:senoa/DiyAnaSayfa.dart';

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
