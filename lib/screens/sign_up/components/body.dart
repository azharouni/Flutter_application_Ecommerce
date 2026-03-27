import 'package:flutter/material.dart';

import 'package:flutterp/constant.dart';
import 'package:flutterp/screens/sign_up/components/signup_form.dart';
import 'package:flutterp/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03), // 4%
                Text("Enregistrer un compte", style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Text(
                  " Complétez vos coordonnées ",
                  textAlign: TextAlign.center,
                ),
                SignUpForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.04),

                SizedBox(height: getProportionateScreenHeight(20)),
                /* Text(    
                  'En continuant, vous confirmez que vous acceptez\nnos conditions générales dutilisation.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
