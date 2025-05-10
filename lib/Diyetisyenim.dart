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
  double _dailyGoal = 2.0; // Günlük su içme hedefi
  int currentPageIndex = 0;

  void _submitWaterIntake() {
    setState(() {
      _waterIntake = double.tryParse(_waterController.text) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double percent =
        (_waterIntake / _dailyGoal).clamp(0.0, 1.0); // Yüzde hesaplama

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("lib/assets/girisekrani.jpg"), // Arkaplan resmi
            fit: BoxFit.cover,
            opacity: 0.07),
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _waterController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Litres",
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _submitWaterIntake,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Kaydet"),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            // Dairesel su içme gösterge grafiği
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 13,
              percent: percent,
              center: Text(
                "${(_waterIntake).toStringAsFixed(1)} L",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              progressColor: Colors.blueAccent,
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 20),

            // Su içme girişi

            SizedBox(height: 20),

            // Diyet listesi
            Text(
              "Diyet Listem",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            MealCard(
                mealTime: "Kahvaltı", meal: "Yulaf ezmesi, meyve, yeşil çay"),
            MealCard(
                mealTime: "Öğle",
                meal: "Izgara tavuk, salata, tam tahıllı ekmek"),
            MealCard(mealTime: "Akşam", meal: "Somon, sebzeler, esmer pirinç"),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String mealTime;
  final String meal;

  MealCard({required this.mealTime, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        onTap: () {
          _showPopup(context, mealTime, meal);
        },
        title: Text(
          mealTime,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
        ),
        subtitle: Text(
          meal,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        leading: Icon(
          Icons.restaurant_menu,
          color: Colors.orange,
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
