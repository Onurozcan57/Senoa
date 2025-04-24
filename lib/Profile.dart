import 'package:flutter/material.dart';

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
                opacity: 0.7),
          ),
        ),
        Scaffold(
          backgroundColor: const Color.fromARGB(
              0, 255, 255, 255), // Arka planı şeffaf yapıyoruz
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Profilim'),
            backgroundColor: Color.fromARGB(255, 13, 255, 0),
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            indicatorColor: Color.fromARGB(160, 16, 237, 5),
            selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                  selectedIcon: Icon(Icons.account_box),
                  icon: Icon(Icons.account_box_outlined),
                  label: 'Profilim'),
              NavigationDestination(
                icon: Badge(child: Icon(Icons.assignment_ind_outlined)),
                label: 'Diyetisyenim',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.messenger),
                icon: Icon(Icons.messenger_outline),
                label: 'Messages',
              ),
            ],
          ),
          drawer: Drawer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top,
                  width: double.infinity,
                  color: Color.fromARGB(255, 13, 255, 0),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16, bottom: 8),
                  child: SafeArea(
                    child: Text(
                      'Menü',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        title: Text('Diyetisyenim'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text("Akış"),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text('Profilim'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text('Çıkış'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                            "lib/assets/girisekrani.jpg",
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
            ]),
          ),
        ),
      ],
    );
  }
}
