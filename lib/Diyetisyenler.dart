import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Appointment {
  final String id;
  final String userId;
  final String dietitianId;
  final DateTime date;
  final TimeOfDay time;
  final String status;
  final String notes;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.dietitianId,
    required this.date,
    required this.time,
    required this.status,
    required this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'dietitianId': dietitianId,
      'date': date,
      'time': '${time.hour}:${time.minute}',
      'status': status,
      'notes': notes,
      'createdAt': createdAt,
    };
  }
}

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
        title: Text(
          "DİYETİSYENLER",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFF58A399),
        centerTitle: true,
        elevation: 4,
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
                          'resim': data['image'] ??
                              'lib/assets/default_dietitian.png',
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
                              title: Text(d['ad'],
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(d['uzmanlik']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return ElevatedButton(
                                          onPressed: () async {
                                            final user = FirebaseAuth
                                                .instance.currentUser;
                                            if (user == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Lütfen giriş yapın')),
                                              );
                                              return;
                                            }

                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(user.uid)
                                                  .update({
                                                'dietitianId': d['id'],
                                                'subscriptionDate': FieldValue
                                                    .serverTimestamp(),
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Diyetisyene başarıyla üye oldunuz')),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Üyelik işlemi sırasında bir hata oluştu: $e')),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF58A399),
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                          ),
                                          child: Text('Üye Ol'),
                                        );
                                      }

                                      final userData = snapshot.data?.data()
                                          as Map<String, dynamic>?;
                                      final isSubscribed =
                                          userData?['dietitianId'] == d['id'];

                                      return ElevatedButton(
                                        onPressed: () async {
                                          final user =
                                              FirebaseAuth.instance.currentUser;
                                          if (user == null) return;

                                          try {
                                            if (isSubscribed) {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(user.uid)
                                                  .update({
                                                'dietitianId':
                                                    FieldValue.delete(),
                                                'subscriptionDate':
                                                    FieldValue.delete(),
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Üyelik iptal edildi')),
                                              );
                                            } else {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(user.uid)
                                                  .update({
                                                'dietitianId': d['id'],
                                                'subscriptionDate': FieldValue
                                                    .serverTimestamp(),
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Diyetisyene başarıyla üye oldunuz')),
                                              );
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'İşlem sırasında bir hata oluştu: $e')),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isSubscribed
                                              ? Colors.red
                                              : Color(0xFF58A399),
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                        ),
                                        child: Text(isSubscribed
                                            ? 'İptal Et'
                                            : 'Üye Ol'),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_ios),
                                ],
                              ),
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
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF58A399),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF58A399),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _bookAppointment() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tarih ve saat seçin')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Kullanıcı girişi yapılmamış');
      }

      // Randevu oluştur
      final appointment = Appointment(
        id: '',
        userId: user.uid,
        dietitianId: widget.d['id'],
        date: _selectedDate!,
        time: _selectedTime!,
        status: 'pending',
        notes: _notesController.text,
        createdAt: DateTime.now(),
      );

      // Firestore'a kaydet
      await FirebaseFirestore.instance
          .collection('appointments')
          .add(appointment.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Randevu talebiniz alındı')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Randevu alınamadı: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
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
              backgroundImage: AssetImage(
                  widget.d['resim'] ?? 'lib/assets/default_dietitian.png'),
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
            ListTile(
              leading: Icon(Icons.email),
              title: Text(iletisim['mail']),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(iletisim['telefon']),
            ),
            SizedBox(height: 24),
            Text(
              'Randevu Al',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _selectDate(context),
              icon: Icon(Icons.calendar_today),
              label: Text(_selectedDate == null
                  ? 'Tarih Seçin'
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF58A399),
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _selectTime(context),
              icon: Icon(Icons.access_time),
              label: Text(_selectedTime == null
                  ? 'Saat Seçin'
                  : '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF58A399),
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notlar (İsteğe bağlı)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _bookAppointment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF58A399),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Randevu Al'),
            ),
          ],
        ),
      ),
    );
  }
}
