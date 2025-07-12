import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rawah/utils/app_colors.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  String? _selectedMessageId;
  bool _showScrollDownButton = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      _sendWelcomeMessageIfNeeded();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  CollectionReference get _messagesCollection {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('messages');
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty || _currentUser == null) return;

    setState(() {
      _isSending = true;
      _selectedMessageId = null;
    });

    await _messagesCollection.add({
      'text': message,
      'sender': 'user',
      'timestamp': Timestamp.now(),
    });

    final reply = await getRawahReply(message);

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
      final snapshot = await _messagesCollection
          .orderBy('timestamp', descending: false)
          .limitToLast(10)
          .get();

      final List<Map<String, dynamic>> history = [
        {
          'role': 'user',
          'parts': [
            {
              'text':
                  'أنت رواح، شات بوت داخل تطبيق اسمه رواح ايضا, التطبيق يسهل على المستخدم تتبع اهدافه, وتسجيل النجازات والامتنان وتتبع المشاعر اليومية, منا ايضا المشاعر السلبية حيث يتيح للمستخم اختبار للشعور السلبي للتأكد ان كان يشعر به او لا كما ايضا يتيح للمستخدم اضافة قيمه الشخصية المهمة وخطوات عملية لتطبيقها, عمل على فكرة المشروع طالبات من كلية الهندسة جامعة الأزهر قسم نظم وحاسبات دفعة 2025,سهيلة عريف هي المطورة الأساسية وباقي الفريق أسماء محمد ورفيدة عصام وميرفت فوزي ومنار السيد اذا سألك الميتخدم عنن التطبيق او المطورون فاخبرهم, دينك الإسلام وتؤمن بالله تم تصميمه لتقديم دعم نفسي مبني على الوحي (القرآن والسنة) والطب النفسي المتزن، بأسلوب لطيف ومتفهم. دورك أن تستمع للمستخدم، تواسيه، وتربط مشاعره بالله برفق، كما يفعل د. عبد الرحمن ذاكر الهاشمي ولكن لا تذكر للناس أنك صممت لتكون مثله. لا تُشخّص المستخدم، ولا تصدر أحكامًا، فقط قُده بلُطف نحو الطمأنينة والإيمان، وذكره بالله وبقيمه الإسلامية عند الحاجة ولكن لا تذكر لأحد كلمة (عند الحاجة)  ولا ترد ردا طويلا الا عند الحاجة استخدم القاب الصداقة لا الحب أي قل له دائما صديقي لا حبيبي  نظرتك للأمور معتمدة على شرع الله, لا تذكر ادلة الا وانت متأكد ومرجعك ايلام ويب في الاحكام  واهم شيء في حياتنا هي عبادة الله" هكذا يكون منظورنا الاسلامي\nاذا سألك أحد عن دينك فأخبره أنك مسلم  , لأنك بالفعل كذلك قدم حولا عملية اكثر من الكلام المرسل والفارغ .. افهم المشاعر من بين السطور وتصرف بناءا على ذلم .. استشهد بالابات في موضعها الصحيح كن ذكيا ومراعيا',
            },
          ],
        },
      ];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final role = data['sender'] == 'user' ? 'user' : 'model';
        history.add({
          'role': role,
          'parts': [
            {'text': data['text']},
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

  Future<void> _sendWelcomeMessageIfNeeded() async {
    final latestSnapshot = await _messagesCollection
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (latestSnapshot.docs.isNotEmpty) {
      final last = latestSnapshot.docs.first.data() as Map<String, dynamic>;
      final lastText = last['text'] ?? '';
      final lastSender = last['sender'] ?? '';

      if (lastSender == 'rawah' &&
          lastText.contains('مرحباً بك في محادثة رواح')) {
        return;
      }
    }

    await _messagesCollection.add({
      'text':
          'مرحباً بك في محادثة رواح 🌿\nأنا هنا دائمًا لأسمعك ونتكلم سوا وقت ما تحتاج.',
      'sender': 'rawah',
      'timestamp': Timestamp.now(),
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _copyMessage(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الرسالة بنجاح'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _deleteMessage(String docId) async {
    await _messagesCollection.doc(docId).delete();
    setState(() => _selectedMessageId = null);
  }

  Widget _buildMessageBubble(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final isUser = data['sender'] == 'user';
    final text = data['text'] ?? '';
    final isSelected = _selectedMessageId == doc.id;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
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
                child: GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      setState(() => _selectedMessageId = null);
                    } else {
                      setState(() => _selectedMessageId = doc.id);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: isUser ? 40 : 8,
                      right: isUser ? 8 : 40,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
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
              ),
              if (isUser)
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.transparent,
                ),
            ],
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: isUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  // Copy button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.copy,
                            size: 20,
                            color: Colors.grey[700],
                          ),
                          onPressed: () => _copyMessage(text),
                          tooltip: 'نسخ الرسالة',
                        ),
                        Text(
                          'نسخ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Delete button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, size: 20, color: Colors.red),
                          onPressed: () => _deleteMessage(doc.id),
                          tooltip: 'حذف الرسالة',
                        ),
                        Text(
                          'حذف',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    setState(() {
                      _showScrollDownButton =
                          _scrollController.offset <
                          _scrollController.position.maxScrollExtent - 100;
                    });
                  }
                  return false;
                },
                child: StreamBuilder<QuerySnapshot>(
                  stream: _messagesCollection.orderBy('timestamp').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accent,
                        ),
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
                      padding: const EdgeInsets.only(top: 16, bottom: 80),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return _buildMessageBubble(msg);
                      },
                    );
                  },
                ),
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
                    child: SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  controller: _controller,

                                  textAlign: TextAlign.start,
                                  minLines: 1,
                                  maxLines: 4,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    hintText:
                                        "كيف تشعر الآن؟ رواح سينصت إليك 🌿",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    border: InputBorder.none,
                                  ),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _showScrollDownButton
          ? Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppColors.accent.withOpacity(0.3),
                onPressed: _scrollToBottom,
                child: const Icon(Icons.arrow_downward, color: Colors.white),
              ),
            )
          : null,
    );
  }
}
