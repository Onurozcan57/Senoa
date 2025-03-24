import 'package:flutter/material.dart';

class Diyetisyenim extends StatefulWidget {
  const Diyetisyenim({super.key});

  @override
  State<Diyetisyenim> createState() => _DiyetisyenimState();
}

class _DiyetisyenimState extends State<Diyetisyenim> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF34C759),
          title: Text("Dİyetisyenim"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 5, // Gölgeleme ekliyoruz
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15), // Kutu köşelerini yuvarlatıyoruz
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16), // Card içindeki padding
                    child: Row(
                      children: [
                        // Profil Fotoğrafı
                        ClipOval(
                          child: Image.asset(
                            "lib/assets/girisekrani.jpg", // Profil resminin yolu
                            width: 100, // Resmin genişliği
                            height: 100, // Resmin yüksekliği
                            fit: BoxFit.cover, // Resmi sığdırıyoruz
                          ),
                        ),
                        SizedBox(
                            width:
                                16), // Profil fotoğrafı ile yazılar arasına boşluk ekliyoruz
                        // Profil Bilgileri
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Onur Özcan",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "E-mail: onur.islem57@gmail.com",

                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey[700]),
                                maxLines: 2, // Maksimum 2 satıra kadar izin
                                overflow:
                                    TextOverflow.ellipsis, // Taşmayı önler
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Tel No: +90 555 555 55 55",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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
                    SizedBox(
                        width: 10), // İkon ile yazı arasına boşluk ekliyoruz
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Alınması Gereken Kalori Miktarı:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color:
                                Colors.grey[700], // Yazı rengini gri yapıyoruz
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
              SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Column(
                  children: [
                    Text(
                      "Bugün Ne Kadar Su İçtin?",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      onTap: () {
                        // bilgiyi database gönderecek
                        print("Onur Özcan");
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 255, 0, 0)),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 204, 243, 205)
                            .withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 0, 0)),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Diyet Listemmm",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
