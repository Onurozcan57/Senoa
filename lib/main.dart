import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:senoa/firebase_options.dart';
import 'package:senoa/AnaSayfa.dart';
import 'package:senoa/CanliDestekPage.dart';
import 'package:senoa/DiyAnaSayfa.dart';
import 'package:senoa/Diyetisyenim.dart';
import 'package:senoa/LoginScreen.dart';
import 'package:senoa/FeedPage.dart';
import 'package:senoa/YemekTarifleri.dart';
import 'package:senoa/diyetisyenler.dart';
import 'Package:senoa/Profile.dart';
import 'package:senoa/ChatPage.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print('Firebase başlatılıyor...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase başarıyla başlatıldı');

    // Firebase Auth durumunu kontrol et
    FirebaseAuth auth = FirebaseAuth.instance;
    print(
        'Firebase Auth durumu: ${auth.currentUser != null ? "Kullanıcı giriş yapmış" : "Kullanıcı giriş yapmamış"}');

    // Test için basit bir kullanıcı oluşturma denemesi
    try {
      await auth.createUserWithEmailAndPassword(
        email: "test@test.com",
        password: "test123456",
      );
      print('Test kullanıcısı oluşturuldu');
    } catch (e) {
      print('Test kullanıcısı oluşturma hatası: $e');
    }
  } catch (e) {
    print('Firebase başlatma hatası: $e');
  }

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
