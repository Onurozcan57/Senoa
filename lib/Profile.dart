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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    child: Column(
                      children: [
                        GestureDetector(
                            onTap: _galeridenResimSec,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: _secilenResim != null
                                      ? FileImage(_secilenResim!)
                                      : const AssetImage(
                                              "lib/assets/Onur_Ozcan.png")
                                          as ImageProvider,
                                ),
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.05),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(height: 20),
                        Text(
                          userData!['nameSurname'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userData!['email'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildInfoCard(
                            'Doğum Tarihi',
                            DateTime.parse(userData!['birthDate'])
                                .toString()
                                .split(' ')[0]),
                        if (!isDietitian) ...[
                          _buildInfoCard('Boy', '${userData!['height']} cm'),
                          _buildInfoCard('Kilo', '${userData!['weight']} kg'),
                        ],
                        _buildInfoCard('Hesap Türü',
                            isDietitian ? 'Diyetisyen' : 'Kullanıcı'),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Card(
                        color: Color.fromARGB(250, 249, 255, 255),
                        elevation: 3,
                        margin: EdgeInsets.all(3),
                        child: ListTile(
                          onTap: () {},
                          title: Text(
                            "Profil Bilgilerimi Düzenle",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: const Color.fromARGB(255, 26, 31, 26),
                            ),
                          ),
                          leading: Icon(
                            Icons.person,
                            size: 45,
                            color: const Color(0xFF58A399),
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      color: Color.fromARGB(250, 249, 255, 255),
                      elevation: 10,
                      margin: EdgeInsets.all(3),
                      child: ListTile(
                        onTap: () {},
                        title: Text(
                          "Şifremi Değiştir",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: const Color.fromARGB(255, 26, 31, 26),
                          ),
                        ),
                        leading: Icon(
                          Icons.password,
                          size: 45,
                          color: const Color(0xFF58A399),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      color: Color.fromARGB(250, 249, 255, 255),
                      elevation: 10,
                      margin: EdgeInsets.all(3),
                      child: ListTile(
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
                        title: Text(
                          "Geri Bildirim Gönder",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: const Color.fromARGB(255, 26, 31, 26),
                          ),
                        ),
                        leading: Icon(
                          Icons.info,
                          size: 45,
                          color: const Color(0xFF58A399),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      color: Color.fromARGB(250, 249, 255, 255),
                      elevation: 10,
                      margin: EdgeInsets.all(3),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => CanliDestekPage()),
                          );
                        },
                        title: Text(
                          "Bize Ulaşın/Canlı Destek",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: const Color.fromARGB(255, 26, 31, 26),
                          ),
                        ),
                        leading: Icon(
                          Icons.phone,
                          size: 45,
                          color: const Color(0xFF58A399),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      color: Color.fromARGB(250, 249, 255, 255),
                      elevation: 10,
                      margin: EdgeInsets.all(3),
                      child: ListTile(
                        onTap: () async {
                          await _auth.signOut();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        },
                        title: Text(
                          "Çıkış",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: const Color.fromARGB(255, 26, 31, 26),
                          ),
                        ),
                        leading: Icon(
                          Icons.output_sharp,
                          size: 45,
                          color: const Color(0xFF58A399),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      color: Color.fromARGB(255, 222, 221, 221),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
