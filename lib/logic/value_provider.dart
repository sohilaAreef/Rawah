import 'package:flutter/material.dart';
import 'package:rawah/data/values_data.dart';
import 'package:rawah/models/value_model.dart'; 

class ValueProvider with ChangeNotifier {
  List<ValueModel> selectedValues = [];
  List <ValueModel> get values => valuesList;


  void toggleValue(ValueModel value) {
    if (selectedValues.contains(value)) {
      selectedValues.remove(value);
    } else {
      if (selectedValues.length < 5) {
        selectedValues.add(value);
      }
    }
    notifyListeners();  
  }
  bool isSelected(ValueModel value) {
    return selectedValues.contains(value);
  }
}
