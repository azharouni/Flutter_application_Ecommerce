import 'package:flutter/material.dart';
import 'package:flutterp/components/default_button.dart';

import 'package:flutterp/screens/sign_in/components/sign_form.dart';
import 'package:flutterp/size_config.dart';

import '../../../components/no_account_text.dart';

class Body extends StatelessWidget {
  const Body({key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(20)),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: SizeConfig.screenHeight * 0.04,
              ),
              Text(
                "Bienvenue",
                style: TextStyle(
                  color: const Color.fromARGB(255, 19, 18, 18),
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              const Text(
                "Connectez-vous avec votre adresse e-mail \net votre mot de passe",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.1,
              ),
              SignForm(),
              SizedBox(
                height: SizeConfig.screenHeight * 0.01,
              ),
              const NoAccountText()
            ]),
          ),
        ),
      ),
    );
  }
}
