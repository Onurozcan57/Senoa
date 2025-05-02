import 'package:flutter/material.dart';
import 'package:senoa/AkisSayfasi.dart';
import 'package:senoa/AnaSayfa.dart';
import 'package:senoa/Diyetisyenim.dart';
import 'package:senoa/LoginScreen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Profile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/assets/girisekrani.jpg"),
                fit: BoxFit.cover,
                opacity: 0.8),
          ),
        ),
        Scaffold(
          backgroundColor: const Color.fromARGB(
              154, 255, 255, 255), // Arka planı şeffaf yapıyoruz
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Profilim'),
            backgroundColor: Color(0xFFD69C6C),
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
            ],
          ),

          body: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            "lib/assets/Onur_Ozcan.png",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
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
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.all(3),
                  child: ListTile(
                    onTap: () {
                      _showSettingsPopup(context);
                    },
                    title: Text(
                      "Ayarlar",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green),
                    ),
                    leading: Icon(
                      Icons.settings_suggest,
                      size: 45,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.all(3),
                  child: ListTile(
                    onTap: () {},
                    title: Text(
                      "İletişim Bilgilerini Değiştir",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green),
                    ),
                    leading: Icon(
                      Icons.phone_android_sharp,
                      size: 45,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.all(3),
                  child: ListTile(
                    onTap: () {},
                    title: Text(
                      "Şifremi Unuttum",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green),
                    ),
                    leading: Icon(
                      Icons.password,
                      size: 45,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.all(3),
                  child: ListTile(
                    onTap: () {},
                    title: Text(
                      "Çıkış",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green),
                    ),
                    leading: Icon(
                      Icons.output_sharp,
                      size: 45,
                      color: Colors.orange,
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ],
    );
  }
}

void _showSettingsPopup(BuildContext context) {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  String selectedLanguage = "tr"; // varsayılan dil: Türkçe

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Ayarlar",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  ),
                  child: SwitchListTile(
                    title: const Text("Karanlık Mod"),
                    value: isDarkMode,
                    activeColor: Colors.black,
                    onChanged: (value) {
                      setState(() => isDarkMode = value);
                      // Temayı değiştirme işlemi
                    },
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  ),
                  child: SwitchListTile(
                    title: const Text("Bildirimler"),
                    value: notificationsEnabled,
                    activeColor: Color(0xFFD69C6C),
                    onChanged: (value) {
                      setState(() => notificationsEnabled = value);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "Dil Seçimi:",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: selectedLanguage,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedLanguage = newValue;
                          });
                          // Burada dil değişimini uygulamaya yansıtabilirsin
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'tr',
                          child: Text("Türkçe"),
                        ),
                        DropdownMenuItem(
                          value: 'en',
                          child: Text("English"),
                        ),
                        DropdownMenuItem(
                          value: 'de',
                          child: Text("Deutsch"),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD69C6C),
                    foregroundColor: Colors.white,
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Kaydet ve Kapat"),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
