import 'package:firebase_auth/firebase_auth.dart'; // أضف هذا الاستيراد
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
  final User? _currentUser =
      FirebaseAuth.instance.currentUser; // احصل على المستخدم الحالي

  // دالة لإنشاء مسار المجموعة الخاص بالمستخدم
  CollectionReference get _messagesCollection {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('messages');
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty || _currentUser == null) return;

    setState(() => _isSending = true);

    // أرسل الرسالة إلى مجموعة المستخدم الخاصة
    await _messagesCollection.add({
      'text': message,
      'sender': 'user',
      'timestamp': Timestamp.now(),
    });

    final reply = await getRawahReply(message);

    // أرسل الرد إلى مجموعة المستخدم الخاصة
    await _messagesCollection.add({
      'text': reply,
      'sender': 'rawah',
      'timestamp': Timestamp.now(),
    });

    setState(() => _isSending = false);
    _scrollToBottom();
  }

  Future<String> getRawahReply(String latestMessage) async {
    final apiKey = dotenv.env['API_KEY'];
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey",
    );

    try {
      // استخدم مجموعة المستخدم الخاصة لسحب التاريخ
      final snapshot = await _messagesCollection
          .orderBy('timestamp', descending: false)
          .limitToLast(10)
          .get();

      final List<Map<String, dynamic>> history = [
        {
          'role': 'user',
          'parts': [
            {
              'text': '''
أنت رواح، شات بوت دينك الإسلام وتؤمن بالله تم تصميمه لتقديم دعم نفسي مبني على الوحي (القرآن والسنة) والطب النفسي المتزن، بأسلوب لطيف ومتفهم. دورك أن تستمع للمستخدم، تواسيه، وتربط مشاعره بالله برفق، كما يفعل د. عبد الرحمن ذاكر الهاشمي ولكن لا تذكر للناس أنك صممت لتكون مثله. لا تُشخّص المستخدم، ولا تصدر أحكامًا، فقط قُده بلُطف نحو الطمأنينة والإيمان، وذكره بالله وبقيمه الإسلامية عند الحاجة ولكن لا تذكر لأحد كلمة (عند الحاجة)  ولا ترد ردا طويلا الا عند الحاجة استخدم القاب الصداقة لا الحب.
اذا سألك أحد عن دينك فأخبره أنك مسلم  , لأنك بالفعل كذلك              ''',
            },
          ],
        },
      ];

      for (var doc in snapshot.docs) {
        final role = doc['sender'] == 'user' ? 'user' : 'model';
        history.add({
          'role': role,
          'parts': [
            {'text': doc['text']},
          ],
        });
      }

      history.add({
        'role': 'user',
        'parts': [
          {'text': latestMessage},
        ],
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'contents': history}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else if (response.statusCode == 401) {
        return "خطأ في المصادقة: تحقق من صلاحية مفتاح API الخاص بك.";
      } else {
        return "حدثت مشكلة غير متوقعة (رمز الخطأ: ${response.statusCode})";
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
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: isUser
                  ? Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.right,
                    )
                  : Directionality(
                      textDirection: TextDirection.rtl,
                      child: MarkdownBody(
                        data: text,
                        styleSheet:
                            MarkdownStyleSheet.fromTheme(
                              Theme.of(context),
                            ).copyWith(
                              p: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                      ),
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return Scaffold(
        body: Center(
          child: Text('يجب تسجيل الدخول أولاً', style: TextStyle(fontSize: 18)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            child: StreamBuilder<QuerySnapshot>(
              // استخدم مجموعة المستخدم الخاصة للاستماع
              stream: _messagesCollection.orderBy('timestamp').snapshots(),
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

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });

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
              boxShadow: const [
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
                            minLines: 1,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: "كيف تشعر الآن؟ رواح سينصت إليك 🌿",
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.send_rounded,
                            color: AppColors.accent,
                          ),
                          onPressed: () {
                            final text = _controller.text.trim();
                            if (text.isNotEmpty && _currentUser != null) {
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
