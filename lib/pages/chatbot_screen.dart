import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'message':
          'Hello! I\'m your AR/VR learning assistant. How can I help you today?',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
      'image': null,
    },
  ];

  List<String> _attachedImages = [];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty && _attachedImages.isEmpty)
      return;

    setState(() {
      // Add user message
      _messages.add({
        'isUser': true,
        'message': _messageController.text,
        'time': DateTime.now(),
        'image': _attachedImages.isNotEmpty ? _attachedImages : null,
      });

      // Clear input and attached images
      _messageController.clear();
      _attachedImages = [];

      // Simulate bot response after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add({
            'isUser': false,
            'message':
                'I understand you\'re interested in AR/VR technology. Would you like me to recommend some learning resources?',
            'time': DateTime.now(),
            'image': null,
          });
        });
      });
    });
  }

  void _attachImage() {
    // In a real app, this would use image_picker to get images from gallery or camera
    setState(() {
      _attachedImages.add(
        'https://images.unsplash.com/photo-1617802690992-15d93263d3a9?ixlib=rb-1.2.1&auto=format&fit=crop',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Learning Assistant'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                final isUser = message['isUser'] as bool;

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.deepPurple : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message['image'] != null) ...[
                          for (final imageUrl
                              in message['image'] as List<String>)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        ],
                        Text(
                          message['message'] as String,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat(
                            'h:mm a',
                          ).format(message['time'] as DateTime),
                          style: TextStyle(
                            color: isUser ? Colors.white70 : Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Display attached images preview
          if (_attachedImages.isNotEmpty)
            Container(
              height: 70,
              color: Colors.grey[200],
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _attachedImages.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(_attachedImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _attachedImages.removeAt(index);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          // Message input area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.add_photo_alternate,
                    color: Colors.deepPurple,
                  ),
                  onPressed: _attachImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask anything about AR/VR...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
