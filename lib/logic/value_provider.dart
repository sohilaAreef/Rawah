import 'package:flutter/material.dart';
import 'package:rawah/models/value_model.dart';

class ValueProvider extends ChangeNotifier{

  List <ValueModel> selectedValues = [];

  void toggleValue(ValueModel value){
    if(selectedValues.contains(value)){
      selectedValues.remove(value);
    }else{
      if(selectedValues.length < 3){
        selectedValues.add(value);
      }
    }
    notifyListeners();
  }
  bool isSelected(ValueModel value){
    return selectedValues.contains(value);
  }
}