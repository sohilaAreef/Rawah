import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rawah/models/daily_emotion.dart';

class EmotionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // إضافة مشاعر جديدة
  Future<void> addDailyEmotion(DailyEmotion emotion) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('emotions')
        .add({
          'type': emotion.type.toString().split('.').last,
          'intensity': emotion.intensity,
          'date': Timestamp.fromDate(emotion.date),
        });
  }

  // جلب المشاعر خلال فترة محددة
  Future<List<DailyEmotion>> getEmotions(DateTime start, DateTime end) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final query = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('emotions')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('date', descending: true)
        .get();

    return query.docs.map((doc) {
      final data = doc.data();
      return DailyEmotion(
        type: _parseEmotionType(data['type']),
        intensity: data['intensity'],
        date: (data['date'] as Timestamp).toDate(),
      );
    }).toList();
  }

  // جلب المشاعر للأسبوع الحالي
  Future<List<DailyEmotion>> getWeeklyEmotions() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return getEmotions(
      DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
    );
  }

  // تحويل النص إلى نوع المشاعر
  EmotionType _parseEmotionType(String type) {
    switch (type) {
      case 'happy':
        return EmotionType.happy;
      case 'sad':
        return EmotionType.sad;
      case 'angry':
        return EmotionType.angry;
      case 'anxious':
        return EmotionType.anxious;
      case 'excited':
        return EmotionType.excited;
      case 'calm':
        return EmotionType.calm;
      case 'tired':
        return EmotionType.tired;
      default:
        return EmotionType.neutral;
    }
  }
}
