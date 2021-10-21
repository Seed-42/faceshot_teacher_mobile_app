import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getTheme(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      canvasColor: Colors.transparent,

      //Icon Theme
      //iconTheme: const IconThemeData(color: Color(0xff45d8b0)),
      appBarTheme: const AppBarTheme(color: Colors.blueAccent),

      //Card Theme
      cardColor: const Color(0xFF0D0D0D),
      cardTheme: const CardTheme(
        color: Color(0xFF0D0D0D),
        elevation: 4,
        margin: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),

      //Button
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minWidth: 100,
        height: 50,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(10),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(10),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blueAccent,
      ),

      disabledColor: Colors.black54,
    );
  }
}
