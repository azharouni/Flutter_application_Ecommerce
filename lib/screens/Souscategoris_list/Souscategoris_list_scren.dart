import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutterp/screens/produit_list/produit_list_screnn.dart';
import '../../constant.dart';

class SousCategoriesList extends StatefulWidget {
  static const String routeName = "/souscategories_list";

  @override
  _SousCategoriesListState createState() => _SousCategoriesListState();
}

class _SousCategoriesListState extends State<SousCategoriesList> {
  List subcategories = [];
  List filteredSubcategories = [];
  TextEditingController searchController = TextEditingController();
  int categoryId = 0;

  Future<List<dynamic>> getSubcategories(int categoryId) async {
    String url =
        "http://192.168.1.101:8000/api/categories/${categoryId.toString()}";
    var response = await http.get(Uri.parse(url));
    print(url);
    print(response.body);
    var data = jsonDecode(response.body);
    final sousCategories = data['sousCategorie'];
    return sousCategories;
  }

  Future<List<dynamic>> getAllSubcategories() async {
    String url = "http://192.168.1.101:8000/api/sous_categories";
    var response = await http.get(Uri.parse(url));
    print(url);
    print(response.body);
    var data = jsonDecode(response.body);
    List allSubcategories = data['hydra:member'];
    return allSubcategories;
  }

  Future<List<dynamic>> getFilteredSubcategories(int categoryId) async {
    final List<dynamic> allSubcategories = await getAllSubcategories();
    final List<dynamic> subcategories = await getSubcategories(categoryId);

    List<dynamic> filteredSubcategories = allSubcategories.where((subcategory) {
      return subcategories.any((category) {
        return category.toString() == subcategory['@id'].toString();
      });
    }).toList();
    return filteredSubcategories;
  }

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      filterSubcategories();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterSubcategories() {
    String searchText = searchController.text.toLowerCase();
    setState(() {
      // Filtrer les sous-catégories en fonction du texte de recherche
      filteredSubcategories = subcategories.where((subcategory) {
        return subcategory['name'].toLowerCase().contains(searchText);
      }).toList();
    });
  }

  void navigateToProduitListScreen(BuildContext context, int subcategoryId) {
    Navigator.of(context).pushNamed(
      ProduitListScrenn.routeName,
      arguments: {"subcategoryId": subcategoryId},
    );
  }

  @override
  Widget build(BuildContext context) {
    

    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    categoryId = args['categoryId'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Sous-catégories'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: getFilteredSubcategories(categoryId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  subcategories = snapshot.data!;
                  if (filteredSubcategories.isEmpty&&searchController.text=='') {
      filteredSubcategories = subcategories;
    }
                  return ListView.builder(
                    itemCount: filteredSubcategories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            navigateToProduitListScreen(
                              context,
                              filteredSubcategories[index]['id'],
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
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
                                          "http://192.168.1.101:8000${filteredSubcategories[index]['image']}",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      filteredSubcategories[index]['name'],
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
    );
  }
}
