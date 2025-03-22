import 'package:flutter/material.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  // Başlangıçta seçili kart yok
  int _seciliKart = -1;

  // Paket kartı oluşturmak için bir widget fonksiyonu
  Widget PaketKart(String baslik, String aciklama, Color renk, int index) {
    return GestureDetector(
      onTap: () {
        // Kart seçildiğinde setState ile güncellenir
        setState(() {
          _seciliKart = index; // Seçili kartın index numarasını güncelle
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300), // Animasyon süresi
        width: _seciliKart == index ? 250 : 200, // Seçilen kart genişler
        height: _seciliKart == index ? 270 : 200, // Seçilen kart büyür
        margin: EdgeInsets.all(10), // Kartlar arasındaki mesafe
        decoration: BoxDecoration(
          color: renk.withOpacity(0.2), // Kart rengi, renk şeffaflık eklenmiş
          borderRadius: BorderRadius.circular(15), // Kart köşe yuvarlama
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Gölge rengi
              blurRadius: 8, // Gölgenin bulanıklık etkisi
              spreadRadius: 2, // Gölgenin yayılma mesafesi
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // İçeriği ortalamak
          children: [
            Text(
              baslik, // Başlık kısmı
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10), // Başlık ile açıklama arasındaki boşluk
            Text(aciklama, textAlign: TextAlign.center), // Açıklama kısmı
            SizedBox(height: 20), // Açıklama ile buton arasındaki boşluk
            /* ElevatedButton(
              onPressed: () {
                // Butona tıklandığında bir şey yapılacaksa burası kullanılır
                print('$baslik seçildi'); // Seçilen kart başlığını konsola yazdır
              },
              child: Text('Seç'), // Butonun yazısı
            ),*/
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diyetisyenlik Uygulaması'), // Uygulama başlığı
        backgroundColor: Color(0xFF34C759), // Canlı yeşil arka plan
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // Menünün sıfırlanmış padding değeri
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green, // Drawer başlık rengi
              ),
              child: Text(
                'Menü Başlığı', // Menü başlığı
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24, // Menü başlığının font boyutu
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home), // Ana sayfa ikonu
              title: Text('Ana Sayfa'), // Menüdeki seçenek adı
              onTap: () {
                Navigator.pop(context); // Menü kapatılır
              },
            ),
            ListTile(
              leading: Icon(Icons.settings), // Ayarlar ikonu
              title: Text('Ayarlar'), // Menüdeki seçenek adı
              onTap: () {
                Navigator.pop(context); // Menü kapatılır
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app), // Çıkış ikonu
              title: Text('Çıkış Yap'), // Menüdeki seçenek adı
              onTap: () {
                Navigator.pop(context); // Menü kapatılır
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5), // Hafif gri arka plan
        ),
        child: Column(
          children: [
            // Başlık Sabit Kalacak
            Padding(
              padding: const EdgeInsets.only(
                  top: 0.0), // Başlık ve kartlar arasındaki boşluk
              child: Text(
                'Diyet Paketleri',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Kartlar için Row
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    PaketKart('Basic Paket', 'Günlük öneriler, basit takip.',
                        Colors.blue, 0),
                    PaketKart(
                        'Premium Paket',
                        'Özel diyet listeleri, haftalık analizler.',
                        Colors.green,
                        1),
                    PaketKart(
                        'VIP Paket',
                        'Kişisel diyetisyen, gelişmiş analiz.',
                        Colors.orange,
                        2),
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
