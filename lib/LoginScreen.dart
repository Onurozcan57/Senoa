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
                                    Diyetisyenim()), // Diyetisyenim.dart
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
                  onPressed: () {}, //fonksiyonun çalışması
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
