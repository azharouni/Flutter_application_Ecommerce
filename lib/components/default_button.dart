import 'package:flutter/material.dart';

import '../constant.dart';
import '../size_config.dart';
class DefaultButton extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const DefaultButton({key, 
     required this.text, 
    required this.press, required MaterialColor color,
  });
  final String text;
   final void Function() press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
     width: double.infinity,
     height: getProportionateScreenHeight(56 ),
      child: ElevatedButton(
          onPressed: press,
           style: ElevatedButton.styleFrom(
           primary: kPrimaryColor,
           shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),)
           ),
                child: Text(
                   text,
                   style: TextStyle(
                   fontSize: getProportionateScreenWidth(18),
        ),
      ),
    ),
    );
  }
}

