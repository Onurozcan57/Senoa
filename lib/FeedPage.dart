import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
      "image": "lib/assets/su.jpg",
      "liked": false,
      "showComments": false,
      "comments": [
        {
          "username": "elif_diyet",
          "profile": "lib/assets/Nisa_Sakar.png",
          "text": "Çok doğru!"
        },
        {
          "username": "fitbaba",
          "profile": "lib/assets/girisekrani.jpg",
          "text": "Bunu daha çok uygulamalıyım."
        }
      ]
    },
    {
      "profile_Photo": "lib/assets/Nisa_Sakar.png",
      "username": "Nisanur_Şakar",
      "content":
          "Protein ihtiyacınızı karşılamak için hangi besinleri tercih ediyorsunuz? 🍗🥦",
      "time": "5 saat önce",
      "image": "lib/assets/proteinn.jpeg",
      "liked": false,
      "showComments": false,
      "comments": [
        {
          "username": "Terorist_push_up",
          "profile": "lib/assets/Nisa_Sakar.png",
          "text": "Çok doğru!"
        },
        {
          "username": "fitbaba",
          "profile": "lib/assets/girisekrani.jpg",
          "text": "Bunu daha çok uygulamalıyım."
        }
      ]
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
      "comments": [
        {
          "username": "Nİke_Prosu",
          "profile": "lib/assets/Nisa_Sakar.png",
          "text": "Çok doğru!"
        },
        {
          "username": "fitbaba",
          "profile": "lib/assets/girisekrani.jpg",
          "text": "Bunu daha çok uygulamalıyım."
        }
      ]
    },
    {
      "profile_Photo": "lib/assets/girisekrani.jpg",
      "username": "veganlife",
      "content": "Vegan beslenmede B12 takviyesi almayı unutmayın! 🌱",
      "time": "3 gün önce",
      "image": "lib/assets/veganlife.jpeg",
      "liked": false,
      "showComments": false,
      "comments": [
        {
          "username": "elif_diyet",
          "profile": "lib/assets/Nisa_Sakar.png",
          "text": "Çok doğru!"
        },
        {
          "username": "fitbaba",
          "profile": "lib/assets/girisekrani.jpg",
          "text": "Bunu daha çok uygulamalıyım."
        }
      ]
    },
    {
      "profile_Photo": "lib/assets/girisekrani.jpg",
      "username": "fitanne",
      "content":
          "Çocuklar için sağlıklı atıştırmalık tarifleri isteyen var mı? 🍎🍌",
      "time": "4 saat önce",
      "image": "lib/assets/cocuk.jpeg",
      "liked": false,
      "showComments": false,
      "comments": [
        {
          "username": "selin_healthy",
          "profile": "lib/assets/Onur_Ozcan.png",
          "text": "Evet lütfen!"
        },
        {
          "username": "healthy_mama",
          "profile": "lib/assets/girisekrani.jpg",
          "text": "Paylaşır mısınız tarifleri?"
        }
      ]
    },
    {
      "profile_Photo": "lib/assets/girisekrani.jpg",
      "username": "diyetisyen_ayse",
      "content":
          "Kahvaltıyı atlamak metabolizmayı yavaşlatabilir. Dengeli kahvaltı şart! 🍳🥑",
      "time": "Bugün",
      "image": "lib/assets/kahvalti.jpeg",
      "liked": false,
      "showComments": false,
      "comments": [
        {
          "username": "fitbaba",
          "profile": "lib/assets/Nisa_Sakar.png",
          "text": "Her sabah uyguluyorum!"
        },
        {
          "username": "ahmetcan_diyet",
          "profile": "lib/assets/girisekrani.jpg",
          "text": "Kahvaltı favorim 💚"
        }
      ]
    },
    {
      "profile_Photo": "lib/assets/girisekrani.jpg",
      "username": "nutrition_tips",
      "content":
          "Günde 10 bin adım atmak sağlıklı bir yaşam için çok önemli! 🏃‍♂️",
      "time": "Bugün",
      "image": "lib/assets/yuruyus.jpg",
      "liked": false,
      "showComments": false,
      "comments": [
        {
          "username": "health_and_fitness",
          "profile": "lib/assets/Onur_Ozcan.png",
          "text": "Kesinlikle, her gün adım saymaya dikkat ediyorum!"
        },
        {
          "username": "running_man",
          "profile": "lib/assets/arkaPlan.jpg",
          "text": "Harika bir motivasyon!"
        }
      ]
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
    final post = posts[index];
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Yorumlar",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              ...post["comments"].map<Widget>((yorum) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(yorum["profile"]),
                    ),
                    title: Text(yorum["username"]),
                    subtitle: Text(yorum["text"]),
                  )),
              Divider(),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("lib/assets/Onur_Ozcan.png"),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: "Yorumunuzu yazın...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (commentController.text.trim().isNotEmpty) {
                        addComment(index, {
                          "username": "Onur_ÖZCAN57",
                          "profile": "lib/assets/Onur_Ozcan.png",
                          "text": commentController.text.trim(),
                        });
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void addComment(int index, Map<String, String> comment) {
    setState(() {
      posts[index]["comments"].add(comment);
    });
  }

  void showAddPostDialog(BuildContext context) {
    TextEditingController postContentController = TextEditingController();
    File? selectedImage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> pickImage() async {
              final picker = ImagePicker();
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  selectedImage = File(pickedFile.path);
                });
              }
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              title:
                  Text('Yeni Gönderi', style: TextStyle(color: Colors.black87)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: postContentController,
                      decoration: InputDecoration(
                        hintText: 'Gönderi içeriğini yazın...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      maxLines: 5,
                    ),
                    SizedBox(height: 10),
                    if (selectedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(selectedImage!, height: 150),
                      ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: pickImage,
                      icon: Icon(Icons.photo, color: Colors.white),
                      label: Text('Fotoğraf Ekle',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF58A399),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('İptal'),
                ),
                TextButton(
                  onPressed: () {
                    String content = postContentController.text.trim();
                    if (content.isNotEmpty) {
                      addPost(content, selectedImage?.path ?? "");
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lütfen içerik girin')),
                      );
                    }
                  },
                  child: Text('Gönder'),
                ),
              ],
            );
          },
        );
      },
    );
  }
// FloatingActionButton kodu

  void addPost(String content, String imagePath) {
    setState(() {
      posts.insert(0, {
        "profile_Photo": "lib/assets/Onur_Ozcan.png",
        "username": "Onur_ÖZCAN57",
        "content": content,
        "time": "Şimdi",
        "image": imagePath,
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
      backgroundColor: Color(0xFFF8FAF9),
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
                            child:
                                post["image"].toString().contains("lib/assets/")
                                    ? Image.asset(post["image"],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 200)
                                    : Image.file(File(post["image"]),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 200),
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
                                        ? Color(0xFF58A399)
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
        onPressed: () {
          showAddPostDialog(context); // Butona tıklanınca dialog açılır
        },
        backgroundColor: Color(0xFF58A399),
        child: Icon(Icons.add, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
