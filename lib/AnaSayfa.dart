import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  int _seciliKart = -1;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _tasks = {};
  TextEditingController _taskController = TextEditingController();

  // GlobalKey<ScaffoldState> kullanıyoruz
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ⬇ Fonksiyonu buraya yazıyorsun
  String _getGifPath(String hareketAdi) {
    switch (hareketAdi) {
      case "Barbell Row":
        return "lib/assets/gifs/barbellRow.gif";
      case "Deadlift":
        return "lib/assets/gifs/deadlift.gif";
      case "Squat":
        return "lib/assets/gifs/squat.gif";
      case "Leg Press":
        return "lib/assets/gifs/legpress.gif";
      case "Bench Press":
        return "lib/assets/gifs/benchPress.gif";
      case "Incline Dumbell Press":
        return "lib/assets/gifs/inclinee.gif";
      case "Biceps Curl":
        return "lib/assets/gifs/bicepsCurl.gif";
      case "Shoulder Press":
        return "lib/assets/gifs/shoulderPress.gif";
      case "Lateral Raise":
        return "lib/assets/gifs/latereal.gif";
      case "Triceps Dips":
        return "lib/assets/gifs/dips.gif";
      case "Squats":
        return "lib/assets/gifs/squat.gif";
      case "Push-ups":
        return "lib/assets/gifs/pushUp.gif";
      case "Deadlifts":
        return "lib/assets/gifs/deadlift.gif";
      case "Pull-ups":
        return "lib/assets/gifs/pullUps.gif";
      case "Running":
        return "lib/assets/gifs/running.gif";
      case "Cycling":
        return "lib/assets/gifs/cycling.gif";
      case "Jumping Jacks":
        return "lib/assets/gifs/jmp.gif";
      case "Mountain Climbers":
        return "lib/assets/gifs/mountain.gif";
      default:
        return "lib/assets/gifs/default.gif";
    }
  }

  // Diğer metodların burada devam eder...
  // örneğin _showGif() buradaysa onunla beraber durabilir
  void _showGif(BuildContext context, String hareketAdi, String giffYolu) {
    final gifPath = _getGifPath(hareketAdi);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(hareketAdi),
        content: Image.asset(giffYolu),
        actions: [
          TextButton(
            child: Text("Kapat"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showPopup(BuildContext context, String baslik, String aciklama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent, // Arka planı şeffaf yapıyoruz
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.zero, // İçeriği tam olarak yerleştiriyoruz
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), // Köşeleri yuvarla
            image: DecorationImage(
              image: AssetImage('lib/assets/girisekrani.jpg'), // Resmin yolu
              fit: BoxFit.cover, // Resmi kapsayıcı şekilde yerleştir
            ),
          ),
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
                    color: Colors.white, // Başlık rengi
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
                    color: Colors.white, // İçerik rengi
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
                      foregroundColor: Colors.blue,
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

  void _showExercisePopup(
      BuildContext context, String title, List<String> hareketler) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 13, 255, 0),
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: hareketler.length,
              itemBuilder: (context, index) {
                final hareketAdi = hareketler[index];
                final giffYolu = _getGifPath(hareketAdi);
                return ListTile(
                  title: Text(hareketAdi),
                  onTap: () => _showGif(context, hareketAdi, giffYolu),
                );
              }),
        ),
        actions: [
          TextButton(
            child: Text("Kapat"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget PaketKart(String baslik, String aciklama, String arkaPlan,
      {VoidCallback? onTap}) {
    return Container(
      width: 200,
      height: 200,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          opacity: 0.6,
          image: AssetImage(arkaPlan),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap ?? () => _showPopup(context, baslik, aciklama),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                baslik,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(aciklama, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Scaffold'a global key ekledik
      resizeToAvoidBottomInset: true, // Klavye açıldığında taşmayı önler
      appBar: AppBar(
        title: Text('Diyetisyenlik Uygulaması'),
        backgroundColor: Color.fromARGB(255, 13, 255, 0),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Hamburger menü butonuna basıldığında Drawer'ı açar
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
              color: Color.fromARGB(255, 13, 255, 0),
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
                    title: Text('Profilim'),
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
              padding: const EdgeInsets.all(16.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 20),
                lastDay: DateTime.utc(2060, 10, 20),
                focusedDay: _selectedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                },
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  todayTextStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Görev ekleme alanı
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        labelText: "Görev Ekle",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (_taskController.text.isNotEmpty) {
                        setState(() {
                          _tasks[_selectedDay] = _tasks[_selectedDay] ?? [];
                          _tasks[_selectedDay]!.add(_taskController.text);
                          _taskController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            // Seçilen güne ait görevler
            SizedBox(
              height: 200, // Yükseklik vererek overflow hatasını önlüyoruz
              child:
                  _tasks[_selectedDay] == null || _tasks[_selectedDay]!.isEmpty
                      ? Center(child: Text("Bu gün için görev yok."))
                      : ListView.builder(
                          itemCount: _tasks[_selectedDay]!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_tasks[_selectedDay]![index]),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _tasks[_selectedDay]!.removeAt(index);
                                  });
                                },
                              ),
                            );
                          },
                        ),
            ),

            SizedBox(
              height: 75,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_graph_outlined,
                    size: 30, // İkonun boyutunu büyütüyoruz
                    color: Colors.green, // İkonun rengini yeşil yapıyoruz
                  ),
                  SizedBox(width: 10), // İkon ile yazı arasına boşluk ekliyoruz
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Alınması Gereken Kalori Miktarı:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700], // Yazı rengini gri yapıyoruz
                        ),
                      ),
                      TweenAnimationBuilder(
                        tween: Tween<double>(
                            begin: 0, end: 2500), // Başlangıç ve bitiş değeri
                        duration: Duration(seconds: 3), // Animasyon süresi
                        builder: (context, value, child) {
                          return Text(
                            "${value.toStringAsFixed(0)} Kcal",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .green, // Animasyonlu kalori miktarını yeşil yapıyoruz
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Diyetisyenler',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Paket Kartları
            SizedBox(
              height: 250, // Kartların yüksekliği için sabit alan
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    PaketKart(
                        'Selahattin Durmaz',
                        'Günlük öneriler, basit takip.',
                        "lib/assets/arkaPlan3.jpg"),
                    PaketKart(
                        'Premium Paket',
                        'Özel diyet listeleri, haftalık analizler.',
                        "lib/assets/arkaPlan.jpg"),
                    PaketKart(
                        'VIP Paket',
                        'Kişisel diyetisyen, gelişmiş analiz.',
                        "lib/assets/arkaPlan2.jpg"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Egzersiz Bölümü',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Paket Kartları
            SizedBox(
              height: 250, // Kartların yüksekliği için sabit alan
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    PaketKart(
                      'SIRT VE BACAK EGZERSİZİ PROGRAMI',
                      'Isınma hareketleri, Sırt kasları ve bacak kasları için hareketler',
                      "lib/assets/arkaPlan3.jpg",
                      onTap: () => _showExercisePopup(
                        context,
                        'Sırt ve Bacak Egzersizleri',
                        [
                          "Deadlift",
                          "Squat",
                          "Leg Press",
                          "Barbell Row",
                        ],
                      ),
                    ),
                    PaketKart(
                      'GÖĞÜS VE ÖN KOL PROGRAMI',
                      'Isınma hareketleri, Gögüs ve ön kol kasları için hareketler',
                      "lib/assets/arkaPlan.jpg",
                      onTap: () => _showExercisePopup(
                        context,
                        "Göğüs ve Ön Kol Egzersizleri",
                        [
                          "Bench Press",
                          "Incline Dumbell Press",
                          "Biceps Curl",
                        ],
                      ),
                    ),
                    PaketKart(
                      'OMUZ VE ARKA KOL PROGRAMI',
                      'Isınma hareketleri, Omuz ve Arka kol kasları için hareketler',
                      "lib/assets/arkaPlan2.jpg",
                      onTap: () => _showExercisePopup(
                        context,
                        "Omuz ve Arka Kol Programı",
                        [
                          "Shoulder Press",
                          "Lateral Raise",
                          "Triceps Dips",
                        ],
                      ),
                    ),
                    PaketKart(
                      'FULL BODY PROGRAM',
                      'Bu egzersiz programı bütün kas gruplarını çalıştırmak içindir.',
                      "lib/assets/arkaPlan.jpg",
                      onTap: () => _showExercisePopup(
                        context,
                        "Full Body Egzersizleri",
                        [
                          "Squats",
                          "Push-ups",
                          "Deadlifts",
                          "Pull-ups",
                        ],
                      ),
                    ),
                    PaketKart(
                      "KARDİYO PROGRAMI",
                      "Yağ yağmak ve ödem atmak için egzersizler",
                      "lib/assets/arkaPlan.jpg",
                      onTap: () => _showExercisePopup(
                        context,
                        "Kardiyo Egzersizleri",
                        [
                          "Running",
                          "Cycling",
                          "Jumping Jacks",
                          "Mountain Climbers",
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
