import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rawah/data/values_data.dart';
import 'package:rawah/models/value_model.dart';

class ValueProvider with ChangeNotifier {
  List<ValueModel> selectedValues = [];
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ValueModel> get values => valuesList;

  void toggleValue(ValueModel value) {
    if (selectedValues.contains(value)) {
      selectedValues.remove(value);
    } else {
      selectedValues.add(value);
    }
    notifyListeners();
    _saveToFirebase();
  }

  void removeValue(ValueModel value) {
    if (selectedValues.contains(value)) {
      selectedValues.remove(value);
      notifyListeners();
      _saveToFirebase();
    }
  }

  bool isSelected(ValueModel value) {
    return selectedValues.contains(value);
  }

  Future<void> _saveToFirebase() async {
    if (_auth.currentUser == null) return;

    final userId = _auth.currentUser!.uid;
    final valuesIds = selectedValues.map((v) => v.id).toList();

    try {
      await _firestore.collection('users').doc(userId).set({
        'selectedValues': valuesIds,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving to Firebase: $e');
    }
  }

  Future<void> loadFromFirebase() async {
    if (_auth.currentUser == null) return;

    isLoading = true;
    notifyListeners();

    final userId = _auth.currentUser!.uid;

    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        final data = doc.data();
        final List<String> savedValuesIds = List<String>.from(
          data?['selectedValues'] ?? [],
        );

        selectedValues = valuesList
            .where((value) => savedValuesIds.contains(value.id))
            .toList();

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading from Firebase: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
