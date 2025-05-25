import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../apis/api_func.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final ApiFunc _apiFunc = ApiFunc();

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

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty && _attachedImages.isEmpty)
      return;

    final userMessage = _messageController.text;

    setState(() {
      // Add user message
      _messages.add({
        'isUser': true,
        'message': userMessage,
        'time': DateTime.now(),
        'image': _attachedImages.isNotEmpty ? _attachedImages : null,
      });

      // Clear input and attached images
      _messageController.clear();
      _attachedImages = [];
    });

    try {
      // Call API to get response
      final botResponse = await _apiFunc.generateResponse(userMessage);

      setState(() {
        _messages.add({
          'isUser': false,
          'message': botResponse,
          'time': DateTime.now(),
          'image': null,
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'isUser': false,
          'message': 'Sorry, I encountered an error: $e',
          'time': DateTime.now(),
          'image': null,
        });
      });
    }
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.smart_toy_outlined, color: Colors.white, size: 28),
            SizedBox(width: 10),
            Text(
              "LearnEdge Assistant",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF7E57C2), Color(0xFF5E35B1), Color(0xFF4527A0)],
            ),
          ),
        ),
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Menu options placeholder
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://transparenttextures.com/patterns/subtle-white-feathers.png',
            ),
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  final isUser = message['isUser'] as bool;

                  return AnimatedSize(
                    duration: Duration(milliseconds: 200),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(isUser ? 1 : -1, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: ModalRoute.of(context)!.animation!,
                          curve: Interval(
                            0.1 * index,
                            0.9,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                      ),
                      child: Align(
                        alignment:
                            isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            gradient:
                                isUser
                                    ? LinearGradient(
                                      colors: [
                                        Color(0xFF7E57C2),
                                        Color(0xFF5E35B1),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                    : null,
                            color: isUser ? null : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(isUser ? 20 : 5),
                              topRight: Radius.circular(isUser ? 5 : 20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    isUser
                                        ? Colors.deepPurple.withOpacity(0.3)
                                        : Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(isUser ? 20 : 5),
                              topRight: Radius.circular(isUser ? 5 : 20),
                              bottomLeft: const Radius.circular(20),
                              bottomRight: const Radius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (message['image'] != null) ...[
                                  for (final imageUrl
                                      in message['image'] as List<String>)
                                    InkWell(
                                      onTap: () {
                                        // Open image in full screen
                                      },
                                      child: Stack(
                                        children: [
                                          Hero(
                                            tag: imageUrl,
                                            child: Image.network(
                                              imageUrl,
                                              width: double.infinity,
                                              height: 180,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Container(
                                                  height: 180,
                                                  color: Colors.grey[300],
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                      value:
                                                          loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                      color:
                                                          isUser
                                                              ? Colors.white
                                                              : Colors
                                                                  .deepPurple,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.6,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Icon(
                                                Icons.open_in_full,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color:
                                        isUser
                                            ? Colors.transparent
                                            : Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      !isUser
                                          ? Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF7E57C2),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.smart_toy_outlined,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                "Assistant",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF7E57C2),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )
                                          : SizedBox(),
                                      SizedBox(height: !isUser ? 8 : 0),
                                      Text(
                                        message['message'] as String,
                                        style: TextStyle(
                                          color:
                                              isUser
                                                  ? Colors.white
                                                  : Colors.black87,
                                          fontSize: 15,
                                          height: 1.4,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            DateFormat('h:mm a').format(
                                              message['time'] as DateTime,
                                            ),
                                            style: TextStyle(
                                              color:
                                                  isUser
                                                      ? Colors.white
                                                          .withOpacity(0.8)
                                                      : Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                          if (isUser) ...[
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.check_circle,
                                              size: 12,
                                              color: Colors.white.withOpacity(
                                                0.8,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Display attached images preview
            if (_attachedImages.isNotEmpty)
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _attachedImages.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.deepPurple.withOpacity(0.3),
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(_attachedImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                setState(() {
                                  _attachedImages.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: _attachImage,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_photo_alternate,
                          color: Colors.deepPurple,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.deepPurple.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Ask anything about AR/VR...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: _sendMessage,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
