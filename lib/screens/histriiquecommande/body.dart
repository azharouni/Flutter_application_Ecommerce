import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterp/main.dart';
import 'package:flutterp/models/command_model.dart';
import 'package:flutterp/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sign_in/components/sign_form.dart';

class histriiquecommande extends StatefulWidget {
  static String routeName = "/historique";

  @override
  State<histriiquecommande> createState() => _histriiquecommandeState();
}

class _histriiquecommandeState extends State<histriiquecommande> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Historique des commandes'),
        ),
        body: FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                List<String> data =
                    snapshot.data!.getStringList('CommandsHistory${SignForm.userId}') ?? [];
                print('data list $data');
                List<dynamic> list = data
                    .map((e) => CommandModel.fromJson(jsonDecode(e)))
                    .toList();

                print('object list $list');
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) => ExpansionTile(
                          expandedAlignment: Alignment.topLeft,
                          title: Text('Command ID: ${list[i].commandID}'),
                          subtitle: Text(
                              'Prix total: ${list[i].totalPrice.toString()}DT'),
                          trailing: Column(
                            children: [
                              Text(list[i].date),
                              Text(list[i].status)
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('produits'),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          (list[i].products as List).map((e) {
                                        ProductModel p =
                                            ProductModel.fromJson(e);
                                        return Text(
                                            '${p.productName}, ${p.productPrice}DT   x ${p.productQuantity}');
                                      }).toList(),
                                    ),
                                  ),
                                  Text('Livré a : ${list[i].address}'),
                                  Text('contacter par: ${list[i].phone}'),
                                 const SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            )
                          ],
                        ));
              } else {
                return Text('Il y a un problème !!');
              }
            }));
  }
}
