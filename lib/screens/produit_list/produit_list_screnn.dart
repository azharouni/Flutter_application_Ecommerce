import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutterp/constant.dart';
import 'package:flutterp/screens/cart_list/cart_list_screen.dart';
import 'package:flutterp/screens/favorie_list/favoorie_list_screen.dart';
import 'package:flutterp/screens/login_success/login_success_screen.dart';
import 'package:flutterp/size_config.dart';
import 'package:flutterp/screens/produit_list/produit_list_screnn.dart';
import 'package:flutterp/screens/DescriptionImage/DescriptionImage_scren.dart';

import '../../main.dart';

class ProduitListScrenn extends StatefulWidget {
  static const String routeName = "/produit_list_screnn";

  @override
  _ProduitListScrennState createState() => _ProduitListScrennState();
}

class _ProduitListScrennState extends State<ProduitListScrenn> {
  List produits = [];
  List filteredProduits = [];
  TextEditingController searchController = TextEditingController();

  Future<List<dynamic>> getProduits(int subcategoryId) async {
    String url =
        "http://192.168.1.101:8000/api/sous_categories/${subcategoryId.toString()}";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    final produits = data['produits'];
    return produits;
  }

  Future<List<dynamic>> getAllProduits() async {
    String url = "http://192.168.1.101:8000/api/produits";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    List allProduits = data['hydra:member'];
    return allProduits;
  }

  bool itemExist(
      List<Map<String, dynamic>> list, Map<String, dynamic> product) {
    return list.contains(product);
  }

  Future<List<dynamic>> getFilteredProduits(int subcategoryId) async {
    final List<dynamic> allProduits = await getAllProduits();
    final List<dynamic> produits = await getProduits(subcategoryId);

    List<dynamic> filteredProduits = [];
    for (dynamic product in allProduits) {
      for (dynamic souscateg in produits) {
        if (souscateg.toString() == product['@id'].toString()) {
          filteredProduits.add(product);
        }
      }
    }
    return filteredProduits;
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterProduits();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterProduits() {
    String searchText = searchController.text.toLowerCase();
    setState(() {
      filteredProduits = produits.where((product) {
        return product['name'].toLowerCase().contains(searchText);
      }).toList();
    });
  }

  navigateToDescriptionImage(BuildContext context, String id, String details,
      String name, String price, String image) {
    Navigator.pushNamed(
      context,
      DescriptionImage.routeName,
      arguments: {
        "id": id,
        "details": details,
        "name": name,
        "price": price,
        "image": image,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int subcategoryId = args['subcategoryId'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Produits'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(produits),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: FutureBuilder<List<dynamic>>(
                future: getFilteredProduits(subcategoryId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    produits = snapshot.data!;

                    return Column(
                      children: produits.asMap().entries.map((entry) {
                        int index = entry.key;
                        dynamic product = entry.value;
                        product["total"] = double.parse(product['prix']);

                        return GestureDetector(
                          onTap: () {
                            navigateToDescriptionImage(
                                context,
                                product['id'].toString(),
                                product['details'][0],
                                product['name'],
                                product['prix'],
                                "http://192.168.1.101:8000${product['image']}");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.only(bottom: 20),
                            height: 120,
                            child: Row(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "http://192.168.1.101:8000${product['image']}"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product['name'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '${product['prix']}\DT',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(255, 96, 209, 100),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.favorite),
                                  onPressed: () {
                                    if (!itemExist(
                                        MyApp.testfavoris, product)) {
                                      product['image'] =
                                          "http://192.168.1.101:8000${product['image']}";
                                      product['quantity'] = 1;
                                      product['price'] = product['prix'];
                                      MyApp.testfavoris.add(product);
                                    }
                                  },
                                  iconSize: 35,
                                  color: Colors.red,
                                ),
                                IconButton(
                                  icon: Icon(Icons.add_shopping_cart),
                                  //icon: Icon(Icons.shopping_cart),

                                  onPressed: () {
                                    if (!itemExist(MyApp.test, product)) {
                                      product['image'] =
                                          "http://192.168.1.101:8000${product['image']}";
                                      product['quantity'] = 1;
                                      product['price'] = product['prix'];
                                      MyApp.test.add(product);
                                    }
                                  },
                                  iconSize: 35,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<String> {
  final List<dynamic> produits;

  ProductSearchDelegate(this.produits);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<dynamic> filteredList = produits.where((product) {
      return product['name'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        dynamic product = filteredList[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              /*navigateToProduitListScreen(
                              context,
                              filteredSubcategories[index]['id'],
                            );*/
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage(
                            "http://192.168.1.101:8000${filteredList[index]['image']}",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        filteredList[index]['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<dynamic> filteredList = produits.where((product) {
      return product['name'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        dynamic product = filteredList[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              /*navigateToProduitListScreen(
                              context,
                              filteredSubcategories[index]['id'],
                            );*/
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage(
                            "http://192.168.1.101:8000${filteredList[index]['image']}",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        filteredList[index]['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
