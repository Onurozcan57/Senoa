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
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade100,
              const Color.fromARGB(255, 114, 246, 182)
            ],
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
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          "SENOA",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ), // Üstten boşluk
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
          color: const Color.fromARGB(255, 255, 255, 255),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        filled: true,
        fillColor: const Color.fromARGB(194, 0, 0, 0).withOpacity(0.6),
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
    print('Giriş fonksiyonu başladı');
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    print('Email: $email');
    print('Şifre: ${password.length} karakter');

    if (email.isEmpty || password.isEmpty) {
      print('Email veya şifre boş');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email ve şifre boş olamaz')),
      );
      return;
    }

    try {
      print('Giriş denemesi yapılıyor...');
      final Auth _auth = Auth();
      await _auth.signIn(email: email, password: password);

      // Kullanıcının seçtiği role göre koleksiyonu kontrol et
      String collection = isDietitian ? 'dietitians' : 'users';
      print('Koleksiyon kontrolü: $collection');

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(collection)
          .doc(_auth.currentUser!.uid)
          .get();

      print('Firestore kontrolü: ${userDoc.exists}');

      if (!userDoc.exists) {
        print('Kullanıcı yanlış koleksiyonda');
        await _auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Bu hesap ${isDietitian ? "diyetisyen" : "kullanıcı"} hesabı değil')),
        );
        return;
      }

      // Rol yönlendirmesi
      if (isDietitian) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Diyanasayfa()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Anasayfa()),
        );
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Hatası: ${e.code} - ${e.message}');
      String errorMessage = "Bir hata oluştu";
      if (e.code == 'user-not-found') {
        errorMessage = 'Kullanıcı bulunamadı';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Yanlış şifre';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Geçersiz email formatı';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'Bu hesap devre dışı bırakılmış';
      } else if (e.code == 'too-many-requests') {
        errorMessage =
            'Çok fazla başarısız giriş denemesi. Lütfen daha sonra tekrar deneyin';
      } else {
        errorMessage = e.message ?? "Bilinmeyen hata";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      print('Giriş hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Beklenmeyen bir hata oluştu: $e')));
    }
  }

  void _showRegisterPopup(BuildContext context) {
    print('Kayıt popup\'ı açılıyor');
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController surnameController = TextEditingController();
    final TextEditingController biographyController = TextEditingController();
    DateTime? selectedDate;
    String? emailError;
    String? passwordError;
    String? dateError;
    String? nameError;
    String? surnameError;
    String? genderError;
    String? biographyError;

    final Auth _auth = Auth();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFA8D5BA),
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
                    if (isDietitian) ...[
                      _customInputField(biographyController, "Biyografi",
                          maxLines: 3),
                      if (biographyError != null)
                        Text(biographyError!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12)),
                    ],
                    const SizedBox(height: 10),
                    // Cinsiyet seçimi
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cinsiyet",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedGender = 'female';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _selectedGender == 'female'
                                          ? Color(0xFF58A399).withOpacity(0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _selectedGender == 'female'
                                            ? Color(0xFF58A399)
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.female,
                                          color: _selectedGender == 'female'
                                              ? Color(0xFF58A399)
                                              : Colors.grey,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Kadın',
                                          style: TextStyle(
                                            color: _selectedGender == 'female'
                                                ? Color(0xFF58A399)
                                                : Colors.grey,
                                            fontWeight:
                                                _selectedGender == 'female'
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedGender = 'male';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _selectedGender == 'male'
                                          ? Color(0xFF58A399).withOpacity(0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _selectedGender == 'male'
                                            ? Color(0xFF58A399)
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.male,
                                          color: _selectedGender == 'male'
                                              ? Color(0xFF58A399)
                                              : Colors.grey,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Erkek',
                                          style: TextStyle(
                                            color: _selectedGender == 'male'
                                                ? Color(0xFF58A399)
                                                : Colors.grey,
                                            fontWeight:
                                                _selectedGender == 'male'
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (genderError != null)
                      Text(genderError!,
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
                                  primary: Color(0xFF58A399),
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
                                color: Color(0xFFA8D5BA)),
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
                        print('Kayıt butonu tıklandı');
                        // Form validasyonu
                        bool isValid = true;
                        setState(() {
                          emailError = null;
                          passwordError = null;
                          nameError = null;
                          surnameError = null;
                          biographyError = null;
                          genderError = null;
                          dateError = null;
                        });

                        // Validasyon kontrolleri
                        if (nameController.text.isEmpty) {
                          setState(() {
                            nameError = 'İsim alanı zorunludur';
                            isValid = false;
                          });
                        }

                        if (surnameController.text.isEmpty) {
                          setState(() {
                            surnameError = 'Soyisim alanı zorunludur';
                            isValid = false;
                          });
                        }

                        if (emailController.text.isEmpty) {
                          setState(() {
                            emailError = 'Email alanı zorunludur';
                            isValid = false;
                          });
                        } else if (!emailController.text.contains('@')) {
                          setState(() {
                            emailError = 'Geçerli bir email adresi giriniz';
                            isValid = false;
                          });
                        }

                        if (passwordController.text.isEmpty) {
                          setState(() {
                            passwordError = 'Şifre alanı zorunludur';
                            isValid = false;
                          });
                        } else if (passwordController.text.length < 6) {
                          setState(() {
                            passwordError = 'Şifre en az 6 karakter olmalıdır';
                            isValid = false;
                          });
                        }

                        if (_selectedGender == null) {
                          setState(() {
                            genderError = 'Cinsiyet seçimi zorunludur';
                            isValid = false;
                          });
                        }

                        if (selectedDate == null) {
                          setState(() {
                            dateError = 'Doğum tarihi seçimi zorunludur';
                            isValid = false;
                          });
                        }

                        if (isDietitian && biographyController.text.isEmpty) {
                          setState(() {
                            biographyError = 'Biyografi alanı zorunludur';
                            isValid = false;
                          });
                        }

                        if (!isValid) {
                          print('Form validasyonu başarısız');
                          return;
                        }

                        try {
                          print('Kayıt işlemi başlatılıyor...');
                          print(
                              'Kullanıcı tipi: ${isDietitian ? "Diyetisyen" : "Normal Kullanıcı"}');

                          // Firebase'in başlatıldığından emin ol
                          if (FirebaseAuth.instance == null) {
                            throw Exception('Firebase başlatılamadı');
                          }

                          if (isDietitian) {
                            print('Diyetisyen kaydı yapılıyor...');
                            try {
                              await _auth.createDietitian(
                                nameSurname:
                                    '${nameController.text} ${surnameController.text}',
                                email: emailController.text,
                                password: passwordController.text,
                                biography: biographyController.text,
                              );
                              print('Diyetisyen kaydı başarılı');
                            } catch (e) {
                              print('Diyetisyen kaydı hatası: $e');
                              rethrow;
                            }
                          } else {
                            print('Normal kullanıcı kaydı yapılıyor...');
                            try {
                              await _auth.createUser(
                                nameSurname:
                                    '${nameController.text} ${surnameController.text}',
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              print('Normal kullanıcı kaydı başarılı');
                            } catch (e) {
                              print('Normal kullanıcı kaydı hatası: $e');
                              rethrow;
                            }
                          }

                          // Kullanıcı bilgilerini Firestore'a kaydet
                          String? userId = _auth.currentUser?.uid;
                          if (userId == null) {
                            throw Exception('Kullanıcı ID alınamadı');
                          }

                          print('Firestore kaydı yapılıyor... UserID: $userId');

                          Map<String, dynamic> userData = {
                            'nameSurname':
                                '${nameController.text} ${surnameController.text}',
                            'email': emailController.text,
                            'gender': _selectedGender,
                            'birthDate': selectedDate!.toIso8601String(),
                            'createdAt': FieldValue.serverTimestamp(),
                          };

                          try {
                            if (isDietitian) {
                              userData['biography'] = biographyController.text;
                              userData['role'] = 'dietitian';
                              await FirebaseFirestore.instance
                                  .collection('dietitians')
                                  .doc(userId)
                                  .set(userData);
                              print(
                                  'Diyetisyen bilgileri Firestore\'a kaydedildi');
                            } else {
                              userData['role'] = 'user';
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .set(userData);
                              print(
                                  'Kullanıcı bilgileri Firestore\'a kaydedildi');
                            }
                          } catch (e) {
                            print('Firestore kayıt hatası: $e');
                            // Firestore kaydı başarısız olursa, oluşturulan kullanıcıyı sil
                            await _auth.currentUser?.delete();
                            rethrow;
                          }

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Kayıt başarılı! Giriş yapabilirsiniz.')),
                          );
                        } catch (e) {
                          print('Kayıt hatası: $e');
                          String errorMessage = 'Kayıt işlemi başarısız oldu';

                          if (e is FirebaseAuthException) {
                            print(
                                'Firebase Auth Hatası: ${e.code} - ${e.message}');
                            if (e.code == 'email-already-in-use') {
                              errorMessage = 'Bu email adresi zaten kullanımda';
                            } else if (e.code == 'weak-password') {
                              errorMessage = 'Şifre çok zayıf';
                            } else if (e.code == 'invalid-email') {
                              errorMessage = 'Geçersiz email formatı';
                            } else if (e.code == 'operation-not-allowed') {
                              errorMessage = 'Email/şifre girişi etkin değil';
                            } else if (e.code == 'network-request-failed') {
                              errorMessage =
                                  'İnternet bağlantınızı kontrol edin';
                            }
                          } else {
                            print('Beklenmeyen hata: $e');
                            errorMessage = 'Beklenmeyen bir hata oluştu: $e';
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage)),
                          );
                        }
                      },
                      child: Text('Kayıt Ol'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF58A399),
                        foregroundColor: Colors.white,
                      ),
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
          backgroundColor: Color(0xFFA8D5BA),
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
                backgroundColor: Color(0xFF58A399),
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
      {bool obscure = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        maxLines: maxLines,
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
