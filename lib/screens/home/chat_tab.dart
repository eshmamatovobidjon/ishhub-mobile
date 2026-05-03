import 'package:flutter/material.dart';
import '../chat/chat_list_screen.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suhbatlar')),
      body: const ChatListScreen(),
    );
  }
}
