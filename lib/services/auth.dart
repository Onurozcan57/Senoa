import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final userCollection = FirebaseFirestore.instance.collection("users");

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // register
  Future<void> createUser(
      {required String nameSurname,
      required String email,
      required String password}) async {
    try {
      print('createUser başladı - Email: $email');

      // Firebase Auth'da kullanıcı oluştur
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print(
          'Firebase Auth kullanıcısı oluşturuldu: ${userCredential.user?.uid}');

      // Kullanıcı oluşturuldu mu kontrol et
      if (userCredential.user != null) {
        // Kullanıcı bilgilerini Firestore'a kaydet
        await userCollection.doc(userCredential.user!.uid).set({
          'nameSurname': nameSurname,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'user',
        });

        print('Kullanıcı bilgileri Firestore\'a kaydedildi');
      } else {
        throw Exception('Kullanıcı oluşturulamadı');
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Hatası: ${e.code} - ${e.message}');
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Bu email adresi zaten kullanımda';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz email formatı';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/şifre girişi etkin değil';
          break;
        case 'weak-password':
          errorMessage = 'Şifre çok zayıf';
          break;
        default:
          errorMessage = 'Bir hata oluştu: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      print('createUser hatası: $e');
      throw Exception('Kullanıcı oluşturulurken bir hata oluştu: $e');
    }
  }

  //login
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('signIn başladı - Email: $email');
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Giriş başarılı: ${userCredential.user?.uid}');
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Hatası: ${e.code} - ${e.message}');
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Kullanıcı bulunamadı';
          break;
        case 'wrong-password':
          errorMessage = 'Yanlış şifre';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz email formatı';
          break;
        case 'user-disabled':
          errorMessage = 'Bu hesap devre dışı bırakılmış';
          break;
        default:
          errorMessage = 'Bir hata oluştu: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      print('signIn hatası: $e');
      throw Exception('Giriş yapılırken bir hata oluştu: $e');
    }
  }

  // signOut
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      print('Çıkış yapıldı');
    } catch (e) {
      print('signOut hatası: $e');
      throw Exception('Çıkış yapılırken bir hata oluştu: $e');
    }
  }

  Future<void> createDietitian({
    required String nameSurname,
    required String email,
    required String password,
    required String biography,
  }) async {
    try {
      print('createDietitian başladı - Email: $email');

      // Firebase Auth'da kullanıcı oluştur
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print(
          'Firebase Auth diyetisyeni oluşturuldu: ${userCredential.user?.uid}');

      // Kullanıcı oluşturuldu mu kontrol et
      if (userCredential.user != null) {
        // Diyetisyen bilgilerini Firestore'a kaydet
        await FirebaseFirestore.instance
            .collection('dietitians')
            .doc(userCredential.user!.uid)
            .set({
          'nameSurname': nameSurname,
          'email': email,
          'biography': biography,
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'dietitian',
        });

        print('Diyetisyen bilgileri Firestore\'a kaydedildi');
      } else {
        throw Exception('Diyetisyen oluşturulamadı');
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Hatası: ${e.code} - ${e.message}');
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Bu email adresi zaten kullanımda';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz email formatı';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/şifre girişi etkin değil';
          break;
        case 'weak-password':
          errorMessage = 'Şifre çok zayıf';
          break;
        default:
          errorMessage = 'Bir hata oluştu: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      print('createDietitian hatası: $e');
      throw Exception('Diyetisyen oluşturulurken bir hata oluştu: $e');
    }
  }
}
