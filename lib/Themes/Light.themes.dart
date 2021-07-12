
import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
      dialogBackgroundColor: Colors.white,
      brightness: Brightness.light,
      primarySwatch:Colors.red,
      accentColor: Colors.redAccent,
      cardColor: Colors.white,
      fontFamily:"Brand Bold",
      textTheme: TextTheme(
        bodyText1: TextStyle(),
        bodyText2: TextStyle(),
      ).apply(
        bodyColor: Colors.black54,
        displayColor: Colors.white60,
      ),

      visualDensity: VisualDensity.adaptivePlatformDensity );
}