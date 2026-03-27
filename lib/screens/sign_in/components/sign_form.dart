import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutterp/screens/login_success/login_success_screen.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../constant.dart';
import '../../../size_config.dart';
import '../../forgot_password/forgot_password_screen.dart';

class SignForm extends StatefulWidget {
  static int? userId;
  static String userAddress = "address";
  static String userPhone = "Phone number";
  static String userVille = "ville";
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  bool remember = false;
  final List<String> errors = [];

  Future<void> _getUserAddress(int usern) async {
    try {
      final adressresponse =
          await http.get(Uri.parse('http://192.168.1.101:8000/api/adresses'));
      final adressData = json.decode(adressresponse.body);
      var filteredAddresses = [];
      // Replace 'userId' with the actual user ID you want to filter
      final userId = '/api/users/$usern';

      List<dynamic> adresses = adressData['hydra:member'];
      for (Map<String, dynamic> u in adresses) {
        if (u['users'] == userId) {
          filteredAddresses.add(u);
        }
      }
      // Retrieve the first matching address, or null if not found
      final userAddress =
          filteredAddresses.isNotEmpty ? filteredAddresses[0] : null;

      if (userAddress != null) {
        // Update the state with the retrieved address
        setState(() {
          SignForm.userAddress = userAddress['adresse1'];
          SignForm.userVille = userAddress['ville'];
        });
      } else {
        // Handle the case where no address is found for the user
        print('No address found for the user');
      }
    } catch (error) {
      // Handle any exceptions
      print('Error: $error');
    }
  }

  Future<void> _getCurrentUser(String address) async {
    final url = Uri.parse('http://192.168.1.101:8000/api/users/?page=1');
    final res = await http.get(url);
    final data = jsonDecode(res.body);
    List<dynamic> users = data['hydra:member'];
    for (Map<String, dynamic> u in users) {
      if (u['email'] == address) {
        SignForm.userId = u['id'];
        await _getUserAddress(u['id']);

        SignForm.userPhone = u['numTel'].toString();
        setVariable("currentUser", u['id'].toString());

        debugPrint(u['id'].toString() + 'rr');
      }
    }
  }

  Future<void> _login() async {
    final url = Uri.parse('http://192.168.1.101:8000/api/login');
    final body = jsonEncode({'username': email, 'password': password});
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Login successful

      await _getCurrentUser(email);

      //print('current user id: ${SignForm.userId}');
      Navigator.pushNamed(context, LoginSuccessScreen.routeName);
    } else {
      // Login failed
      setState(() {
        errors.add('La connexion a échoué. Veuillez réessayer.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          /* Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value!;
                  });
                },
              ),
              const Text(" Souvenez-vous de moi"),
              const Spacer(),
            ],
          ),*/
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(60)),
          DefaultButton(
            text: "continue",
            color: Colors.blue,
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _login();
              }
            },
          )
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kPassNullError)) {
          setState(() {
            errors.remove(kPassNullError);
          });
      //  } else if (value.length >= 8 && errors.contains(kShortPassError)) {
          setState(() {
         //   errors.remove(kShortPassError);
          });
        }
      },
      validator: (value) {
        if (value!.isEmpty && !errors.contains(kPassNullError)) {
          setState(() {
            errors.add(kPassNullError);
          });
          return "";
       // } else if (value.length < 8 && !errors.contains(kShortPassError)) {
          setState(() {
           // errors.add(kShortPassError);
          });
          return "";
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Entrez votre mot de passe",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.lock),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kEmailNullError)) {
          setState(() {
            errors.remove(kEmailNullError);
          });
        } else if (emailValidatorRegExp.hasMatch(value) &&
            errors.contains(kInvalidEmailError)) {
          setState(() {
            errors.remove(kInvalidEmailError);
          });
        }
      },
      validator: (value) {
        if (value!.isEmpty && !errors.contains(kEmailNullError)) {
          setState(() {
            errors.add(kEmailNullError);
          });
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value) &&
            !errors.contains(kInvalidEmailError)) {
          setState(() {
            errors.add(kInvalidEmailError);
          });
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Entrez votreEmail",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.email),
      ),
    );
  }
}
