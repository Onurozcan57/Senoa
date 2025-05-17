import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:senoa/ChatPage.dart';
import 'FeedPage.dart';
import 'package:senoa/Diyetisyenim.dart';
import 'package:table_calendar/table_calendar.dart';
import 'YemekTarifleri.dart';
import 'Profile.dart';
import 'package:senoa/Diyetisyenler.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaketKart extends StatelessWidget {
  final String baslik;
  final String aciklama;
  final String arkaPlan;
  final VoidCallback? onTap;

  const PaketKart(this.baslik, this.aciklama, this.arkaPlan,
      {super.key, this.onTap});

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
                  image: DecorationImage(
                    image: AssetImage(arkaPlan),
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
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 180,
      height: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          opacity: 0.8,
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
                    color: Color.fromARGB(255, 255, 255, 255),
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
}

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class AnaSayfaIcerigi extends StatelessWidget {
  const AnaSayfaIcerigi({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
    required this.taskController,
    required this.onAddTask,
    required this.onDeleteTask,
    required this.getTasksForSelectedDay,
    required this.showExercisePopup,
  });

  final DateTime selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final TextEditingController taskController;
  final VoidCallback onAddTask;
  final Function(int) onDeleteTask;
  final List<String> Function(DateTime) getTasksForSelectedDay;
  final Function(BuildContext, String, List<String>) showExercisePopup;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Color(0xFFF8FAF9),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: KaloriTakipWidget()),
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TableCalendar(
                          firstDay: DateTime.utc(2010, 10, 20),
                          lastDay: DateTime.utc(2060, 10, 20),
                          focusedDay: selectedDay,
                          calendarFormat: CalendarFormat.twoWeeks,
                          availableCalendarFormats: const {
                            CalendarFormat.twoWeeks: '2 Hafta',
                          },
                          selectedDayPredicate: (day) =>
                              isSameDay(day, selectedDay),
                          onDaySelected: (newSelectedDay, focusedDay) {
                            onDaySelected(newSelectedDay, focusedDay);
                            _showAppointmentDialog(context, newSelectedDay);
                          },
                          headerStyle: const HeaderStyle(
                            titleTextStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          calendarStyle: const CalendarStyle(
                            todayTextStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            todayDecoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('appointments')
                              .where('userId',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser?.uid)
                              .where('date',
                                  isEqualTo: Timestamp.fromDate(selectedDay))
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return SizedBox.shrink();
                            }

                            final appointments = snapshot.data!.docs;
                            if (appointments.isEmpty) {
                              return SizedBox.shrink();
                            }

                            return Column(
                              children: appointments.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                return Card(
                                  margin: EdgeInsets.only(top: 8),
                                  child: ListTile(
                                    leading: Icon(Icons.event,
                                        color: Color(0xFF58A399)),
                                    title: Text('Randevu: ${data['time']}'),
                                    subtitle: Text(
                                        'Diyetisyen: ${data['dietitianName']}'),
                                    trailing: IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('appointments')
                                            .doc(doc.id)
                                            .delete();
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const AdimSayarWidget(),
                  const Padding(
                    padding: EdgeInsets.only(top: 35.0),
                    child: Text(
                      'Diyetisyenler',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 500,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('dietitians')
                          .limit(3)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('Bir hata oluştu'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                              child: Text(
                                  'Henüz kayıtlı diyetisyen bulunmamaktadır'));
                        }

                        var dietitians = snapshot.data!.docs.map((doc) {
                          var data = doc.data() as Map<String, dynamic>;
                          return {
                            'id': doc.id,
                            'ad': data['nameSurname'] ?? 'Diyetisyen Adı',
                            'uzmanlik':
                                data['expertise'] ?? 'Klinik Beslenme Uzmanı',
                            'resim':
                                data['image'] ?? 'lib/assets/Onur_Ozcan.png',
                            'gender': data['gender'],
                            'biyografi': data['biography'] ??
                                'Biyografi bilgisi bulunmamaktadır.',
                            'iletisim': {
                              'instagram': data['instagram'] ?? '@diyetisyen',
                              'mail': data['email'] ?? 'Email bilgisi yok',
                              'telefon': data['phone'] ?? '+90 555 555 5555',
                            }
                          };
                        }).toList();

                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                ...dietitians
                                    .map((d) => Card(
                                          color: Colors.white,
                                          shadowColor: Colors.grey,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          elevation: 4,
                                          margin: EdgeInsets.all(16),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.all(12),
                                            leading: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: d['image'] !=
                                                      null
                                                  ? NetworkImage(d['image'])
                                                      as ImageProvider
                                                  : AssetImage(
                                                      d['gender'] == 'female'
                                                          ? 'lib/assets/kadin.png'
                                                          : d['gender'] ==
                                                                  'male'
                                                              ? 'lib/assets/erekk.jpeg'
                                                              : 'lib/assets/default_avatar.png',
                                                    ),
                                            ),
                                            title: Text(d['ad'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(d['uzmanlik']),
                                                StreamBuilder<DocumentSnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser?.uid)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Text(
                                                          'Yaş: Belirtilmemiş');
                                                    }

                                                    final userData =
                                                        snapshot.data?.data()
                                                            as Map<String,
                                                                dynamic>?;
                                                    if (userData == null ||
                                                        userData['birthDate'] ==
                                                            null) {
                                                      return Text(
                                                          'Yaş: Belirtilmemiş');
                                                    }

                                                    final birthDate =
                                                        DateTime.parse(userData[
                                                            'birthDate']);
                                                    final age =
                                                        DateTime.now().year -
                                                            birthDate.year;
                                                    return Text('Yaş: $age');
                                                  },
                                                ),
                                              ],
                                            ),
                                            trailing:
                                                StreamBuilder<DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser?.uid)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return ElevatedButton(
                                                    onPressed: () async {
                                                      final user = FirebaseAuth
                                                          .instance.currentUser;
                                                      if (user == null) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  'Lütfen giriş yapın')),
                                                        );
                                                        return;
                                                      }

                                                      try {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(user.uid)
                                                            .update({
                                                          'dietitianId':
                                                              d['id'],
                                                          'subscriptionDate':
                                                              FieldValue
                                                                  .serverTimestamp(),
                                                        });

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  'Diyetisyene başarıyla üye oldunuz')),
                                                        );
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  'Üyelik işlemi sırasında bir hata oluştu: $e')),
                                                        );
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Color(0xFF58A399),
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 8),
                                                    ),
                                                    child: Text('Üye Ol'),
                                                  );
                                                }

                                                final userData = snapshot.data
                                                        ?.data()
                                                    as Map<String, dynamic>?;
                                                final isSubscribed =
                                                    userData?['dietitianId'] ==
                                                        d['id'];

                                                return ElevatedButton(
                                                  onPressed: () async {
                                                    final user = FirebaseAuth
                                                        .instance.currentUser;
                                                    if (user == null) return;

                                                    try {
                                                      if (isSubscribed) {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(user.uid)
                                                            .update({
                                                          'dietitianId':
                                                              FieldValue
                                                                  .delete(),
                                                          'subscriptionDate':
                                                              FieldValue
                                                                  .delete(),
                                                        });
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  'Üyelik iptal edildi')),
                                                        );
                                                      } else {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(user.uid)
                                                            .update({
                                                          'dietitianId':
                                                              d['id'],
                                                          'subscriptionDate':
                                                              FieldValue
                                                                  .serverTimestamp(),
                                                        });
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  'Diyetisyene başarıyla üye oldunuz')),
                                                        );
                                                      }
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'İşlem sırasında bir hata oluştu: $e')),
                                                      );
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        isSubscribed
                                                            ? Colors.red
                                                            : Color(0xFF58A399),
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 8),
                                                  ),
                                                  child: Text(isSubscribed
                                                      ? 'İptal Et'
                                                      : 'Üye Ol'),
                                                );
                                              },
                                            ),
                                            onTap: () => showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20)),
                                              ),
                                              builder: (_) =>
                                                  DiyetisyenDetaySheet(d: d),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Diyetisyenler()),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Color(0xFFA8D5BA),
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  child: const Text("Tümünü Gör"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Egzersiz Bölümü',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333)),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          PaketKart(
                            'SIRT VE BACAK EGZERSİZİ PROGARAMI',
                            '',
                            "lib/assets/fitnes1.jpg",
                            onTap: () => showExercisePopup(
                              context,
                              'Sırt ve Bacak Egzersizleri',
                              ["Deadlift", "Squat", "Leg Press", "Barbell Row"],
                            ),
                          ),
                          PaketKart(
                            'GÖĞÜS VE ÖN KOL PROGRAMI',
                            '',
                            "lib/assets/fitnes1.jpg",
                            onTap: () => showExercisePopup(
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
                            '',
                            "lib/assets/fitnes1.jpg",
                            onTap: () => showExercisePopup(
                              context,
                              "Omuz ve Arka Kol Programı",
                              [
                                "Shoulder Press",
                                "Lateral Raise",
                                "Triceps Dips"
                              ],
                            ),
                          ),
                          PaketKart(
                            'FULL BODY PROGRAM',
                            '',
                            "lib/assets/fitnes1.jpg",
                            onTap: () => showExercisePopup(
                              context,
                              "Full Body Egzersizleri",
                              ["Squats", "Push-ups", "Deadlifts", "Pull-ups"],
                            ),
                          ),
                          PaketKart(
                            "KARDİYO PROGRAMI",
                            "",
                            "lib/assets/fitnes1.jpg",
                            onTap: () => showExercisePopup(
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
        ],
      ),
    );
  }
}

class _AnasayfaState extends State<Anasayfa> {
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _tasks = {};
  TextEditingController _taskController = TextEditingController();
  int currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // static kaldırıldı, final kaldı
  late final List<Widget> _widgetOptions = <Widget>[
    // İşte yeni eklenen parametre ve değeri
    AnaSayfaIcerigi(
      selectedDay: _selectedDay,
      onDaySelected: (newSelectedDay, focusedDay) {
        setState(() {
          _selectedDay = newSelectedDay;
        });
      },
      taskController: _taskController,
      onAddTask: () {
        if (_taskController.text.isNotEmpty) {
          setState(() {
            if (_tasks[_selectedDay] == null) {
              _tasks[_selectedDay] = [];
            }
            _tasks[_selectedDay]!.add(_taskController.text);
            _taskController.clear();
          });
        }
      },
      onDeleteTask: (index) {
        setState(() {
          _tasks[_selectedDay]!.removeAt(index);
        });
      },
      getTasksForSelectedDay: (day) => _tasks[day] ?? [],
      showExercisePopup: _showExercisePopup,
    ),
    Diyetisyenim(),
    FeedPage(),
    YemekTarifleri(),
    Profile(),
  ];

  /// Belirtilen egzersiz adına göre ilgili GIF dosyasının yolunu döndürür.
  String _getGifPath(String hareketAdi) {
    final gifMap = {
      "Barbell Row": "barbellRow.gif",
      "Deadlift": "deadlift.gif",
      "Deadlifts": "deadlift.gif",
      "Squat": "squat.gif",
      "Squats": "squat.gif",
      "Leg Press": "legpress.gif",
      "Bench Press": "benchPress.gif",
      "Incline Dumbell Press": "inclinee.gif",
      "Biceps Curl": "bicepsCurl.gif",
      "Shoulder Press": "shoulderPress.gif",
      "Lateral Raise": "latereal.gif",
      "Triceps Dips": "dips.gif",
      "Push-ups": "pushUp.gif",
      "Pull-ups": "pullUps.gif",
      "Running": "running.gif",
      "Cycling": "cycling.gif",
      "Jumping Jacks": "jmp.gif",
      "Mountain Climbers": "mountain.gif",
    };

    // Eşleşen hareket varsa, dosya yolunu oluşturur, yoksa varsayılanı döner.
    final fileName = gifMap[hareketAdi] ?? "default.gif";
    return "lib/assets/gifs/$fileName";
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
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: const Text("TEBRİKLER! 🎉"),
                content: const Text("Tüm egzersizleri başarıyla tamamladın."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Kapat"),
                  ),
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
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (remainingSeconds == 10 && currentIndex == 0) {
              startTimer(setState);
            }

            String hareketAdi = hareketler[currentIndex];
            String gifPath = _getGifPath(hareketAdi);

            return Dialog(
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFA8D5BA).withOpacity(0.95),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30),
                    image: const DecorationImage(
                      image: AssetImage('assets/background_texture.png'),
                      fit: BoxFit.cover,
                      opacity: 0.08,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "$title\n(${currentIndex + 1}/${hareketler.length})",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        hareketAdi,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          gifPath,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "$remainingSeconds saniye",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          timer.cancel();
                          if (currentIndex < hareketler.length - 1) {
                            currentIndex++;
                            startTimer(setState);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        icon:
                            const Icon(Icons.skip_next, color: Colors.black87),
                        label: const Text(
                          "Sonraki Hareket",
                          style: TextStyle(color: Colors.black87),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(
                'DİYETİSYENLİK UYGULAMASI',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }

            final userData = snapshot.data?.data() as Map<String, dynamic>?;
            final userName =
                userData?['nameSurname'] ?? 'DİYETİSYENLİK UYGULAMASI';

            return Text(
              userName,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          },
        ),
        backgroundColor: const Color(0xFFA8D5BA),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Color(0xFFF8FAF9),
        indicatorColor: Color(0xFF58A399),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.home_outlined,
              size: 30,
            ),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.assignment_ind_rounded,
              size: 30,
              color: Colors.white,
            ),
            icon: Badge(
              child: Icon(
                Icons.assignment_ind_outlined,
                size: 30,
              ),
            ),
            label: 'Diyetisyenim',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.messenger,
              size: 25,
              color: Colors.white,
            ),
            icon: Icon(Icons.messenger_outline, size: 25),
            label: 'GÜndem',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.food_bank,
              color: Colors.white,
              size: 35,
            ),
            label: "Yemek",
            icon: Icon(
              Icons.food_bank_outlined,
              size: 35,
            ),
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.account_box,
              size: 30,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.account_box_outlined,
              size: 30,
            ),
            label: 'Profilim',
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(currentPageIndex),
      ),
    );
  }
}

/// 📌 DİYETİSYEN KARTI  ────────────────────────────────────────────────
class DiyetisyenKart extends StatelessWidget {
  final Map<String, dynamic> d;

  const DiyetisyenKart({super.key, required this.d});

  Future<void> _subscribeToDietitian(
      BuildContext context, String dietitianId) async {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (_) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.75,
            maxChildSize: 0.95,
            minChildSize: 0.5,
            builder: (_, controller) =>
                _diyetisyenDetay(context, d, controller),
          ),
        );
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 2,
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: d['image'] != null
                      ? NetworkImage(d['image']) as ImageProvider
                      : AssetImage(
                          d['gender'] == 'female'
                              ? 'lib/assets/kadin.png'
                              : d['gender'] == 'male'
                                  ? 'lib/assets/erekk.jpeg'
                                  : 'lib/assets/default_avatar.png',
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black.withOpacity(0.45),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d['isim'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        d['uzmanlik'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () =>
                            _subscribeToDietitian(context, d['id']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue[700],
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        ),
                        child: Text('Üye Ol'),
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

/// 📌 DİYETİSYEN DETAY BOTTOM-SHEET  ───────────────────────────────────
Widget _diyetisyenDetay(
    BuildContext context, Map<String, dynamic> d, ScrollController c) {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _subscribeToDietitian(
      BuildContext context, String dietitianId) async {
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

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) selectedDate = picked;
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) selectedTime = picked;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: ListView(
      controller: c,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            d['isim'],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 6),
        Center(child: Text("Uzmanlık: ${d['uzmanlik']}")),
        const Divider(height: 32),
        const Text("📄 Detaylı Biyografi",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(d['biyografi']),
        const SizedBox(height: 18),
        const Text("🏷️ Hizmet Verdiği Alanlar",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        ...List<Widget>.from(
            d['alanlar'].map<Widget>((a) => Text("• $a")).toList()),
        const SizedBox(height: 18),
        const Text("📱 İletişim",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text("Instagram: ${d['iletisim']['instagram']}"),
        Text("Mail: ${d['iletisim']['mail']}"),
        Text("Telefon: ${d['iletisim']['telefon']}"),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => _subscribeToDietitian(context, d['id']),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF58A399),
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            "Diyetisyene Üye Ol",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Kapat",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}

class AdimSayarWidget extends StatefulWidget {
  const AdimSayarWidget({super.key});

  @override
  State<AdimSayarWidget> createState() => _AdimSayarWidgetState();
}

class _AdimSayarWidgetState extends State<AdimSayarWidget> {
  final stepService = StepCounterService();
  StreamSubscription<StepCount>? _subscription;
  final int hedefAdim = 6000;

  @override
  void initState() {
    super.initState();
    _initStepCountStream();
  }

  Future<void> _initStepCountStream() async {
    var status = await Permission.activityRecognition.request();

    if (status.isGranted) {
      _subscription = stepService.stepStream.listen(
        (event) {
          setState(() {
            stepService.update(event);
          });
        },
        onError: (error) => print("Adım sayar hatası: $error"),
      );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int adim = 2000;
    int kalan = (hedefAdim - adim).clamp(0, hedefAdim);
    double percent = (adim / hedefAdim).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 12.0,
            animation: true,
            animationDuration: 900,
            percent: percent,
            circularStrokeCap: CircularStrokeCap.round,
            linearGradient: const LinearGradient(
              colors: [Color.fromARGB(255, 0, 143, 200), Color(0xFFB2FF59)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            backgroundColor: Colors.grey.shade200,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$adim",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const Text(
                  "Adım",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Günlük Adım Hedefi",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Hedef: $hedefAdim adım",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  "Kalan: $kalan adım",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StepCounterService {
  static final StepCounterService _instance = StepCounterService._internal();
  factory StepCounterService() => _instance;
  StepCounterService._internal();

  Stream<StepCount>? _stepStream;
  StepCount? _latestStep;
  int? initialSteps;
  int currentSteps = 0;

  Stream<StepCount> get stepStream {
    _stepStream ??= Pedometer.stepCountStream.asBroadcastStream(
      onListen: (subscription) => print("Adım stream başladı"),
      onCancel: (subscription) => print("Adım stream iptal edildi"),
    );
    return _stepStream!;
  }

  void update(StepCount event) {
    _latestStep = event;
    if (initialSteps == null) {
      initialSteps = event.steps;
    }
    currentSteps = event.steps - initialSteps!;
  }
}

class KaloriTakipWidget extends StatefulWidget {
  const KaloriTakipWidget({super.key});

  @override
  State<KaloriTakipWidget> createState() => _KaloriTakipWidgetState();
}

class _KaloriTakipWidgetState extends State<KaloriTakipWidget> {
  final int hedefKalori = 2500;
  int alinankalori = 500;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCalories();
  }

  Future<void> loadCalories() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      alinankalori = prefs.getInt('alinan_kalori') ?? 0;
    });
  }

  Future<void> saveCalories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('alinan_kalori', alinankalori);
  }

  void kaloriEkle() {
    final girilenDeger = int.tryParse(_controller.text);
    if (girilenDeger != null) {
      setState(() {
        alinankalori += girilenDeger;
        if (alinankalori > hedefKalori) {
          alinankalori = hedefKalori;
        }
      });
      saveCalories();
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final kalanKalori = hedefKalori - alinankalori;
    final yuzde = (alinankalori / hedefKalori).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 75.0,
              lineWidth: 14.0,
              animation: true,
              animationDuration: 1500,
              percent: yuzde,
              circularStrokeCap: CircularStrokeCap.round,
              linearGradient: const LinearGradient(
                colors: [Color(0xFF00C853), Color(0xFFB2FF59)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              backgroundColor: Colors.grey.shade200,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$alinankalori",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  const Text(
                    "Kcal",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Günlük Kalori Alımı",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Hedef: $hedefKalori Kcal",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    "Kalan: ${kalanKalori < 0 ? 0 : kalanKalori} Kcal",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Kalori ekle',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: kaloriEkle,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00C853), Color(0xFFB2FF59)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Nasıl Yardımcı Olabilirim",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'lib/assets/image.png',
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void _showAppointmentDialog(BuildContext context, DateTime selectedDate) {
  final TextEditingController timeController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Randevu Al'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Tarih: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
          SizedBox(height: 16),
          TextField(
            controller: timeController,
            decoration: InputDecoration(
              labelText: 'Saat (HH:mm)',
              hintText: 'Örn: 14:30',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: noteController,
            decoration: InputDecoration(
              labelText: 'Not',
              hintText: 'Randevu notu ekleyin',
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (timeController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lütfen saat girin')),
              );
              return;
            }

            try {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lütfen giriş yapın')),
                );
                return;
              }

              // Diyetisyen bilgilerini al
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();

              final dietitianId = userDoc.data()?['dietitianId'];
              if (dietitianId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Önce bir diyetisyene üye olmalısınız')),
                );
                return;
              }

              final dietitianDoc = await FirebaseFirestore.instance
                  .collection('dietitians')
                  .doc(dietitianId)
                  .get();

              if (!dietitianDoc.exists) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Diyetisyen bilgileri bulunamadı')),
                );
                return;
              }

              // Randevu saatini kontrol et
              final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
              if (!timeRegex.hasMatch(timeController.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Lütfen geçerli bir saat girin (HH:mm)')),
                );
                return;
              }

              // Aynı gün ve saatte randevu var mı kontrol et
              final existingAppointments = await FirebaseFirestore.instance
                  .collection('appointments')
                  .where('dietitianId', isEqualTo: dietitianId)
                  .where('date', isEqualTo: Timestamp.fromDate(selectedDate))
                  .where('time', isEqualTo: timeController.text)
                  .get();

              if (existingAppointments.docs.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Bu saatte başka bir randevu bulunmaktadır')),
                );
                return;
              }

              // Randevuyu kaydet
              await FirebaseFirestore.instance.collection('appointments').add({
                'userId': user.uid,
                'userName':
                    userDoc.data()?['nameSurname'] ?? 'İsimsiz Kullanıcı',
                'dietitianId': dietitianId,
                'dietitianName':
                    dietitianDoc.data()?['nameSurname'] ?? 'İsimsiz Diyetisyen',
                'date': Timestamp.fromDate(selectedDate),
                'time': timeController.text,
                'note': noteController.text,
                'status': 'pending',
                'createdAt': FieldValue.serverTimestamp(),
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Randevu başarıyla oluşturuldu')),
              );
            } catch (e) {
              print(
                  'Randevu oluşturma hatası: $e'); // Hata detayını konsola yazdır
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Randevu oluşturulurken bir hata oluştu. Lütfen tekrar deneyin.')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF58A399),
            foregroundColor: Colors.white,
          ),
          child: Text('Randevu Al'),
        ),
      ],
    ),
  );
}
