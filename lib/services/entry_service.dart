import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rawah/models/entry.dart';

class EntryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _entriesCollection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('users').doc(userId).collection('entries');
  }

  Future<void> addEntry(Entry entry) async {
    try {
      await _entriesCollection.add({
        'type': entry.type.index,
        'text': entry.text,
        'date': Timestamp.fromDate(entry.date),
        'isCompleted': entry.isCompleted,
      });
    } catch (e) {
      print('Error adding entry: $e');
      rethrow;
    }
  }

  Future<void> updateEntry(Entry entry) async {
    try {
      await _entriesCollection.doc(entry.id).update({
        'text': entry.text,
        'isCompleted': entry.isCompleted,
      });
    } catch (e) {
      print('Error updating entry: $e');
      rethrow;
    }
  }

  Future<void> deleteEntry(String entryId) async {
    try {
      await _entriesCollection.doc(entryId).delete();
    } catch (e) {
      print('Error deleting entry: $e');
      rethrow;
    }
  }

  Future<void> toggleCompletion(String entryId, bool isCompleted) async {
    try {
      await _entriesCollection.doc(entryId).update({
        'isCompleted': isCompleted,
      });
    } catch (e) {
      print('Error toggling completion: $e');
      rethrow;
    }
  }

  Stream<List<Entry>> getEntries() {
    try {
      return _entriesCollection
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return Entry(
                id: doc.id,
                type: EntryType.values[doc['type']],
                text: doc['text'],
                date: (doc['date'] as Timestamp).toDate(),
                isCompleted: doc['isCompleted'],
              );
            }).toList();
          });
    } catch (e) {
      print('Error getting entries: $e');
      return Stream.error(e);
    }
  }
}
