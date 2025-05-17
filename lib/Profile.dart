import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senoa/LoginScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:senoa/CanliDestekPage.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isDietitian = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      String userId = _auth.currentUser!.uid;

      // Önce diyetisyen koleksiyonunda ara
      DocumentSnapshot dietitianDoc =
          await _firestore.collection('dietitians').doc(userId).get();

      if (dietitianDoc.exists) {
        setState(() {
          isDietitian = true;
          userData = dietitianDoc.data() as Map<String, dynamic>;
        });
      } else {
        // Diyetisyen değilse users koleksiyonunda ara
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();

        if (userDoc.exists) {
          setState(() {
            isDietitian = false;
            userData = userDoc.data() as Map<String, dynamic>;
          });
        }
      }
    } catch (e) {
      print('Veri yükleme hatası: $e');
    }
  }

  File? _secilenResim;

  Future<void> _galeridenResimSec() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _secilenResim = File(pickedFile.path);
      });
    }
  }

  Future<void> _changePassword() async {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFA8D5BA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Şifre Değiştir', style: TextStyle(color: Colors.black87)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mevcut Şifre',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Yeni Şifre',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Yeni Şifre (Tekrar)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
            style: TextButton.styleFrom(foregroundColor: Colors.black87),
          ),
          ElevatedButton(
            onPressed: () async {
              final currentPassword = currentPasswordController.text;
              final newPassword = newPasswordController.text;
              final confirmPassword = confirmPasswordController.text;

              if (newPassword != confirmPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Yeni şifreler eşleşmiyor')),
                );
                return;
              }

              try {
                final user = _auth.currentUser;
                if (user != null && user.email != null) {
                  // Yeniden doğrulama (required by Firebase)
                  final cred = EmailAuthProvider.credential(
                    email: user.email!,
                    password: currentPassword,
                  );

                  await user.reauthenticateWithCredential(cred);
                  await user.updatePassword(newPassword);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Şifre başarıyla değiştirildi')),
                  );
                  Navigator.pop(context);
                }
              } on FirebaseAuthException catch (e) {
                String message = 'Şifre değiştirme işlemi başarısız oldu';
                if (e.code == 'wrong-password') {
                  message = 'Mevcut şifre yanlış';
                } else if (e.code == 'weak-password') {
                  message = 'Yeni şifre çok zayıf';
                } else if (e.code == 'requires-recent-login') {
                  message =
                      'Güvenlik nedeniyle tekrar giriş yapmanız gerekiyor';
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
            },
            child: Text('Değiştir'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF58A399),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editProfile() async {
    final TextEditingController nameController =
        TextEditingController(text: userData!['nameSurname']);
    final TextEditingController emailController =
        TextEditingController(text: userData!['email']);
    String? selectedGender = userData!['gender'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFA8D5BA), // senin arkaplan rengin
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Profili Düzenle',
          style: TextStyle(color: Colors.black87),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Ad Soyad',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cinsiyet",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title:
                                Text('Kadın', style: TextStyle(fontSize: 14)),
                            value: 'female',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            activeColor: Color(0xFF58A399),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title:
                                Text('Erkek', style: TextStyle(fontSize: 14)),
                            value: 'male',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            activeColor: Color(0xFF58A399),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
            style: TextButton.styleFrom(foregroundColor: Colors.black87),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .update({
                  'nameSurname': nameController.text,
                  'email': emailController.text,
                  'gender': selectedGender,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profil başarıyla güncellendi')),
                );
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Güncelleme sırasında bir hata oluştu')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF58A399),
              foregroundColor: Colors.white,
            ),
            child: Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data?.data() as Map<String, dynamic>?;
          if (userData == null) {
            return Center(child: Text('Kullanıcı bilgileri bulunamadı'));
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFA8D5BA),
                  Colors.white,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200, // Hafif gri arka plan
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: _secilenResim != null
                              ? FileImage(_secilenResim!)
                              : userData['gender'] == 'female'
                                  ? const AssetImage("lib/assets/kadin.png")
                                  : userData['gender'] == 'male'
                                      ? const AssetImage(
                                          "lib/assets/erekk.jpeg")
                                      : const AssetImage(
                                              "lib/assets/default_avatar.png")
                                          as ImageProvider,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _galeridenResimSec,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade700.withOpacity(0.8),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    userData['nameSurname'] ?? 'İsimsiz',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    userData['email'] ?? 'E-posta yok',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 40),
                  _buildInfoCard(
                    title: 'Kişisel Bilgiler',
                    children: [
                      _buildInfoRow(
                        Icons.cake,
                        'Doğum Tarihi',
                        DateTime.parse(userData['birthDate'])
                            .toString()
                            .split(' ')[0],
                      ),
                      _buildInfoRow(
                        Icons.height,
                        'Boy',
                        '${userData['height']} cm',
                      ),
                      _buildInfoRow(
                        Icons.monitor_weight,
                        'Kilo',
                        '${userData['weight']} kg',
                      ),
                      _buildInfoRow(
                        Icons.person,
                        'Cinsiyet',
                        userData['gender'] == 'female'
                            ? 'Kadın'
                            : userData['gender'] == 'male'
                                ? 'Erkek'
                                : 'Belirtilmemiş',
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildInfoCard(
                    title: 'Hesap İşlemleri',
                    children: [
                      ListTile(
                        onTap: _editProfile,
                        leading: Icon(Icons.edit, color: Color(0xFF58A399)),
                        title: Text('Profili Düzenle'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                      ListTile(
                        onTap: _changePassword,
                        leading: Icon(Icons.password, color: Color(0xFF58A399)),
                        title: Text('Şifremi Değiştir'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                      ListTile(
                        onTap: () async {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'onur.islem57@gmail.com',
                            query: Uri.encodeFull(
                                'subject=Geri Bildirim&body=Uygulama hakkında...'),
                          );

                          if (await canLaunchUrl(emailLaunchUri)) {
                            await launchUrl(emailLaunchUri);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Mail uygulaması açılamadı')),
                            );
                          }
                        },
                        leading: Icon(Icons.info, color: Color(0xFF58A399)),
                        title: Text('Geri Bildirim Gönder'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text('Canlı Destek'),
                                  backgroundColor: Color(0xFFA8D5BA),
                                  centerTitle: true,
                                ),
                                body: _buildContactSection(),
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.phone, color: Color(0xFF58A399)),
                        title: Text('Bize Ulaşın/Canlı Destek'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                      ListTile(
                        onTap: () async {
                          await _auth.signOut();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        },
                        leading: Icon(Icons.logout, color: Colors.red),
                        title: Text('Çıkış Yap',
                            style: TextStyle(color: Colors.red)),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
      {required String title, required List<Widget> children}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF58A399),
            ),
          ),
          SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF58A399), size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bize Ulaşın',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildContactItem(
            Icons.email,
            'Email',
            'info@senoa.com',
            () {
              // Email işlemi
            },
          ),
          _buildContactItem(
            Icons.phone,
            'Telefon',
            '+90 555 123 4567',
            () {
              // Telefon işlemi
            },
          ),
          _buildContactItem(
            Icons.location_on,
            'Adres',
            'İstanbul, Türkiye',
            () {
              // Adres işlemi
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
      IconData icon, String label, String value, VoidCallback onPressed) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Text(value),
      onTap: onPressed,
    );
  }
}
