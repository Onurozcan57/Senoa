import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senoa/Diyetisyenler.dart';

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (Diyetisyenler()),
                          ),
                        );
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
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: dietitianData['image'] !=
                                          null
                                      ? NetworkImage(dietitianData['image'])
                                          as ImageProvider
                                      : AssetImage(
                                          dietitianData['gender'] == 'female'
                                              ? 'lib/assets/kadin.png'
                                              : dietitianData['gender'] ==
                                                      'male'
                                                  ? 'lib/assets/erekk.jpeg'
                                                  : 'assets/images/default_avatar.png',
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
                                          Expanded(
                                            // <== BU satırı ekle
                                            child: Text(
                                              dietitianData['email'] ??
                                                  'Belirtilmemiş',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[700],
                                              ),
                                              softWrap:
                                                  true, // Satıra sığmazsa alta geçsin
                                              overflow: TextOverflow
                                                  .visible, // Taşma olmasın
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            MealCard(
                              mealTime: "Öğle Yemeği",
                              meal: "Izgara Tavuk + Bulgur + Yoğurt",
                              portion: "1 porsiyon",
                              calories: "450",
                              imageAsset: "lib/assets/yulaf.jpeg",
                            ),
                            MealCard(
                              mealTime: "Öğle Yemeği",
                              meal: "Izgara Tavuk + Bulgur + Yoğurt",
                              portion: "1 porsiyon",
                              calories: "450",
                              imageAsset: "lib/assets/kinoa.jpg",
                            ),
                            MealCard(
                              mealTime: "Öğle Yemeği",
                              meal: "Izgara Tavuk + Bulgur + Yoğurt",
                              portion: "1 porsiyon",
                              calories: "450",
                              imageAsset: "lib/assets/tart.jpg",
                            ),
                          ],
                        ),
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
  final String portion;
  final String calories;
  final String imageAsset;

  const MealCard({
    Key? key,
    required this.mealTime,
    required this.meal,
    required this.portion,
    required this.calories,
    required this.imageAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          _showPopup(context, mealTime, meal, portion, calories, imageAsset),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: const Color.fromARGB(255, 198, 233, 212),
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imageAsset,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealTime,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D3D3D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meal,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF555555),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$portion | $calories kcal",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Color(0xFF58A399)),
            ],
          ),
        ),
      ),
    );
  }
}

void _showPopup(BuildContext context, String title, String meal, String portion,
    String calories, String imageAsset) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFA8D5BA),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imageAsset,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D3D3D),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                meal,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF444444),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Porsiyon: $portion\nKalori: $calories kcal",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Detaylı besin içeriği vs. açılabilir
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text("Detay"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF58A399),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Kapat"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF3D3D3D),
                      side: const BorderSide(color: Color(0xFF58A399)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
