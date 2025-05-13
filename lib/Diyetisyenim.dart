import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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

  List<double> weeklyWaterIntake = [2.5, 3.0, 4.0, 1.5, 3.5, 2.0, 4.5];

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
  }

  void _resetWater() {
    setState(() {
      _waterIntake = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double percent = (_waterIntake / 5.0).clamp(0.0, 1.0);

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
                            "lib/assets/Nisa_Sakar.png", // Profil resmi
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nisanur Şakar",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "E-mail: Nisanur@senoa.com",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey[700]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Tel No: +90 555 555 55 55",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey[700]),
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
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Su miktarı başlık
              Text(
                "💧 Bugün İçilen Su: ${_waterIntake.toStringAsFixed(1)} / $_dailyGoal L",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                      foregroundColor: const Color.fromARGB(255, 71, 54, 136),
                      side: BorderSide(color: Colors.black),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () => _addWater(1.0),
                    child: Text("+1 L"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 71, 54, 136),
                      side: BorderSide(color: Colors.black),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: _resetWater,
                    child: Text("Sıfırla"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 71, 54, 136),
                      side: BorderSide(color: Colors.black),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              // Dairesel su içme gösterge grafiği
              CircularPercentIndicator(
                radius: 90.0,
                lineWidth: 22,
                percent: percent, // % hesaplaması
                center: Text(
                  "${(_waterIntake).toStringAsFixed(1)} L",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.grey.shade200, // Arka plan rengi
                circularStrokeCap: CircularStrokeCap.round, // Yuvarlak kenarlar
                linearGradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 190, 204, 205),
                    Color.fromARGB(255, 18, 80, 204)
                  ], // Gradyan renkler
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              SizedBox(height: 30),

              // Diyet listesi
              Text(
                "Diyet Listem",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String mealTime;
  final String meal;
  final String imageAsset;

  MealCard(
      {required this.mealTime, required this.meal, required this.imageAsset});

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
              color: const Color.fromARGB(255, 48, 68, 160)),
        ),
        subtitle: Text(
          meal,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ),
    );
  }
}

void _showPopup(BuildContext context, String baslik, String aciklama) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color.fromARGB(
          255, 255, 255, 255), // Arka planı şeffaf yapıyoruz
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: EdgeInsets.zero, // İçeriği tam olarak yerleştiriyoruz
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min, // İçeriği minimize et
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                baslik,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 208, 255), // Başlık rengi
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
                  color: const Color.fromARGB(255, 8, 0, 255), // İçerik rengi
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // "Show more" butonuna basıldığında başka bir şey yapılabilir
                  },
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
