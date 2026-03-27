import 'package:flutter/material.dart';

import 'constant.dart';
ThemeData theme(){
  return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      fontFamily: "Muli",
      // ignore: prefer_const_constructors
      appBarTheme: appBarTheme(),
      // ignore: prefer_const_constructors
      textTheme: textTheme(),
      inputDecorationTheme: inputDecorationTheme(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kTextColor),
            gapPadding: 10,
          );
  return InputDecorationTheme(
       
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 45,
            vertical: 20,
          ),
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,

        );
}

TextTheme textTheme() {
  return TextTheme(
      bodyLarge: const TextStyle(color: kTextColor),
      bodyMedium: const TextStyle(color: kTextColor)
      );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
      color: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: const TextStyle(color: Color(0XFF888888),fontSize: 18),
    );
}
