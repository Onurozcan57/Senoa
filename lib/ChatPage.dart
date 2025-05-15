import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  // Her mesaj: {'role': 'user' / 'bot', 'text': '...', 'image': 'path'}
  final List<Map<String, String>> messages = [];

  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': text});
      messages.add({
        'role': 'bot',
        'text': 'Merhaba! Bu kısmı sonra yapay zeka ile dolduracağız.'
      });
    });

    _controller.clear();
  }

  Future<void> sendImageMessage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        messages.add({
          'role': 'user',
          'image': pickedFile.path, // Fotoğraf yolu
        });

        messages.add({
          'role': 'bot',
          'text': 'Fotoğraf aldım! Bir şeyler tanıyabilirim yakında :)'
        });
      });
    } else {
      print("Fotoğraf çekilmedi.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistan', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFA8D5BA),
        centerTitle: true,
        elevation: 4,
      ),
      body: Stack(
        children: [
          // Arka plan
          Opacity(
            opacity: 0.08,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/girisekrani.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isUser = msg['role'] == 'user';

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxWidth: 250),
                        decoration: BoxDecoration(
                          color:
                              isUser ? const Color(0xFF58A399) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: msg.containsKey('image')
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(msg['image']!),
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                msg['text'] ?? '',
                                style: TextStyle(
                                  color: isUser ? Colors.white : Colors.black87,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: Colors.white.withOpacity(0.8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Bir şeyler yaz...',
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: sendMessage,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFF58A399),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: sendImageMessage,
                      icon: const Icon(
                        Icons.photo_camera_back_outlined,
                        color: Color(0xFF58A399),
                        size: 35,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
