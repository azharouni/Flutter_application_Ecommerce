import 'package:flutter/material.dart';
import 'package:flutterp/screens/forgot_password/componenets/body.dart';


// ignore: use_key_in_widget_constructors
class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot_password";
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Body(),
    );
    
  }
}
