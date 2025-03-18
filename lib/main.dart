import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRegistering = false;
  bool _isForgotPassword = false;
  final _formKey = GlobalKey<FormState>(); // Form validation key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/girisekrani.jpg"), // Arka plan resmi
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.5), // Opak bir renk ekliyoruz
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Butonlar için üst satır
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // Buton rengi
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Diyetisyen",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(width: 20), // Butonlar arasında boşluk
                        ElevatedButton(
                          onPressed: () {
                            print("Kullanıcı Seçildi");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // Buton rengi
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Kullanıcı",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    // E-posta ve Şifre giriş alanları
                    Form(
                      key: _formKey, // Form key
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            // E-posta girişi
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: "E-posta",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                // E-posta formatını kontrol et
                                if (value == null || value.isEmpty) {
                                  return 'E-posta boş olamaz';
                                }
                                final emailRegExp = RegExp(
                                    r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                if (!emailRegExp.hasMatch(value)) {
                                  return 'Geçerli bir e-posta giriniz';
                                }
                                return null;
                              },
                            ),
                            Divider(color: Colors.grey),
                            // Şifre girişi
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: "Şifre",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                              ),
                              obscureText: true,
                              validator: (value) {
                                // Şifre kontrolü
                                if (value == null || value.isEmpty) {
                                  return 'Şifre boş olamaz';
                                }
                                if (value.length < 6) {
                                  return 'Şifre en az 6 karakter olmalıdır';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Form geçerliyse işlem yap
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          // Burada backend'e gönderilebilir
                          if (email == 'test@example.com' &&
                              password == '123456') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Başarıyla giriş yapıldı!")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Geçersiz e-posta veya şifre")),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 139, 180, 220), // Buton rengi
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Giriş Yap",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (!_isRegistering && !_isForgotPassword) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isForgotPassword = true;
                              });
                            },
                            child: Text(
                              "Şifremi Unuttum?",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isRegistering = true;
                              });
                            },
                            child: Text(
                              "Hesabın yok mu? Kayıt Ol",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ] else if (_isForgotPassword) ...[
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Yeni Şifre",
                          filled: true,
                          fillColor: Colors.white.withAlpha(5),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text("Şifre sıfırlama işlemi başarılı")),
                          );
                          setState(() {
                            _isForgotPassword = false;
                          });
                        },
                        child: Text("Şifreyi Sıfırla"),
                      ),
                    ] else if (_isRegistering) ...[
                      TextField(
                        decoration: InputDecoration(labelText: "Kullanıcı Adı"),
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "E-posta"),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "Şifre"),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Kayıt işlemi başarılı")),
                          );
                          setState(() {
                            _isRegistering = false;
                          });
                        },
                        child: Text("Kayıt Ol"),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
