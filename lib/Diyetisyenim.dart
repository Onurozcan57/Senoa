import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Diyetisyenim extends StatefulWidget {
  const Diyetisyenim({super.key});

  @override
  State<Diyetisyenim> createState() => _DiyetisyenimState();
}

class _DiyetisyenimState extends State<Diyetisyenim> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _waterController = TextEditingController();
  double _waterIntake = 0;
  double _dailyGoal = 5.0; // Günlük su içme hedefi
  int currentPageIndex = 0;

  Future<void> _saveWaterIntake() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('waterIntake', _waterIntake);
  }

  Future<void> _loadWaterIntake() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterIntake = prefs.getDouble('waterIntake') ?? 0.0;
    });
  }

  void _submitWaterIntake() {
    setState(() {
      _waterIntake = double.tryParse(_waterController.text) ?? 0;
    });
  }

  void _addWater(double amount) {
    setState(() {
      _waterIntake += amount;
      if (_waterIntake > _dailyGoal) {
        _waterIntake = _dailyGoal;
      }
    });
    _saveWaterIntake(); // KAYDET
  }

  void _resetWater() {
    setState(() {
      _waterIntake = 0;
    });
    _saveWaterIntake(); // KAYDET
  }

  Future<void> _subscribeToDietitian(String dietitianId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen giriş yapın')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'dietitianId': dietitianId,
        'subscriptionDate': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Diyetisyene başarıyla üye oldunuz')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Üyelik işlemi sırasında bir hata oluştu: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadWaterIntake(); // SharedPreferences'tan veriyi yükle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(
                'Diyetisyenim',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }

            final userData = snapshot.data?.data() as Map<String, dynamic>?;
            final dietitianId = userData?['dietitianId'];

            if (dietitianId == null) {
              return Text(
                'Diyetisyenim',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('dietitians')
                  .doc(dietitianId)
                  .snapshots(),
              builder: (context, dietitianSnapshot) {
                if (!dietitianSnapshot.hasData) {
                  return Text(
                    'Diyetisyenim',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }

                final dietitianData =
                    dietitianSnapshot.data?.data() as Map<String, dynamic>?;
                final dietitianName =
                    dietitianData?['nameSurname'] ?? 'Diyetisyenim';

                return Text(
                  dietitianName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              },
            );
          },
        ),
        backgroundColor: const Color(0xFFA8D5BA),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) {
            return Center(child: Text('Bir hata oluştu'));
          }

          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
          final dietitianId = userData?['dietitianId'];

          if (dietitianId == null) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade100,
                    const Color.fromARGB(255, 114, 246, 182)
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_search,
                      size: 100,
                      color: Colors.blue[700],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Henüz bir diyetisyene üye değilsiniz',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Size en uygun diyetisyeni bulmak için\nhemen üye olun',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/dietitians');
                      },
                      icon: Icon(Icons.search),
                      label: Text('Diyetisyen Bul'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('dietitians')
                .doc(dietitianId)
                .snapshots(),
            builder: (context, dietitianSnapshot) {
              if (dietitianSnapshot.hasError) {
                return Center(child: Text('Bir hata oluştu'));
              }

              if (dietitianSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final dietitianData =
                  dietitianSnapshot.data?.data() as Map<String, dynamic>?;
              if (dietitianData == null) {
                return Center(child: Text('Diyetisyen bulunamadı'));
              }

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade100,
                      const Color.fromARGB(255, 114, 246, 182)
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Kullanıcı bilgileri
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    "lib/assets/Nisa_Sakar.png",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dietitianData['nameSurname'] ??
                                            'İsimsiz',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[900],
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.email_outlined,
                                            color: Colors.blue[700],
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            dietitianData['email'] ??
                                                'Belirtilmemiş',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700],
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
                        ),
                      ),

                      // Su içme takibi
                      SizedBox(height: 20),
                      Text(
                        "Bugün Ne Kadar Su İçtin?",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      // Su miktarı başlık
                      Text(
                        "💧 Bugün İçilen Su: ${_waterIntake.toStringAsFixed(1)} / $_dailyGoal L",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      SizedBox(height: 20),

                      // Butonlar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () => _addWater(0.5),
                            child: Text("+0.5 L"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 71, 54, 136),
                              side: BorderSide(color: Colors.black),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                            ),
                          ),
                          SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: () => _addWater(1.0),
                            child: Text("+1 L"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 71, 54, 136),
                              side: BorderSide(color: Colors.black),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                            ),
                          ),
                          SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: _resetWater,
                            child: Text("Sıfırla"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 71, 54, 136),
                              side: BorderSide(color: Colors.black),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      // Dairesel su içme gösterge grafiği
                      CircularPercentIndicator(
                        radius: 90.0,
                        lineWidth: 22,
                        percent: (_waterIntake / _dailyGoal).clamp(0.0, 1.0),
                        center: Text(
                          "${(_waterIntake).toStringAsFixed(1)} L",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.grey.shade200,
                        circularStrokeCap: CircularStrokeCap.round,
                        linearGradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 190, 204, 205),
                            Color.fromARGB(255, 18, 80, 204)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      SizedBox(height: 30),

                      // Diyet listesi
                      Text(
                        "Diyet Listem",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      MealCard(
                        mealTime: "Sabah",
                        meal: "Yulaf ezmesi, meyve, yeşil çay",
                        imageAsset: "lib/assets/yulaf.jpeg",
                      ),
                      MealCard(
                        mealTime: "Öğle",
                        meal: "Izgara tavuk, salata, tam tahıllı ekmek",
                        imageAsset: "lib/assets/ogle.jpg",
                      ),
                      MealCard(
                        mealTime: "Akşam",
                        meal: "Somon, sebzeler, esmer pirinç",
                        imageAsset: "lib/assets/aksam.png",
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String mealTime;
  final String meal;
  final String imageAsset;

  MealCard({
    required this.mealTime,
    required this.meal,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: ListTile(
        onTap: () {
          _showPopup(context, mealTime, meal);
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imageAsset,
            width: 65,
            height: 95,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          mealTime,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color.fromARGB(255, 48, 68, 160),
          ),
        ),
        subtitle: Text(
          meal,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

void _showPopup(BuildContext context, String baslik, String aciklama) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                baslik,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 208, 255),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                aciklama,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 8, 0, 255),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 191, 255),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text("Show more"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text("Kapat"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
