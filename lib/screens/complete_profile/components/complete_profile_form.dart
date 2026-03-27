import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterp/screens/sign_in/sign_in_screen.dart';
import 'package:http/http.dart' as http;
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../constant.dart';
import '../../../size_config.dart';
import '../../login_success/login_success_screen.dart';
import '../../sign_in/components/sign_form.dart';

class CompleteProfileScreen extends StatefulWidget {
  static int? userId;
  CompleteProfileScreen();

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileScreen> {
  String user = "";
  final _formKey = GlobalKey<FormState>();
  Future<void> _getCurrentUser(String address) async {
    final url = Uri.parse('http://192.168.1.101:8000/api/users/?page=1');
    final res = await http.get(url);
    final data = jsonDecode(res.body);
    List<dynamic> users = data['hydra:member'];
    for (Map<String, dynamic> u in users) {
      if (u['email'] == address) {
        CompleteProfileScreen.userId = u['id'];
        debugPrint(u['id'].toString() + 'nnnnnnkkkkkkkkkkkkkkkkkknn');
      }
    }
  }

  @override
  initState() {
    super.initState();
    getSharedPrefValue("currentUser").then((value) {
      setState(() {
        user = value;
      });
    });
    debugPrint(user);
  }

  late String nom;
  late String prenom;
  late String phone;
  late String address;
  late String ville;
  final List<String> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error!);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastpernomFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastvilleFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "continue",
            press: () async {
              debugPrint(user);
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                try {
                  final url =
                      Uri.parse('http://192.168.1.101:8000/api/users/${user}');
                  final response = await http.put(
                    url,
                    body: {
                      'fname': nom,
                      'lname': prenom,
                      'numTel': phone,
                      'adresse1': address,
                      'ville': ville,
                    },
                  );

                  if (response.statusCode == 200) {
                    // Data saved successfully
                    Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                  } else {
                    // Handle error response
                    print('Error: ${response.body}');
                  }
                } catch (e) {
                  // Handle exceptions
                  print('Exception: $e');
                }
              }
            },
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) {
        address = newValue!;
        SignForm.userAddress = address;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Address",
        hintText: "Enter votre addresse",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) {
        phone = newValue!;
        SignForm.userPhone = phone;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Telephone ",
        hintText: "Entrez votre numéro de téléphone",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildLastpernomFormField() {
    return TextFormField(
      onSaved: (newValue) => prenom = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kprenomNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kprenomNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Prénom ",
        hintText: "Entrez votre Prénom ",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildLastvilleFormField() {
    return TextFormField(
      onSaved: (newValue) {
        ville = newValue!;
        SignForm.userVille = ville;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kvilleNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kvilleNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Ville ",
        hintText: "Entrez votre ville",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => nom = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Nom ",
        hintText: "Entrez votre nom ",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
