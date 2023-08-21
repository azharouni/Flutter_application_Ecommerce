import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterp/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const kPrimaryColor = Color.fromARGB(255, 67, 145, 255);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

final headingSttyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Veuillez saisir votre  email";
const String kInvalidEmailError = "Veuillez saisir un Email Valid ";
const String kPassNullError = "Veuillez saisir votre password";
const String kShortPassError = "Le mot de passe est trop court";
const String kMatchPassError = "Les mots de passe ne correspondent pas";
const String kNamelNullError = "Veuillez saisir votre  name";
const String kPhoneNumberNullError =
    "Veuillez saisir votre  numero de télephone";
const String kAddressNullError = "Veuillez saisir votre adresse";
const String kprenomNullError = "Veuillez saisir votre  prenom";
const String kvilleNullError = "Veuillez saisir votre ville";

Future<void> setVariable(String key, dynamic value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (value is int) {
    await prefs.setInt(key, value);
  } else if (value is double) {
    await prefs.setDouble(key, value);
  } else if (value is String) {
    await prefs.setString(key, value);
  } else if (value is bool) {
    await prefs.setBool(key, value);
  } else if (value is List<String>) {
    await prefs.setStringList(key, value);
  }
}

Future<String> getSharedPrefValue(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String variable = prefs.getString(key).toString();
  return variable;
}

dynamic convertResponseBodyToJson(String responseBody) {
  // Convert the response body to JSON
  return json.decode(responseBody);
}

String serverUrl = "http://localhost:8000";
