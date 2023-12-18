import 'package:flutter/material.dart';

InputDecoration InputField(
  Widget icon,
  String label,
) {
  return InputDecoration(
    prefixIcon: icon,
    label: Text(label),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.black, width: 2),
    ),
    focusColor: Colors.black,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.black, width: 2),
    ),
  );
}

InputDecoration SendField(
  Widget icon,
  String label,
  bool color,
  VoidCallback onsend,
) {
  return InputDecoration(

    suffixIcon: GestureDetector(
      onTap: onsend,
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            
            color: color ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            Icons.send,
            color: color ? Colors.black : Colors.white,
          ),
        ),
      ),
    ),
    prefixIcon: icon,
    label: Text(label , style: TextStyle(color: color ? Colors.white : Colors.black,),),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide:  BorderSide(color: color ? Colors.white : Colors.black, width: 2),
    ),
    focusColor: Colors.black,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide:  BorderSide(color: color ? Colors.white :Colors.black, width: 2),
    ),
  );
}
