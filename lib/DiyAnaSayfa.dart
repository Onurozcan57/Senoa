import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Diyanasayfa extends StatefulWidget {
  const Diyanasayfa({super.key});

  @override
  State<Diyanasayfa> createState() => _DiyanasayfaState();
}

class _DiyanasayfaState extends State<Diyanasayfa> {
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _tasks = {};
  TextEditingController _taskController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // scaffold key tanımlandı

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // scaffold key buraya eklenmeli
      appBar: AppBar(
        title: Text("Onur Özcan"),
        backgroundColor: Color(0xFF34C759),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Hamburger menü butonuna basıldığında Drawer'ı açar
            _scaffoldKey.currentState?.openDrawer(); // Drawer'ı açma işlemi
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF34C759),
              ),
              child: Text(
                'Menü',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text("Profil"),
              onTap: () => null, // bu çalışacak
            ),
            ListTile(
              leading: Icon(Icons.access_alarm), // Ikon sol tarafta olacak
              title: Text("Randevularım"), // Metin, başlık olarak eklenir
              onTap: () {
                // Ana sayfaya gitme işlemi veya başka bir işlem yapılabilir
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Çıkış"),
              onTap: () {
                // Çıkış işlemi
              },
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
          ],
        ),
      ),
    );
  }
}
