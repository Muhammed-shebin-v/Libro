import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/domain/services/chat.dart';

class Chatscreen extends StatefulWidget {
  final String userId;

  const Chatscreen({super.key, required this.userId});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _auth = ChatService();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      await _auth.sendMessage(widget.userId, message);
      _messageController.clear();
    }
  }

  Widget _buildMessageItem(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final isUser = data['isUser'] ?? false;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final columnAlignment= isUser?CrossAxisAlignment.end:CrossAxisAlignment.start;
   final Timestamp timestamp = doc['timestamp']; 
   final DateTime dateTime = timestamp.toDate();
    return 
        Container(
          alignment: alignment,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: columnAlignment,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUser ? AppColors.color10: AppColors.color30,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(data['message'] ?? ''),
              ),
              Text( DateFormat('dd-MM-yyyy hh:mm a').format(dateTime),style: AppFonts.body2,)
            ],
          ),
        );
        
    
  
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                fillColor: AppColors.color10,
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                
                  
                ),
              
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _auth.getMessages(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];
        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(docs[index]);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: AppBar(title: const Text('Chat with Admin'),backgroundColor: AppColors.color60,),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList()),
           _buildUserInput(),
        ],
      ),
    );
  }
}
