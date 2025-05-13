import 'package:flutter/material.dart';
import 'dart:async';

class CanliDestekPage extends StatefulWidget {
  @override
  _CanliDestekPage createState() => _CanliDestekPage();
}

class _CanliDestekPage extends State<CanliDestekPage> {
  final List<String> quickReplies = [
    "Uygulamayı nasıl kullanırım?",
    "Hesabımı silebilir miyim?",
    "Verilerim güvende mi?",
    "Diyetisyenle nasıl iletişim kurarım?"
  ];

  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isTyping = false;
  String typingDots = ".";

  Timer? _typingTimer;

  void _startTypingAnimation() {
    typingDots = ".";
    _typingTimer?.cancel();
    _typingTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      setState(() {
        if (typingDots == "...") {
          typingDots = ".";
        } else {
          typingDots += ".";
        }
      });
    });
  }

  void _stopTypingAnimation() {
    _typingTimer?.cancel();
  }

  void _sendMessage() {
    String input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': input});
      _controller.clear();
      isTyping = true;
    });

    _scrollToBottom();
    _startTypingAnimation();

    Future.delayed(Duration(seconds: 1), () {
      _stopTypingAnimation();
      setState(() {
        _messages.add({
          'sender': 'bot',
          'text': _generateBotReply(input),
        });
        isTyping = false;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _generateBotReply(String userMessage) {
    return "Bu bir örnek yanıt: \"$userMessage\" mesajını aldım!";
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yapay Zeka Destek'),
        backgroundColor: Color(0xFFD69C6C),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(10),
              itemCount: _messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && isTyping) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(typingDots,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600])),
                    ),
                  );
                }

                final msg = _messages[index];
                final isUser = msg['sender'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.brown[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
          if (_messages.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: quickReplies.map((text) {
                  return GestureDetector(
                    onTap: () {
                      _controller.text = text;
                      _sendMessage();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFD69C6C).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF6E8D5),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Mesajınızı yazın...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Color(0xFFD69C6C)),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
