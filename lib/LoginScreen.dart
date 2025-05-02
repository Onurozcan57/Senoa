import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:senoa/DiyAnaSayfa.dart';
import 'package:senoa/Diyetisyenim.dart';
import 'dart:convert';
import 'AnaSayfa.dart';

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
            image: AssetImage(
                "lib/assets/girisekrani.jpg"), // Arkaplan resmi ekleniyor
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Diyetisyen ve Kullanıcı seçim butonları
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Diyetisyen butonu
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: isDietitian
                            ? Colors.green.shade700
                            : Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isDietitian = true;
                          });
                        },
                        child: Text(
                          "Diyetisyen",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Kullanıcı butonu
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: !isDietitian
                            ? Colors.blue.shade700
                            : Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isDietitian = false;
                          });
                        },
                        child: Text(
                          "Kullanıcı",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Email giriş alanı
                TextFormField(
                  controller: _emailController, // Bu satır eklendi
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                SizedBox(height: 10),
                // Şifre giriş alanı
                TextFormField(
                  controller: _passwordController, // Bu satır eklendi
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                SizedBox(height: 20),
                // Giriş butonu
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5, // Gölgelendirme efekti
                  ),
                  onPressed: () async {
                    print(
                        'Gönderilen Rol: ${isDietitian ? 'dietitian' : 'user'}');
                    // Kullanıcının girdiği e-posta ve şifreyi al
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();
                    String role =
                        isDietitian ? 'dietitian' : 'user'; // Rol bilgisini al

                    // API endpoint'i
                    final String apiUrl = 'http://10.0.2.2:3000/login';

                    try {
                      // POST isteği gönder
                      final response = await http.post(
                        Uri.parse(apiUrl),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(<String, String>{
                          'email': email,
                          'password': password,
                          'role': role, // Rol bilgisini gönder
                        }),
                      );

                      // API'den gelen cevabı işle
                      if (response.statusCode == 200) {
                        // Giriş başarılı
                        final Map<String, dynamic> responseData =
                            jsonDecode(response.body);
                        String message = responseData['message'];
                        String token =
                            responseData['token']; // Eğer token dönüyorsa
                        String userRole =
                            responseData['role']; // Gelen rol bilgisini al

                        // Burada başarılı giriş sonrası işlemleri yapabilirsiniz
                        print(
                            'Giriş Başarılı: $message, Token: $token, Rol: $userRole');

                        // Kullanıcıyı rolüne göre doğru sayfaya yönlendir
                        if (userRole == 'dietitian') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Diyanasayfa()), // DiyAnaSayfa.dart
                          );
                        } else if (userRole == 'user') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Anasayfa()), // AnaSayfa.dart
                          );
                        }
                      } else {
                        // Giriş başarısız
                        final Map<String, dynamic> responseData =
                            jsonDecode(response.body);
                        String errorMessage = responseData['message'];

                        // Kullanıcıya hata mesajını göster
                        print('Giriş Başarısız: $errorMessage');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)),
                        );
                      }
                    } catch (error) {
                      // İstek sırasında bir hata oluştu
                      print('Hata oluştu: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Sunucuya bağlanırken bir hata oluştu.')),
                      );
                    }
                  },
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Kayıt ol bağlantısı
                TextButton(
                  onPressed: () {
                    _showRegisterPopup(context);
                  }, //fonksiyonun çalışması
                  child: Text(
                    "Hesabın yok mu? --> Kayıt ol",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 100, 246, 146),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
}

void _showRegisterPopup(BuildContext context) {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  DateTime? selectedDate;

  String? phoneError;
  String? emailError;
  String? passwordError;
  String? dateError;

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
                  _customInputField(phoneController, "Telefon Numarası"),
                  if (phoneError != null)
                    Text(phoneError!,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 12)),
                  _customInputField(emailController, "Email"),
                  if (emailError != null)
                    Text(emailError!,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 12)),
                  _customInputField(passwordController, "Şifre", obscure: true),
                  if (passwordError != null)
                    Text(passwordError!,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 12)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        "Doğum Tarihi: ",
                        style: TextStyle(color: Colors.black87),
                      ),
                      Text(
                        selectedDate == null
                            ? "Seçilmedi"
                            : "${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today,
                            color: Color(0xFFD69C6C)),
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xFFD69C6C),
                                    onPrimary: Colors.white,
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
                              dateError = null;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  if (dateError != null)
                    Text(dateError!,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 12)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        phoneError = phoneController.text.length < 10
                            ? "Geçerli bir telefon girin"
                            : null;
                        emailError = !emailController.text.contains('@')
                            ? "Geçerli email girin"
                            : null;
                        passwordError = passwordController.text.length < 6
                            ? "Şifre en az 6 karakter olmalı"
                            : null;
                        dateError =
                            selectedDate == null ? "Doğum tarihi seçin" : null;
                      });

                      if (phoneError == null &&
                          emailError == null &&
                          passwordError == null &&
                          dateError == null) {
                        Navigator.pop(context);
                        _showBodyWeightPopup(
                            context); // Sonraki popup burada çağrılır
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
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xFFF5E7DC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          "Boy & Kilo",
          style: TextStyle(color: Colors.black87),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _customInputField(heightController, "Boy (cm)"),
            _customInputField(weightController, "Kilo (kg)"),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // heightController.text ve weightController.text alınabilir
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD69C6C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Kayıt Ol"),
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
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
