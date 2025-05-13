import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Diyetisyenler extends StatefulWidget {
  @override
  _DiyetisyenlerState createState() => _DiyetisyenlerState();
}

class _DiyetisyenlerState extends State<Diyetisyenler> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _filteredDiyetisyenler = [];
  late Stream<QuerySnapshot> _dietitianStream;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_filterDiyetisyenler);
    _dietitianStream =
        FirebaseFirestore.instance.collection('dietitians').snapshots();
  }

  void _filterDiyetisyenler() {
    String searchQuery = _controller.text.trim().toLowerCase();
    setState(() {
      _filteredDiyetisyenler = _filteredDiyetisyenler
          .where((diyetisyen) =>
              diyetisyen['ad'].toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DİYETİSYENLER"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.black38, fontSize: 20),
                    decoration: InputDecoration(
                      hintText: 'Diyetisyen adı ara...',
                      hintStyle:
                          TextStyle(color: const Color.fromARGB(255, 6, 5, 0)),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _dietitianStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Bir hata oluştu'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text(
                                'Henüz kayıtlı diyetisyen bulunmamaktadır'));
                      }

                      // Verileri işleyip filtrelemek
                      var dietitians = snapshot.data!.docs.map((doc) {
                        var data = doc.data() as Map<String, dynamic>;
                        return {
                          'id': doc.id,
                          'ad': data['nameSurname'] ?? 'Diyetisyen Adı',
                          'uzmanlik':
                              data['expertise'] ?? 'Klinik Beslenme Uzmanı',
                          'resim': 'lib/assets/kadin.png',
                          'biyografi': data['biography'] ??
                              'Biyografi bilgisi bulunmamaktadır.',
                          'iletisim': {
                            'instagram': data['instagram'] ?? '@diyetisyen',
                            'mail': data['email'] ?? 'Email bilgisi yok',
                            'telefon': data['phone'] ?? '+90 555 555 5555',
                          }
                        };
                      }).toList();

                      // Filtreleme işlemi
                      if (_controller.text.isNotEmpty) {
                        dietitians = dietitians.where((diyetisyen) {
                          return diyetisyen['ad']
                              .toLowerCase()
                              .contains(_controller.text.toLowerCase());
                        }).toList();
                      }

                      return ListView.builder(
                        itemCount: dietitians.length,
                        itemBuilder: (context, index) {
                          final d = dietitians[index];
                          return Card(
                            color: Colors.white,
                            shadowColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 4,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(12),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(d['resim']),
                                radius: 32,
                              ),
                              title: Text(d['ad'],
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(d['uzmanlik']),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (_) => DiyetisyenDetaySheet(d: d),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DiyetisyenDetaySheet extends StatefulWidget {
  final Map<String, dynamic> d;

  const DiyetisyenDetaySheet({Key? key, required this.d}) : super(key: key);

  @override
  _DiyetisyenDetaySheetState createState() => _DiyetisyenDetaySheetState();
}

class _DiyetisyenDetaySheetState extends State<DiyetisyenDetaySheet> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _lastAppointmnetSummary;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final iletisim = widget.d['iletisim'] as Map<String, dynamic>;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          controller: controller,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(widget.d['resim']),
            ),
            SizedBox(height: 16),
            Text(
              widget.d['ad'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              widget.d['uzmanlik'],
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Text(
              'Biyografi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(widget.d['biyografi']),
            SizedBox(height: 24),
            Text(
              'İletişim Bilgileri',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Instagram: ${iletisim['instagram']}"),
            Text("Email: ${iletisim['mail']}"),
            Text("Telefon: ${iletisim['telefon']}"),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await _selectDate(context);
                await _selectTime(context);
                if (_selectedDate != null && _selectedTime != null) {
                  final dateStr =
                      DateFormat('dd.MM.yyyy').format(_selectedDate!);
                  final timeStr = _selectedTime!.format(context);
                  try {
                    await FirebaseFirestore.instance
                        .collection('appointments')
                        .add({
                      'dietitianId': widget.d['id'],
                      'dietitianName': widget.d['ad'],
                      'date': _selectedDate!.toIso8601String(),
                      'time': '${_selectedTime!.hour}:${_selectedTime!.minute}',
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                    String dateStr =
                        "${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}";
                    String timeStr =
                        "${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}";

                    setState(() {
                      _lastAppointmnetSummary =
                          "Randevunuz $dateStr $timeStr olarak kaydedildi 🎉";
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(_lastAppointmnetSummary!),
                    ));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Randevu kaydedilirken bir hata oluştu: $e'),
                    ));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 190, 128, 105),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text('Randevu Al'),
            ),
          ],
        ),
      ),
    );
  }
}
