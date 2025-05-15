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
                      color: Color(0xFF58A399),
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

      // 3. "GÜndem" için FeedPage widget'ı
      FeedPage(),
      // 4. "Yemek" için YemekTarifleri widget'ı
      YemekTarifleri(),
      DiyProfile(),
      Container(
        // Aynı body içeriğini buraya da ekledim

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
                      color: Color(0xFFA8D5BA),
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
                height: 50,
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
          backgroundColor: Color(0xFFA8D5BA),
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

  final TextEditingController _breakfastController = TextEditingController();
  final TextEditingController _lunchController = TextEditingController();
  final TextEditingController _dinnerController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: const Color(0xFFA8D5BA), // Arka plan
      contentPadding: const EdgeInsets.all(20),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Hasta Bilgileri",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58A399),
                ),
              ),
            ),
            SizedBox(height: 20),
            _infoRow("İsim ve Soyisim:", nameSurname),
            _infoRow("Yaş:", age),
            _infoRow("Boy:", "$height cm"),
            _infoRow("Kilo:", "$weight kg"),
            _infoRow("Vücut Kitle Endeksi:", bmiResult),
            SizedBox(height: 20),
            Divider(thickness: 1.2, color: Color(0xFF58A399)),
            SizedBox(height: 10),
            Text("Diyet Listesi", style: _sectionTitleStyle),
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
                ElevatedButton.icon(
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
                  icon: Icon(Icons.check),
                  label: Text("Gönder"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF58A399),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Kapat"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(child: Text(label, style: _popupLabelStyle)),
        Expanded(child: Text(value, style: _popupValueStyle)),
      ],
    ),
  );
}

Widget _buildTextField(String label, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF58A399)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF58A399), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    maxLines: 2,
  );
}

final _popupLabelStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 15,
  color: Colors.black87,
);

final _popupValueStyle = TextStyle(
  fontSize: 15,
  color: Colors.black54,
);

final _sectionTitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Color(0xFF58A399),
);
