import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senoa/LoginScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:senoa/CanliDestekPage.dart';

class DiyProfile extends StatefulWidget {
  const DiyProfile({super.key});

  @override
  State<DiyProfile> createState() => _DiyProfileState();
}

class _DiyProfileState extends State<DiyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('dietitians')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final dietitianData = snapshot.data?.data() as Map<String, dynamic>?;
          if (dietitianData == null) {
            return Center(child: Text('Diyetisyen bilgileri bulunamadı'));
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
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      dietitianData['image'] ??
                          (dietitianData['gender'] == 'female'
                              ? 'https://via.placeholder.com/150?text=Kadın'
                              : dietitianData['gender'] == 'male'
                                  ? 'https://via.placeholder.com/150?text=Erkek'
                                  : 'https://via.placeholder.com/150?text=Belirsiz'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    dietitianData['nameSurname'] ?? 'İsimsiz',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    dietitianData['expertise'] ?? 'Klinik Beslenme Uzmanı',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 40),
                  _buildInfoCard(
                    title: 'İletişim Bilgileri',
                    children: [
                      _buildInfoRow(Icons.email, 'E-posta',
                          dietitianData['email'] ?? 'Belirtilmemiş'),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildInfoCard(
                    title: 'Biyografi',
                    children: [
                      _buildInfoRow(
                        Icons.description,
                        'Biyografi',
                        dietitianData['biography'] ??
                            'Biyografi bilgisi bulunmamaktadır.',
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () => _editProfile(dietitianData),
                    icon: Icon(Icons.edit),
                    label: Text('Profili Düzenle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF58A399),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    icon: Icon(Icons.logout, color: Colors.red),
                    label: Text(
                      'Çıkış Yap',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
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

  Future<void> _editProfile(Map<String, dynamic> dietitianData) async {
    final TextEditingController nameController =
        TextEditingController(text: dietitianData['nameSurname']);
    final TextEditingController emailController =
        TextEditingController(text: dietitianData['email']);
    String? selectedGender = dietitianData['gender'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profili Düzenle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Ad Soyad',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                          child: RadioListTile<String>(
                            title: Text('Kadın'),
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
                            title: Text('Erkek'),
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
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('dietitians')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
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
            child: Text('Kaydet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF58A399),
              foregroundColor: Colors.white,
            ),
          ),
        ],
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
}
