import 'package:flutter/material.dart';
import 'package:flutterp/screens/sign_up/sign_up_screen.dart';

import '../constant.dart';
import '../screens/forgot_password/forgot_password_screen.dart';
import '../size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.05),
        Text(
          //  style: TextStyle(fontSize: getProportionateScreenWidth(16)),
          "PAS ENCORE CLIENT?",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(16),
          ),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: Text(
            "Créer un compte",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
              color: kPrimaryColor,
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }
}
