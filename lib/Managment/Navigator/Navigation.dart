import 'package:flutter/material.dart';

class Navigate {

  static void NavigatePage(bool back , Widget page , BuildContext context) {
    if (back == true){
      
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    }else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => page), (route) => false);
    }
  }
}