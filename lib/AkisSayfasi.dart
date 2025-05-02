import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  int currentPageIndex = 0;
  List<Map<String, dynamic>> posts = [
    {
      "profile_Photo": "lib/assets/Onur_Ozcan.png",
      "username": "Onur_ÖZCAN57",
      "content":
          "Sağlıklı beslenme için gün içinde yeterli su içmeyi unutmayın! 💧",
      "time": "2 saat önce",
      "image": "lib/assets/girisekrani.jpg",
      "liked": false,
      "showComments": false,
      "comments": ["Çok doğru!", "Bunu daha çok uygulamalıyım."]
    },
    {
      "profile_Photo": "lib/assets/Nisa_Sakar.png",
      "username": "Nisanur_Şakar",
      "content":
          "Protein ihtiyacınızı karşılamak için hangi besinleri tercih ediyorsunuz? 🍗🥦",
      "time": "5 saat önce",
      "image": "lib/assets/arkaPlan.jpg",
      "liked": false,
      "showComments": false,
      "comments": ["Tavuk göğsü ve mercimek vazgeçilmezim!"]
    },
    {
      "profile_Photo": "lib/assets/girisekrani.jpg",
      "username": "sporcan",
      "content":
          "Antrenman öncesi bir avuç badem yemek enerji verir! Deneyin! 💪",
      "time": "1 gün önce",
      "image": "lib/assets/sporSalonu.jpeg",
      "liked": false,
      "showComments": false,
      "comments": ["Bu bilgiyi bilmiyordum, teşekkürler!", "Deneyeceğim!"]
    },
    {
      "profile_Photo": "lib/assets/girisekrani.jpg",
      "username": "veganlife",
      "content": "Vegan beslenmede B12 takviyesi almayı unutmayın! 🌱",
      "time": "3 gün önce",
      "image": "lib/assets/veganlife.jpeg",
      "liked": false,
      "showComments": false,
      "comments": ["Çok önemli bir detay!", "Harika öneri."]
    },
    {
      "profile_Photo": "lib/assets/girisekrani.jpg",
      "username": "fitanne",
      "content":
          "Çocuklar için sağlıklı atıştırmalık tarifleri isteyen var mı? 🍎🍌",
      "time": "4 saat önce",
      "image": "lib/assets/atistirmalik.jpeg",
      "liked": false,
      "showComments": false,
      "comments": ["Evet lütfen!", "Paylaşır mısınız tarifleri?"]
    },
    {
      "profile_Photo": "lib/assets/girisekrani.jpg",
      "username": "diyetisyen_ayse",
      "content":
          "Kahvaltıyı atlamak metabolizmayı yavaşlatabilir. Dengeli kahvaltı şart! 🍳🥑",
      "time": "Bugün",
      "image": "lib/assets/atistirmalik.jpeg",
      "liked": false,
      "showComments": false,
      "comments": ["Her sabah uyguluyorum!", "Kahvaltı favorim 💚"]
    }
  ];

  List<TextEditingController> commentControllers = [];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < posts.length; i++) {
      commentControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var controller in commentControllers) {
      controller.dispose();
    }
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void toggleLike(int index) {
    setState(() {
      posts[index]["liked"] = !posts[index]["liked"];
    });
  }

  void toggleComments(int index) {
    setState(() {
      posts[index]["showComments"] = !posts[index]["showComments"];
    });
  }

  void addComment(int index, String comment) {
    setState(() {
      posts[index]["comments"].add(comment);
    });
  }

  void addPost(String content) {
    setState(() {
      posts.insert(0, {
        "profile_Photo": "lib/assets/Onur_Ozcan.png",
        "username": "Onur_ÖZCAN57",
        "content": content,
        "time": "Şimdi",
        "image": "", // Varsayılan boş
        "liked": false,
        "showComments": false,
        "comments": [],
      });
      commentControllers.insert(0, TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Diyetisyenlik Uygulaması'),
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final post = posts[index];
                final commentController = commentControllers[index];

                return Card(
                  key: ValueKey("post_$index"),
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (post["profile_Photo"] != "")
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage(post["profile_Photo"]),
                                backgroundColor: Colors.grey[200],
                              ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                post["username"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        if (post["image"] != "")
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              post["image"],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                        SizedBox(height: 10),
                        Text(
                          post["content"],
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    post["liked"]
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: post["liked"]
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                  onPressed: () => toggleLike(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.comment),
                                  onPressed: () => toggleComments(index),
                                ),
                              ],
                            ),
                            Text(
                              post["time"],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        if (post["showComments"])
                          Column(
                            children: [
                              ...post["comments"]
                                  .map<Widget>((comment) => Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 4),
                                        child: Row(
                                          children: [
                                            Icon(Icons.comment,
                                                size: 16, color: Colors.grey),
                                            SizedBox(width: 6),
                                            Text(comment),
                                          ],
                                        ),
                                      )),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: commentController,
                                        decoration: InputDecoration(
                                          hintText: "Yorum ekle...",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () {
                                        if (commentController.text.isNotEmpty) {
                                          addComment(index,
                                              commentController.text.trim());
                                          commentController.clear();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
              childCount: posts.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 13, 255, 0),
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    top: 20,
                    left: 16,
                    right: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: contentController,
                      decoration: InputDecoration(
                        hintText: "Ne düşünüyorsun?",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (contentController.text.isNotEmpty) {
                          addPost(contentController.text.trim());
                          contentController.clear();
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 13, 255, 0),
                      ),
                      child: Text("Paylaş"),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
