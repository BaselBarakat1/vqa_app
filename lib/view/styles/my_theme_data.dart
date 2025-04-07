import 'package:flutter/material.dart';

class MyThemeData {

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          padding: EdgeInsets.symmetric(vertical: 16),
          backgroundColor:Color(0xff18222E),
          textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 14),
        )
    ),
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.white
      )
    )
  );
}