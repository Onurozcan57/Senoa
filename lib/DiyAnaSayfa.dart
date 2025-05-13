import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:senoa/FeedPage.dart';
import 'package:senoa/YemekTarifleri.dart';
import 'package:senoa/DiyProfile.dart';

class Diyanasayfa extends StatefulWidget {
  const Diyanasayfa({super.key});

  @override
  State<Diyanasayfa> createState() => _DiyanasayfaState();
}

class _DiyanasayfaState extends State<Diyanasayfa> {
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _tasks = {};
  int currentPageIndex = 0;
  TextEditingController _taskController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _widgetOptions = <Widget>[
    // Elemanlar buraya eklenecek
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      // 1. "Ana Sayfa" için mevcut ana sayfa içeriğiniz
      Container(
        // Mevcut body içeriğiniz Container ile başlıyordu, onu buraya taşıdım
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "lib/assets/girisekrani.jpg"), // Arkaplan resmi ekleniyor
              fit: BoxFit.cover,
              opacity: 0.06),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskController,
                        decoration: InputDecoration(
                          labelText: "Randevu Ekle",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
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
                height: 100,
                child: _tasks[_selectedDay] == null ||
                        _tasks[_selectedDay]!.isEmpty
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
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Patients(
                      nameSurname: "Onur Özcan",
                      age: "20",
                      height: 177,
                      weight: 120)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Patients(
                    nameSurname: "Abdurrahman Gökçen",
                    age: "22",
                    height: 182,
                    weight: 75),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Patients(
                    nameSurname: "Ayşe Sümeyra Kesim",
                    age: "18",
                    height: 167,
                    weight: 60),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Patients(
                    nameSurname: "Emre İleri",
                    age: "21",
                    height: 182,
                    weight: 80),
              ),
              SizedBox(
                height: 0,
              )
            ],
          ),
        ),
      ),
      //profile butonun çalışması için yeri değişmesin bunun lütfen
      DiyProfile(),

      // 3. "GÜndem" için FeedPage widget'ı
      FeedPage(),
      // 4. "Yemek" için YemekTarifleri widget'ı
      YemekTarifleri(),
      Container(
        // Aynı body içeriğini buraya da ekledim
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "lib/assets/girisekrani.jpg"), // Arkaplan resmi ekleniyor
              fit: BoxFit.cover,
              opacity: 0.06),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskController,
                        decoration: InputDecoration(
                          labelText: "Randevu Ekle",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
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
                height: 100,
                child: _tasks[_selectedDay] == null ||
                        _tasks[_selectedDay]!.isEmpty
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
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Patients(
                      nameSurname: "Onur Özcan",
                      age: "20",
                      height: 177,
                      weight: 120)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Patients(
                    nameSurname: "Abdurrahman Gökçen",
                    age: "22",
                    height: 182,
                    weight: 75),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Patients(
                    nameSurname: "Ayşe Sümeyra Kesim",
                    age: "18",
                    height: 167,
                    weight: 60),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Patients(
                    nameSurname: "Emre İleri",
                    age: "21",
                    height: 182,
                    weight: 80),
              ),
              SizedBox(
                height: 0,
              )
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Nisanur Şakar"),
          backgroundColor: Color(0xFFF6F4FB),
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          backgroundColor: Color(0xFFF6F4FB),
          indicatorColor: Color(0xFFD69C6C),
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
          ],
        ),
        body: _widgetOptions.elementAt(currentPageIndex));
  }
}

class Patients extends StatelessWidget {
  final String nameSurname;
  final String age;
  final int weight;
  final int height;

  Patients(
      {required this.nameSurname,
      required this.age,
      required this.height,
      required this.weight});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        onTap: () {
          _showPopup(
            context,
            nameSurname,
            age,
            height,
            weight,
          );
        },
        title: Text(
          nameSurname,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
        ),
        subtitle: Text(
          age,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        leading: Icon(
          Icons.accessibility_sharp,
          color: Color(0xFFD69C6C),
          size: 40,
        ),
      ),
    );
  }
}

void _showPopup(
  BuildContext context,
  String nameSurname,
  String age,
  int height,
  int weight,
) {
  double bmi = weight / ((height / 100) * (height / 100));
  String bmiResult = bmi.toStringAsFixed(1);

  // Diyet kontrolcüleri
  final TextEditingController _breakfastController = TextEditingController();
  final TextEditingController _lunchController = TextEditingController();
  final TextEditingController _dinnerController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: const EdgeInsets.all(25),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        // Taşmayı önler
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bilgiler
            Text("İsim ve Soyisim:", style: _popupLabelStyle),
            Text(nameSurname, style: _popupValueStyle),
            SizedBox(height: 10),
            Text("Yaş:", style: _popupLabelStyle),
            Text(age, style: _popupValueStyle),
            SizedBox(height: 10),
            Text("Boy:", style: _popupLabelStyle),
            Text("$height cm", style: _popupValueStyle),
            SizedBox(height: 10),
            Text("Kilo:", style: _popupLabelStyle),
            Text("$weight kg", style: _popupValueStyle),
            SizedBox(height: 10),
            Text("Vücut Kitle Endeksi:", style: _popupLabelStyle),
            Text(bmiResult, style: _popupValueStyle),

            SizedBox(height: 20),
            Divider(),

            // Diyet Giriş Alanları
            Text("Diyet Listesi Hazırla", style: _popupLabelStyle),
            SizedBox(height: 10),
            _buildTextField("Sabah Öğünü", _breakfastController),
            SizedBox(height: 10),
            _buildTextField("Öğle Öğünü", _lunchController),
            SizedBox(height: 10),
            _buildTextField("Akşam Öğünü", _dinnerController),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    final sabah = _breakfastController.text;
                    final ogle = _lunchController.text;
                    final aksam = _dinnerController.text;

                    print("Sabah: $sabah");
                    print("Öğle: $ogle");
                    print("Akşam: $aksam");

                    Navigator.pop(
                      context,
                      {
                        'kahvalti': sabah,
                        'ogle': ogle,
                        'aksam': aksam,
                      },
                    );
                  },
                  child: Text("Listeyi Gönder"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
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

Widget _buildTextField(String label, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    ),
    maxLines: 2,
  );
}

final _popupLabelStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16,
  color: Colors.black54,
);

final _popupValueStyle = TextStyle(
  fontSize: 16,
  color: Colors.black87,
);
