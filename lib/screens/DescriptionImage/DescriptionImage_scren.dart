import 'dart:convert';
import 'package:flutterp/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../../constant.dart';
import '../sign_in/components/sign_form.dart';

class DescriptionImage extends StatefulWidget {
  static String routeName = "/DescriptionImage";

  @override
  _DescriptionImageState createState() => _DescriptionImageState();
}

class _DescriptionImageState extends State<DescriptionImage> {
  int quantity = 1; // Variable pour stocker la quantité

  Future<Map<String, dynamic>> getProductDetails(String details) async {
    String detailsUrl = "http://192.168.1.101:8000$details";
    debugPrint(detailsUrl);

    var detailsResponse = await http.get(Uri.parse(detailsUrl));
    var detailsData = jsonDecode(detailsResponse.body);
    var matchingDetails = detailsData as Map<String, dynamic>;
    debugPrint(matchingDetails.toString());

    return {'productDetails': matchingDetails};
  }

  bool itemExist(
      List<Map<String, dynamic>> list, Map<String, dynamic> product) {
    return list.contains(product);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String detailsLink = arguments!['details'];
    final String name = arguments["name"];
    final String image = arguments["image"];
    final String price = arguments["price"];
    final String id = arguments["id"];

    final Map<String, dynamic> post = {
      "name": name,
      "price": price,
      "image": image,
      "quantity": quantity,
      "total": double.parse(price) * quantity
    };

    final Map<String, dynamic> postfavories = {
      "name": name,
      "price": price,
      "image": image,
      "quantity": quantity,
    };
    debugPrint(post.toString() + "bbbb");

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 400,
            // width: 450,
            //height: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image ?? "No image"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: <Widget>[],
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: getProductDetails(detailsLink),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Container());
              } else if (snapshot.hasError) {
                return Center(child: Text('Failed to fetch product details.'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('Product details not found.'));
              } else {
                var productDetails = snapshot.data?['productDetails'];
                print('prod details ${productDetails}');
                if (productDetails['size'][0] == '') {
                  productDetails['size'][0] = 'undefined';
                }

                print('prod details ${productDetails}');

                return Positioned(
                  top: 380,
                  left: 0,
                  right: 0,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(30.0),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60.0),
                          topRight: Radius.circular(60.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name ?? "No Name",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 164, 11, 11),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            ' ${productDetails['description']}',
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: <Widget>[
                              const Spacer(),
                              Text(
                                '$price\DT',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 77, 3, 3),
                                    fontSize: 35.0),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          /* Row(
                            children: <Widget>[
                              const Spacer(),
                              Text(
                                'Stock: ${productDetails['stock']}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),*/

                          productDetails['size'][0] != 'undefined'
                              // (productDetails['size'] as List).isNotEmpty
                              ? Row(
                                  children: <Widget>[
                                    Text(
                                      'taille: ${productDetails['size']}',
                                      style: TextStyle(
                                          color: Colors.grey.shade700),
                                    ),
                                    const Spacer(),
                                  ],
                                )
                              : Container(),
                          const SizedBox(height: 40.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              QuantityButton(
                                icon: Icons.remove,
                                onPressed: () {
                                  setState(() {
                                    if (quantity > 0) {
                                      quantity--;
                                    }
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                              //const SizedBox(width: 10),
                              QuantityButton(
                                icon: Icons.add,
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 30.0),
                          Container(
                            child: SizedBox(
                              width: double.infinity,
                              height: 50.0,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  backgroundColor: Colors.blue.shade600,
                                  foregroundColor: Colors.white,
                                ),
                                icon: Icon(Icons.shopping_cart),
                                label: Text("Ajouter au panier"),
                                onPressed: () async {
                                  if (!itemExist(MyApp.test, post)) {
                                    MyApp.test.add(post);
                                    // Logique d'ajout au panier
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setStringList(
                                      SignForm.userId.toString(),
                                      MyApp.test
                                          .map((e) => e['id'].toString())
                                          .toList(),
                                    );
                                    // Autres actions à effectuer après l'ajout au panier
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 90.0),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          Positioned(
            top: 345,
            right: 40,
            child: CircleAvatar(
              radius: 40.0,
              foregroundColor: Colors.grey,
              backgroundColor: Colors.grey.shade200,
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.red,
                ),
                onPressed: () {
                  if (!itemExist(MyApp.testfavoris, postfavories))
                    MyApp.testfavoris.add(postfavories);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: const EdgeInsets.all(12),
        primary: Colors.grey[300],
      ),
      child: Icon(icon),
      onPressed: onPressed,
    );
  }
}
