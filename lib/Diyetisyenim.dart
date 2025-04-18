import 'package:flutter/material.dart';

class Diyetisyenim extends StatefulWidget {
  const Diyetisyenim({super.key});

  @override
  State<Diyetisyenim> createState() => _DiyetisyenimState();
}

class _DiyetisyenimState extends State<Diyetisyenim> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _waterController = TextEditingController();
  double _waterIntake = 0;

  void _submitWaterIntake() {
    setState(() {
      _waterIntake = double.tryParse(_waterController.text) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Diyetisyenlik Uygulaması'),
        backgroundColor: Color(0xFF34C759),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top,
              width: double.infinity,
              color: Color(0xFF34C759),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16, bottom: 8),
              child: SafeArea(
                child: Text(
                  'Menü',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    title: Text('Diyetisyenim'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text("Akış"),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Ayarlar'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Çıkış'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                          "lib/assets/girisekrani.jpg",
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
                              "Onur Özcan",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "E-mail: onur.islem57@gmail.com",
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
            SizedBox(height: 10),
            Text(
              "Toplam İçilen Su: ${_waterIntake.toStringAsFixed(1)} L",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            SizedBox(height: 20),
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
