import 'dart:convert';
import 'package:flutterp/screens/histriiquecommande/body.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterp/constant.dart';
import 'package:flutterp/screens/edit_profil/edit_profilscreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../complete_profile/complete_profile_screen.dart';
import 'package:flutterp/screens/edit_profil/edit_profilscreen.dart';

class Acountprofile extends StatefulWidget {
  static String routeName = "/acount_profile";
  const Acountprofile({key});

  @override
  _AcountprofileState createState() => _AcountprofileState();
}

class _AcountprofileState extends State<Acountprofile> {
  String email = " ";
  String ville = " ";
  String adress = " ";
  String fname = " ";
  String lname = " ";
  String tel = "";

  String user = "";

  @override
  void initState() {
    super.initState();
    getSharedPrefValue("currentUser").then((value) {
      setState(() {
        user = value;
        print(user);
        fetchData(user);
      });
    });
    // Call the method to fetch data from API
  }

  Future<void> fetchData(String usern) async {
    try {
      // Make the API request
      final response = await http
          .get(Uri.parse('http://192.168.1.101:8000/api/users/$usern'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        try {
          final adressresponse = await http
              .get(Uri.parse('http://192.168.1.101:8000/api/adresses'));
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
              email = data["email"];
              fname = data["fname"];
              lname = data["lname"];
              tel = data["numTel"].toString();

              adress = userAddress['adresse1'];
              ville = userAddress['ville'];
            });
          } else {
            // Handle the case where no address is found for the user
            print('No address found for the user');
          }
        } catch (error) {
          // Handle any exceptions
          print('Error: $error');
        }

        // Update the state with the retrieved data
        // setState(() {
        //   email = data["email"];
        //   fname = data["fname"];
        //   lname = data["lname"];
        //   tel = data["numTel"];
        // });
      } else {
        // Handle the API error
        print('Failed to fetch data from API');
      }
    } catch (error) {
      // Handle any exceptions
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: Text(
          'Account',
        ),
        actions: <Widget>[],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.blue.shade600,
                  child: ListTile(
                    onTap: () {
                      //open edit profile
                    },
                    title: Text(
                      "Bienvenue $fname $lname",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListTile(
                    leading: const Icon(
                      Icons.history,
                      color: Colors.blue,
                    ),
                    title: const Text("Mes commande "), //Editer le  Profil
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      // Navigate to the categories screen
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => histriiquecommande()));
                    },
                  ),
                ),
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListTile(
                    leading: const Icon(
                      Icons.account_circle,
                      color: Colors.blue,
                    ),
                    title: const Text(
                        "Informations du Profil"), //Editer le  Profil
                    // trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      // Navigate to the categories screen
                      Navigator.pushNamed(context, EditProfile.routeName);
                    },
                  ),
                ),
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(
                          Icons.email,
                          color: Colors.blue,
                        ),
                        title: const Text("Email"),
                        subtitle: Text(email),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        title: const Text("Nom"),
                        subtitle: Text(fname),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        title: const Text("Prénom"),
                        subtitle: Text(lname),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.phone,
                          color: Colors.blue,
                        ),
                        title: const Text("Numéro de téléphone"),
                        subtitle: Text(tel),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.location_city,
                          color: Colors.blue,
                        ),
                        title: const Text("Ville"),
                        subtitle: Text(ville),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                        ),
                        title: const Text("Adresse"),
                        subtitle: Text(adress),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                const SizedBox(height: 60.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
