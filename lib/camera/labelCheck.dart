import 'package:flutter/material.dart';
import 'package:maga/camera/recycleModel.dart';

class LabelCheck {
  //final String label;
  //LabelCheck(this.label);
  // 0 is not recycle 1 is recycle 2 is booking for council collect.3 e-waste
  int check(String label) {
    String formatted = label.toLowerCase().trim();
    if (formatted.contains('bottle')) {
      return 1;
    }
    if (formatted.contains('furniture') || formatted.contains('chair') || formatted.contains('table') || formatted.contains('desk')) {
      return 2;
    }
    if(formatted.contains('electronic')){
      return 3;
    }
    if (formatted.contains('plastic')) {
      if (formatted.compareTo('plastic wrap') == 0 ||
          formatted.compareTo('plastic bag') == 0) return 0;
      return 1;
    }
    if (formatted.contains('glass') && formatted.contains('bottle')) {
      return 1;
    }
    if (formatted.contains('cardboard') || formatted.contains('carton')) {
      return 1;
    }
    if (formatted.contains('metal') || formatted.contains('copper')) {
      return 1;
    }
    return 0;
  }
}
