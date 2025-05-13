import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:senoa/AnaSayfa.dart';
import 'package:senoa/DiyAnaSayfa.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:senoa/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isDietitian = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/girisekrani.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100), // Üstten boşluk
                    // Rol seçimi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildRoleButton("Diyetisyen", true),
                        SizedBox(width: 10),
                        _buildRoleButton("Kullanıcı", false),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Email
                    _customTextField(_emailController, "Email", false),
                    SizedBox(height: 10),
                    // Şifre
                    _customTextField(_passwordController, "Şifre", true),
                    SizedBox(height: 20),
                    // Giriş Butonu
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: _login,
                      child: Text(
                        "Giriş Yap",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: TextButton(
                    onPressed: () => _showRegisterPopup(context),
                    child: Text(
                      "Hesabın yok mu?  Kayıt ol",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(String title, bool isThisDietitian) {
    bool selected = isDietitian == isThisDietitian;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: selected
            ? (isThisDietitian ? Colors.green.shade700 : Colors.blue.shade700)
            : Colors.grey.shade700,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isDietitian = isThisDietitian;
          });
        },
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _customTextField(
      TextEditingController controller, String label, bool isPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Rol yönlendirmesi
      if (isDietitian) {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        print("Giriş başarılı: ${userCredential.user?.uid}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Diyanasayfa()),
        );
      } else {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        print("Giriş başarılı: ${userCredential.user?.uid}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Anasayfa()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Bir hata oluştu";
      if (e.code == 'user-not-found') {
        errorMessage = 'Kullanıcı bulunamadı';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Yanlış şifre';
      } else {
        errorMessage = e.message ?? "Bilinmeyen hata";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void _showRegisterPopup(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController surnameController = TextEditingController();
    DateTime? selectedDate;

    String? emailError;
    String? passwordError;
    String? dateError;
    String? nameError;
    String? surnameError;

    final Auth _auth = Auth();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF5E7DC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Kayıt Ol",
            style: TextStyle(color: Colors.black87),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _customInputField(nameController, "İsim"),
                    if (nameError != null)
                      Text(nameError!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12)),
                    _customInputField(surnameController, "Soyisim"),
                    if (surnameError != null)
                      Text(surnameError!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12)),
                    _customInputField(emailController, "Email"),
                    if (emailError != null)
                      Text(emailError!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12)),
                    _customInputField(passwordController, "Şifre",
                        obscure: true),
                    if (passwordError != null)
                      Text(passwordError!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12)),
                    const SizedBox(height: 10),
                    // Doğum tarihi seçici
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Color(0xFFD69C6C),
                                  onPrimary: Colors.white,
                                  surface: Colors.white,
                                  onSurface: Colors.black,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate == null
                                  ? "Doğum Tarihi Seçin"
                                  : "${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}",
                              style: TextStyle(
                                color: selectedDate == null
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            Icon(Icons.calendar_today,
                                color: Color(0xFFD69C6C)),
                          ],
                        ),
                      ),
                    ),
                    if (dateError != null)
                      Text(dateError!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          nameError = nameController.text.isEmpty
                              ? "İsim giriniz"
                              : null;
                          surnameError = surnameController.text.isEmpty
                              ? "Soyisim giriniz"
                              : null;
                          emailError = !emailController.text.contains('@')
                              ? "Geçerli email girin"
                              : null;
                          passwordError = passwordController.text.length < 6
                              ? "Şifre en az 6 karakter olmalı"
                              : null;
                          dateError = selectedDate == null
                              ? "Doğum tarihi seçin"
                              : null;
                        });

                        if (nameError == null &&
                            surnameError == null &&
                            emailError == null &&
                            passwordError == null &&
                            dateError == null) {
                          try {
                            await _auth.createUser(
                              nameSurname:
                                  '${nameController.text} ${surnameController.text}',
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            // Diyetisyen veya normal kullanıcı kontrolü
                            if (isDietitian) {
                              // Diyetisyen kaydı
                              await FirebaseFirestore.instance
                                  .collection('dietitians')
                                  .doc(_auth.currentUser!.uid)
                                  .set({
                                'nameSurname':
                                    '${nameController.text} ${surnameController.text}',
                                'email': emailController.text,
                                'birthDate': selectedDate!.toIso8601String(),
                                'createdAt': FieldValue.serverTimestamp(),
                              });
                              Navigator.pop(context);
                            } else {
                              // Normal kullanıcı kaydı
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(_auth.currentUser!.uid)
                                  .set({
                                'nameSurname':
                                    '${nameController.text} ${surnameController.text}',
                                'email': emailController.text,
                                'birthDate': selectedDate!.toIso8601String(),
                                'createdAt': FieldValue.serverTimestamp(),
                              });

                              Future.delayed(Duration(milliseconds: 100), () {
                                _showBodyWeightPopup(context);
                              });
                              Navigator.pop(context);
                            }

                            print('Kullanıcı başarıyla kaydedildi!');
                          } catch (e) {
                            print('Hata: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Kayıt sırasında bir hata oluştu: $e')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD69C6C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Devam Et"),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showBodyWeightPopup(BuildContext context) {
    final heightController = TextEditingController();
    final weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFFF5E7DC),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Boy & Kilo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _customInputField(heightController, "Boy (cm)"),
              _customInputField(weightController, "Kilo (kg)"),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Boy ve kilo değerlerini Firestore'a kaydet
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(Auth().currentUser!.uid)
                      .update({
                    'height': double.parse(heightController.text),
                    'weight': double.parse(weightController.text),
                  });
                  Navigator.pop(context);
                } catch (e) {
                  print('Boy/kilo kaydetme hatası: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Boy ve kilo kaydedilirken bir hata oluştu')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD69C6C),
                foregroundColor: Colors.white,
              ),
              child: Text("Kayıt Ol"),
            ),
          ],
        );
      },
    );
  }

  Widget _customInputField(TextEditingController controller, String label,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser(String email, String password) async {
    final String apiUrl = 'http://your-api-url/register';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        print('Kayıt başarılı: ${response.body}');
      } else {
        print('Hata: ${response.body}');
      }
    } catch (error) {
      print('Hata: $error');
    }
  }
}
