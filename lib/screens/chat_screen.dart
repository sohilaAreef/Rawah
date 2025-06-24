import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rawah/utils/app_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() => _isSending = true);
    await FirebaseFirestore.instance.collection('messages').add({
      'text': message,
      'sender': 'user',
      'timestamp': Timestamp.now(),
    });

    final reply = await getRawahReply(message);

    await FirebaseFirestore.instance.collection('messages').add({
      'text': reply,
      'sender': 'rawah',
      'timestamp': Timestamp.now(),
    });

    setState(() => _isSending = false);
    _scrollToBottom();
  }

  Future<String> getRawahReply(String message) async {
    const apiKey =
        "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";
    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://chat.openai.com/',
          'X-Title': 'Rawah Chat',
        },
        body: jsonEncode({
          "model": "openai/gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content":
                  "أنت شات بوت اسمه رواح، تم تصميمك لتقديم الدعم النفسي للمستخدمين باللغة العربية الفصحى، بطريقة لطيفة، متفهمة، وحنونة. تحدث وكأنك طبيب نفسي متعاطف، شجّع المستخدم على التعبير عن مشاعره، وقدم نصائح تشعره بالأمان والدعم دون أي تشخيص طبي.",
            },
            {"role": "user", "content": message},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "حدثت مشكلة: ${response.statusCode}";
      }
    } catch (e) {
      return "فشل الاتصال بالخادم، تأكد من اتصالك بالإنترنت.";
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageBubble(bool isUser, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/rawah.jpg'),
            ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: isUser ? 40 : 8,
                right: isUser ? 8 : 40,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.accent
                    : AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: isUser ? Colors.white : Colors.black87,
                  height: 1.4,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          if (isUser)
            const CircleAvatar(radius: 16, backgroundColor: Colors.transparent),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              "رواح - صديقك النفسي",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/images/rawah.jpg'),
              ),
            ),
          ],
        ),
        centerTitle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  );
                }

                final messages = snapshot.data!.docs;
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'مرحباً، أنا رواح.. مستعد لأسمعك',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'كيف تشعر اليوم؟',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return _buildMessageBubble(
                      msg['sender'] == 'user',
                      msg['text'],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (_isSending)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: "كيف تشعر الآن؟ رواح سينصت إليك 🌿",
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                sendMessage(value.trim());
                                _controller.clear();
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.send_rounded,
                            color: AppColors.accent,
                          ),
                          onPressed: () {
                            final text = _controller.text.trim();
                            if (text.isNotEmpty) {
                              sendMessage(text);
                              _controller.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
