import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<void> saveUserData({
    required String uid,
    required String username,
    required String email,
  }) async {
    await users.doc(uid).set({
      'username': username,
      'email': email,
      'createdAt': Timestamp.now(),
    });
  }

  Future<String?> getUidByUsername(String username) async {
    final snapshot = await users.where('username', isEqualTo: username).get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }
}
