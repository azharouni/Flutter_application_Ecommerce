import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutterp/models/command_model.dart';
import 'package:flutterp/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SuccessCommand/body.dart';
import '../sign_in/components/sign_form.dart';

class ConfirmOrderPage extends StatefulWidget {
  static String routeName = "/ConfirmOrderPage";
  double totalPrice;
  List<ProductModel> products;

  ConfirmOrderPage({Key? key, required this.totalPrice, required this.products})
      : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  final String address = "Chabahil, Kathmandu";
  final String phone = "9818522122";
  double total = 0.0;
  final double delivery = 8;
  bool isNewPhoneSelected = false;
  bool isNewAddressSelected = false;
  String newPhone = "";
  String newAddress = "";
  @override
  void initState() {
    total = widget.totalPrice;
    super.initState();
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirmer  commande"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 40.0, bottom: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text("Sous-total"),
              Text("$total\DT"),

              /* Text(
               totalPrice(MyApp.test).toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),*/
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text("Frais de livraison"),
              Text(" $delivery\DT "),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Total",
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                "${total + delivery}\DT ",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            child: Text("Adresse de livraison".toUpperCase()),
          ),
          Column(
            children: <Widget>[
              RadioListTile(
                selected: !isNewAddressSelected,
                value: address,
                groupValue: !isNewAddressSelected ? address : null,
                title: Text('${SignForm.userVille}, ${SignForm.userAddress}'),
                onChanged: (value) {
                  setState(() {
                    isNewAddressSelected = !isNewAddressSelected;
                  });
                },
              ),
              RadioListTile(
                selected: isNewAddressSelected,
                value: "Nouvelle adresse",
                groupValue: isNewAddressSelected ? "Nouvelle adresse" : null,
                title: const Text("Choisir une nouvelle adresse de livraison"),
                onChanged: (value) {
                  setState(() {
                    isNewAddressSelected = !isNewAddressSelected;
                  });
                },
              ),
              if (isNewAddressSelected)
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      newAddress = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Saisir une nouvelle adresse de livraison',
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            child: Text("Numéro de contact".toUpperCase()),
          ),
          RadioListTile(
            selected: !isNewPhoneSelected,
            value: phone,
            groupValue: !isNewPhoneSelected ? phone : null,
            title: Text(SignForm.userPhone),
            onChanged: (value) {
              setState(() {
                isNewPhoneSelected = false;
              });
            },
          ),
          RadioListTile(
            selected: isNewPhoneSelected,
            value: "Nouveau numéro de téléphone",
            groupValue:
                isNewPhoneSelected ? "Nouveau numéro de téléphone" : null,
            title: const Text("Choisir un nouveau numéro de contact"),
            onChanged: (value) {
              setState(() {
                isNewPhoneSelected = true;
              });
            },
          ),
          if (isNewPhoneSelected)
            TextFormField(
              onChanged: (value) {
                setState(() {
                  newPhone = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Saisir le nouveau numéro de contact',
              ),
            ),
          const SizedBox(
            height: 20.0,
          ),
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            child: Text("Option de paiement".toUpperCase()),
          ),
          RadioListTile(
            groupValue: true,
            value: true,
            title: const Text("paiement à la livraison"),
            onChanged: (value) {},
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () async {
                final DateTime now = DateTime.now();
                final DateFormat formatter = DateFormat('yyyy-MM-dd');
                final String formatted = formatter.format(now);
                CommandModel commandModel = CommandModel(
                    commandID: generateRandomString(8).toUpperCase(),
                    date: formatted,
                    status: "en cours ",
                    products: widget.products,
                    totalPrice: widget.totalPrice + delivery,
                    address: isNewAddressSelected
                        ? newAddress
                        : '${SignForm.userVille}, ${SignForm.userAddress}',
                    phone: isNewPhoneSelected ? newPhone : SignForm.userPhone);
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                List<String> history = await prefs
                        .getStringList("CommandsHistory${SignForm.userId}") ??
                    []; // tatsajel commande lina selon iduser

                history.add(jsonEncode(commandModel.toJson()));
                await prefs.setStringList(
                    "CommandsHistory${SignForm.userId}", history);

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => SuccessCommand(command: commandModel)));
              },
              child: const Text(
                "Confirmer la commande",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
