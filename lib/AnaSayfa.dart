import 'dart:async';
import 'package:flutter/material.dart';
import 'AkisSayfasi.dart';
import 'package:senoa/Diyetisyenim.dart';
import 'package:table_calendar/table_calendar.dart';

// Akış sayfası için yeni sınıf ekledik
class AkisSayfasi extends StatelessWidget {
  const AkisSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akış'),
        backgroundColor: const Color.fromARGB(255, 13, 255, 0),
      ),
      body: const Center(
        child: Text('Akış sayfası içeriği buraya gelecek'),
      ),
    );
  }
}

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
  int currentPageIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  void _showGif(BuildContext context, String hareketAdi, String giffYolu) {
    final gifPath = _getGifPath(hareketAdi);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(hareketAdi),
        content: Image.asset(giffYolu),
        actions: [
          TextButton(
            child: const Text("Kapat"),
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
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: const DecorationImage(
              image: AssetImage('lib/assets/girisekrani.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  baslik,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  aciklama,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text("Show more"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text("Kapat"),
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
    int currentIndex = 0;
    int remainingSeconds = 10;
    late Timer timer;

    void startTimer(StateSetter setState) {
      remainingSeconds = 45;
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (remainingSeconds == 0) {
          t.cancel();
          if (currentIndex < hareketler.length - 1) {
            currentIndex++;
            startTimer(setState);
          } else {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("TEBRİKLER:)"),
                content: const Text("Tüm Egzersizleri Tamamladınız."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Kapat"),
                  )
                ],
              ),
            );
          }
        } else {
          setState(() {
            remainingSeconds--;
          });
        }
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          if (remainingSeconds == 10 && currentIndex == 0) {
            startTimer(setState);
          }

          String hareketAdi = hareketler[currentIndex];
          String gifPath = _getGifPath(hareketAdi);

          return AlertDialog(
            title: Text("$title\n(${currentIndex + 1}/${hareketler.length})"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hareketAdi,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Image.asset(gifPath, height: 150),
                const SizedBox(height: 10),
                Text(
                  "$remainingSeconds saniye",
                  style: const TextStyle(fontSize: 28, color: Colors.red),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    timer.cancel();
                    if (currentIndex < hareketler.length - 1) {
                      currentIndex++;
                      startTimer(setState);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Geç (İleri)"),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget PaketKart(String baslik, String aciklama, String arkaPlan,
      {VoidCallback? onTap}) {
    return Container(
      width: 200,
      height: 200,
      margin: const EdgeInsets.all(10),
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
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
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
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Diyetisyenlik Uygulaması'),
        backgroundColor: const Color(0xFFD69C6C),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color(0xFFD69C6C),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_box),
            icon: Icon(Icons.account_box_outlined),
            label: 'Profilim',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.assignment_ind_rounded),
            icon: Badge(child: Icon(Icons.assignment_ind_outlined)),
            label: 'Diyetisyenim',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.messenger),
            icon: Icon(Icons.messenger_outline),
            label: 'Messages',
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top,
              width: double.infinity,
              color: const Color(0xFFD69C6C),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: SafeArea(
                child: const Text(
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
                    title: const Text('Diyetisyenim'),
                    onTap: () {
                      Navigator.pop(context); // Drawer'ı kapatır
                      Navigator.push(
                        // Akış sayfasını açar
                        context,
                        MaterialPageRoute(builder: (context) => Diyetisyenim()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("Akış"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FeedPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Profilim'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Çıkış'),
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/girisekrani.jpg"),
            fit: BoxFit.cover,
            opacity: 0.07,
          ),
        ),
        child: SingleChildScrollView(
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
                  headerStyle: const HeaderStyle(
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  calendarStyle: const CalendarStyle(
                    todayTextStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskController,
                        decoration: const InputDecoration(
                          labelText: "Görev Ekle",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
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
              SizedBox(
                height: 130,
                child: _tasks[_selectedDay] == null ||
                        _tasks[_selectedDay]!.isEmpty
                    ? const Center(child: Text("Bu gün için görev yok."))
                    : ListView.builder(
                        itemCount: _tasks[_selectedDay]!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_tasks[_selectedDay]![index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
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
              const SizedBox(height: 20),
              SizedBox(
                height: 75,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.auto_graph_outlined,
                      size: 30,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Alınması Gereken Kalori Miktarı:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 2500),
                          duration: const Duration(seconds: 3),
                          builder: (context, value, child) {
                            return Text(
                              "${value.toStringAsFixed(0)} Kcal",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Diyetisyenler',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 250,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      PaketKart(
                          'Selahattin Durmaz',
                          'Günlük öneriler, basit takip.',
                          "lib/assets/diyetisyenArkaPlan.jpg"),
                      PaketKart(
                          'Premium Paket',
                          'Özel diyet listeleri, haftalık analizler.',
                          "lib/assets/d3.jpeg"),
                      PaketKart(
                          'VIP Paket',
                          'Kişisel diyetisyen, gelişmiş analiz.',
                          "lib/assets/d3.jpeg"),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Egzersiz Bölümü',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 250,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      PaketKart(
                        'SIRT VE BACAK EGZERSİZİ PROGRAMI',
                        'Isınma hareketleri, Sırt kasları ve bacak kasları için hareketler',
                        "lib/assets/fitnessArkaPlan.jpg",
                        onTap: () => _showExercisePopup(
                          context,
                          'Sırt ve Bacak Egzersizleri',
                          ["Deadlift", "Squat", "Leg Press", "Barbell Row"],
                        ),
                      ),
                      PaketKart(
                        'GÖĞÜS VE ÖN KOL PROGRAMI',
                        'Isınma hareketleri, Gögüs ve ön kol kasları için hareketler',
                        "lib/assets/fitnessArkaPlan.jpg",
                        onTap: () => _showExercisePopup(
                          context,
                          "Göğüs ve Ön Kol Egzersizleri",
                          [
                            "Bench Press",
                            "Incline Dumbell Press",
                            "Biceps Curl"
                          ],
                        ),
                      ),
                      PaketKart(
                        'OMUZ VE ARKA KOL PROGRAMI',
                        'Isınma hareketleri, Omuz ve Arka kol kasları için hareketler',
                        "lib/assets/fitnessArkaPlan.jpg",
                        onTap: () => _showExercisePopup(
                          context,
                          "Omuz ve Arka Kol Programı",
                          ["Shoulder Press", "Lateral Raise", "Triceps Dips"],
                        ),
                      ),
                      PaketKart(
                        'FULL BODY PROGRAM',
                        'Bu egzersiz programı bütün kas gruplarını çalıştırmak içindir.',
                        "lib/assets/fitnessArkaPlan.jpg",
                        onTap: () => _showExercisePopup(
                          context,
                          "Full Body Egzersizleri",
                          ["Squats", "Push-ups", "Deadlifts", "Pull-ups"],
                        ),
                      ),
                      PaketKart(
                        "KARDİYO PROGRAMI",
                        "Yağ yağmak ve ödem atmak için egzersizler",
                        "lib/assets/fitnessArkaPlan.jpg",
                        onTap: () => _showExercisePopup(
                          context,
                          "Kardiyo Egzersizleri",
                          [
                            "Running",
                            "Cycling",
                            "Jumping Jacks",
                            "Mountain Climbers"
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
      ),
    );
  }
}
