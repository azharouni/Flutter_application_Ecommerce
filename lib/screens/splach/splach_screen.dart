import 'package:flutter/material.dart';


import '../../size_config.dart';
import 'componenets/body.dart';

class SplachScreen extends StatelessWidget {
  static String routeName = "/splash";

  const SplachScreen({key});
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
