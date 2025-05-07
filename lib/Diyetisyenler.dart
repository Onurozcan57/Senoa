import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Diyetisyenler extends StatefulWidget {
  @override
  _DiyetisyenlerState createState() => _DiyetisyenlerState();
}

class _DiyetisyenlerState extends State<Diyetisyenler> {
  final List<Map<String, dynamic>> diyetisyenler = [
    {
      'ad': 'Dyt. Ayşe Sümeyra Keskin',
      'uzmanlik': 'Kilo Kontrolü',
      'resim': 'lib/assets/kadin.png',
      'biyografi':
          '2015’te Hacettepe Üniversitesi’nden mezun oldu. 8 yıldır bireysel danışmanlık yapıyor.',
      'alanlar': ['Kilo verme', 'Gebelikte beslenme', 'Diyabet beslenmesi'],
      'randevu': 'Hafta içi: 09:00 - 17:00\nCumartesi: 10:00 - 14:00',
      'iletisim': {
        'instagram': '@sumeyradiyet',
        'mail': 'sumeyra@example.com',
        'telefon': '+90 534 000 00 00',
      }
    },
    {
      'ad': 'Dyt. Nisanur Irmak Şakar',
      'uzmanlik': 'Sporcu Beslenmesi',
      'resim': 'lib/assets/kadin.png',
      'biyografi': 'Sporcu beslenmesi ve performans artışı alanında uzmandır.',
      'alanlar': [
        'Sporcu beslenmesi',
        'Kas geliştirme',
        'Protein takviyesi yönetimi'
      ],
      'randevu': 'Hafta içi: 11:00 - 18:00',
      'iletisim': {
        'instagram': '@dyt.irmak',
        'mail': 'irmak@example.com',
        'telefon': '+90 555 123 45 67',
      }
    },
    {
      'ad': 'Dyt. Helin Özalkan',
      'uzmanlik': 'Kilo Kontrolü',
      'resim': 'lib/assets/kadin.png',
      'biyografi':
          '2019 da Koç Üniversitesinden mezun oldu. 4 yıldır bireysel danışmanlık yapıyor',
      'alanlar': ['Kilo verme', 'Kilo alma', 'Çocuk beslenmesi'],
      'randevu': 'Hafta içi: 11:00 - 18:00',
      'iletisim': {
        'instagram': '@dyt.ozalkan',
        'mail': 'ozalkan@example.com',
        'telefon': '+90 555 000 44 67',
      }
    },
    {
      'ad': 'Dyt. Onur Özcan',
      'uzmanlik': 'Sporcu Beslenmesi',
      'resim': 'lib/assets/erekk.jpeg',
      'biyografi':
          '2018 de Sabancıdan mezun oldu. Galatasaray kulubünde futbolculara özel danışmanlık yaptı',
      'alanlar': ['Kas Geliştirme', 'Sporcu beslenmesi', 'Protein Takviyesi'],
      'randevu': 'Hafta içi: 09:00 - 18:00',
      'iletisim': {
        'instagram': '@dyt.ozcan',
        'mail': 'ozcan@example.com',
        'telefon': '+90 555 001 24 67',
      }
    },
    {
      'ad': 'Dyt. Abdurrahman Gökçen',
      'uzmanlik': 'Kilo Kontrolü',
      'resim': 'lib/assets/erekk.jpeg',
      'biyografi':
          '2018 de Özyeğinden mezun oldu.  3  yıldır kişiye özel danışmanlık yapıyor',
      'alanlar': ['Kilo verme', 'Kilo alma', 'Karbonhidrat Takviyesi'],
      'randevu': 'Hafta içi: 12:00 - 18:00',
      'iletisim': {
        'instagram': '@dyt.gokcen',
        'mail': 'gokcen@example.com',
        'telefon': '+90 554 101 24 68',
      }
    }
  ];

  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _filteredDiyetisyenler = [];
  String _selectedUzmanlik = 'Tümü';

  @override
  void initState() {
    super.initState();
    _filteredDiyetisyenler = diyetisyenler;
    _controller.addListener(_filterDiyetisyenler);
  }

  void _filterDiyetisyenler() {
    setState(() {
      _filteredDiyetisyenler = diyetisyenler.where((d) {
        final isimUyumlu =
            d['ad']!.toLowerCase().contains(_controller.text.toLowerCase());
        final uzmanlikUyumlu =
            _selectedUzmanlik == 'Tümü' || d['uzmanlik'] == _selectedUzmanlik;
        return isimUyumlu && uzmanlikUyumlu;
      }).toList();
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
        backgroundColor: const Color.fromARGB(255, 190, 128, 105),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/girisekrani.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.22),
            child: Column(
              children: [
                // Arama Çubuğu
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
                // Dropdown Menüsü
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black38, width: 2), // Kenarlık
                      borderRadius:
                          BorderRadius.circular(8), // Kenarları yuvarlatma
                    ),
                    child: DropdownButton<String>(
                      value: _selectedUzmanlik,
                      isExpanded: true,
                      items: ['Tümü', 'Kilo Kontrolü', 'Sporcu Beslenmesi']
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUzmanlik = value!;
                          _filterDiyetisyenler();
                        });
                      },
                      icon: Icon(Icons.arrow_drop_down,
                          color: Colors.black), // Ok simgesinin rengi
                      style: TextStyle(
                          color: Colors.black, fontSize: 16), // Yazı rengi
                      dropdownColor:
                          Colors.white, // Dropdown menüsünün arka plan rengi
                      underline: Container(), // Alt çizgiyi kaldırdık
                    ),
                  ),
                ),

                // Liste
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredDiyetisyenler.length,
                    itemBuilder: (context, index) {
                      final d = _filteredDiyetisyenler[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(d['resim']),
                            radius: 32,
                          ),
                          title: Text(d['ad'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(d['uzmanlik']),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: (_) => _diyetisyenDetay(context, d),
                          ),
                        ),
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

  Widget _diyetisyenDetay(BuildContext context, Map<String, dynamic> d) {
    final iletisim = d['iletisim'] as Map<String, dynamic>;
    DateTime? _selectedDate; // Randevu tarihi değişkeni
    TimeOfDay? _selectedTime; // Randevu saati değişkeni

    // Takvim seçici fonksiyonu
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), // Başlangıç tarihi
        firstDate: DateTime(2000), // Seçilebilecek en erken tarih
        lastDate: DateTime(2101), // Seçilebilecek en geç tarih
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
      }
    }

    // Saat seçici fonksiyonu
    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(), // Başlangıç saati
      );
      if (picked != null && picked != _selectedTime) {
        setState(() {
          _selectedTime = picked;
        });
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                d['ad'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Center(child: Text("Uzmanlık: ${d['uzmanlik']}")),
            Divider(height: 30),
            Text("📄 Detaylı Biyografi",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(d['biyografi']),
            SizedBox(height: 15),
            Text("🏷️ Hizmet Verdiği Alanlar",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            ...List<Widget>.from(d['alanlar'].map<Widget>((a) => Text("- $a"))),
            SizedBox(height: 15),
            Text("⏰ Randevu Saatleri",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(d['randevu']),
            SizedBox(height: 15),
            Text("📱 Sosyal Medya / İletişim",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Column(
              children: [
                Text("Instagram: ${iletisim['instagram']}"),
                Text("Mail: ${iletisim['mail']}"),
                Text("Telefon: ${iletisim['telefon']}"),
              ],
            ),
            SizedBox(height: 20),

            // Takvim Seçici butonu
            Text(
              _selectedDate == null
                  ? 'Randevu tarihi seçilmedi'
                  : 'Seçilen Tarih: ${_selectedDate!.toLocal()}'.split(' ')[0],
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text("Randevu Tarihini Seç"),
            ),

            SizedBox(height: 20),

            // Saat Seçici butonu
            Text(
              _selectedTime == null
                  ? 'Randevu saati seçilmedi'
                  : 'Seçilen Saat: ${_selectedTime!.format(context)}',
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text("Randevu Saatini Seç"),
            ),

            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_selectedDate != null && _selectedTime != null) {
                    final formattedDate =
                        DateFormat('dd.MM.yyyy').format(_selectedDate!);
                    final formattedTime = _selectedTime!.format(context);

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Randevunuz $formattedDate tarihinde saat $formattedTime alındı 🎉'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lütfen tarih ve saat seçin!')),
                    );
                  }
                },
                icon: Icon(Icons.event_available),
                label: Text("Randevu Al"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange),
              ),
            )
          ],
        ),
      ),
    );
  }
}
