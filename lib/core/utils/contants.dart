import 'package:flutter/material.dart';

Widget kRepeatedText({required String title}) {
  return Text(title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ));
}

TextStyle customTextStyle(
    {Color textColor = Colors.white, FontWeight fontWeight = FontWeight.bold,double fontSize =16}) {
  return TextStyle(fontSize: fontSize, color: textColor, fontWeight: fontWeight);
}
