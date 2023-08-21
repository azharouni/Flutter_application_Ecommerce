import 'package:flutter/material.dart';
import 'package:flutterp/components/default_button.dart';
import 'package:flutterp/components/form_error.dart';
import 'package:flutterp/components/no_account_text.dart';
import 'package:flutterp/size_config.dart';

import '../../../constant.dart';

class Body extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight *0.04),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "please enter your email and we will send \nyou a link to return your account",
                textAlign: TextAlign.center,
            
              ),
              SizedBox(height: SizeConfig.screenHeight *0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}
class ForgotPassForm extends StatefulWidget{
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();

}
class _ForgotPassFormState extends State<ForgotPassForm>{
  final _formkey = GlobalKey<FormState>();
  List<String> errors = [];
  late String email;
  @override
  Widget build(BuildContext context){
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
        keyboardType: TextInputType.emailAddress,
        onSaved: (newValue) =>email = newValue!,
        onChanged: (value){
           if (value.isNotEmpty && errors.contains(kEmailNullError)){
          setState(() { 
            errors.remove(kEmailNullError);
          });
        }
        else if (emailValidatorRegExp.hasMatch(value)&& 
        errors.contains(kInvalidEmailError)){
          setState(() {
            errors.remove(kInvalidEmailError);
          });
        }
        return null;
        },
        validator: (value) {
        if (value!.isEmpty && !errors.contains(kEmailNullError)){
          setState(() {
            errors.add(kEmailNullError);
          });
        }
        else if (!emailValidatorRegExp.hasMatch(value)&& 
        !errors.contains(kInvalidEmailError)){
          setState(() {
            errors.add(kInvalidEmailError);
          });
        }
        return null;
        },
        decoration: const InputDecoration(
          labelText: "Email",
          hintText: "Enter your Email",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.email),
           ),
      ),
      SizedBox(
        height: getProportionateScreenHeight(30),
      ),
      FormError(errors: errors),
      SizedBox(height: SizeConfig.screenHeight *0.1),
      DefaultButton(
        text: "continue",
        color: Colors.blue,
         press: (){
          if (_formkey.currentState!.validate()){
            
          }
         }
         ),
         SizedBox(height: SizeConfig.screenHeight *0.1),
         const NoAccountText(),
        ],
      ),
      );

  }
}