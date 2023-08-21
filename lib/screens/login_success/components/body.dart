import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutterp/screens/Souscategoris_list/Souscategoris_list_scren.dart';

import 'package:flutterp/constant.dart';
import 'package:flutterp/screens/cart_list/cart_list_screen.dart';
import 'package:flutterp/screens/favorie_list/favoorie_list_screen.dart';
import 'package:flutterp/screens/login_success/login_success_screen.dart';
import 'package:flutterp/size_config.dart';
import 'package:flutterp/screens/DescriptionImage/DescriptionImage_scren.dart';
import 'package:flutterp/screens/categorie_list/categorie_list_screen.dart';

import '../../accountProfile/acountprofile_screen.dart';
import '../../complete_profile/complete_profile_screen.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int _selectedIndex = 0;
  List<dynamic>? filteredProd;
  List<dynamic> categories = [];
  List<dynamic> produits = [];

  @override
  void initState() {
    super.initState();
    fetchCategoriesAndProduits();
  }

  Future<void> fetchCategoriesAndProduits() async {
    final categoriesResponse =
        await http.get(Uri.parse('http://192.168.1.101:8000/api/categories'));
    if (categoriesResponse.statusCode == 200) {
      final categoriesJsonData = json.decode(categoriesResponse.body);
      setState(() {
        categories = categoriesJsonData['hydra:member'];
        categories.forEach((category) {
          category['image'] = 'http://192.168.1.101:8000/${category['image']}';
        });
      });
    } else {
      // Handle error
      print('Failed to fetch categories');
    }

    final produitsResponse =
        await http.get(Uri.parse('http://192.168.1.101:8000/api/produits'));
    if (produitsResponse.statusCode == 200) {
      final produitsJsonData = json.decode(produitsResponse.body);
      setState(() {
        produits = produitsJsonData['hydra:member'];
        produits.forEach((product) {
          product['image'] = 'http://192.168.1.101:8000/${product['image']}';
        });
      });
    } else {
      // Handle error
      print('Failed to fetch produits');
    }
    filteredProd = produits;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToFavoritePage() {
    Navigator.pushNamed(context, FavorieList.routeName);
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

  void navigateToSousCategoriesList(BuildContext context, int categoryId) {
    Navigator.of(context).pushNamed(
      SousCategoriesList.routeName,
      arguments: {"categoryId": categoryId},
    );
  }

  void filterProducts(String query) {
    setState(() {
      filteredProd = produits.where((category) {
        String productsName = category['name'];
        return productsName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    filteredProd ??= [];
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenHeight(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth * 0.7,
                      height: 50,
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        onChanged: (text) {
                          filterProducts(text);
                        },
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Recherche ', //Search product
                          prefixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20),
                            vertical: getProportionateScreenHeight(15),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToFavoritePage,
                      child: IconButton(
                        onPressed: () {
                          // Navigate to the categories screen
                          Navigator.pushNamed(context, FavorieList.routeName);
                        },
                        icon: Icon(
                          Icons.favorite_outline,
                          color: kTextColor,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenHeight(20),
                ),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        navigateToSousCategoriesList(
                          context,
                          categories[index]['id'],
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: getProportionateScreenWidth(120),
                              height: getProportionateScreenHeight(110),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: kSecondaryColor.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  categories[index]['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                              categories[index]['name'],
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenHeight(20),
                ),
                child: Text(
                  'Produits',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                childAspectRatio: 0.693,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: List.generate(
                  filteredProd!.length,
                  (index) {
                    return InkWell(
                      onTap: () {
                        //debugPrint(produits[index]['id'].toString() + 'vvvv');
                        navigateToDescriptionImage(
                            context,
                            filteredProd![index]['id'].toString(),
                            filteredProd![index]['details'][0],
                            filteredProd![index]['name'],
                            filteredProd![index]['prix'],
                            filteredProd![index]['image']);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(
                                  getProportionateScreenWidth(20)),
                              height: 180,
                              width: 160,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: kSecondaryColor.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Hero(
                                tag: filteredProd![index]['id'],
                                child: Image.network(
                                  filteredProd![index]['image'],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Text(
                            filteredProd![index]['name'],
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(12),
                              color: kTextColor.withOpacity(0.7),
                            ),
                            maxLines: 2,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Text(
                            '${filteredProd![index]['prix']}DT',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(12),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.category),
                onPressed: () {
                  // Navigate to the categories screen
                  Navigator.pushNamed(context, CategoryListScreen.routeName);
                },
              ),
              label: 'Catégories',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigate to the categories screen
                  Navigator.pushNamed(context, CartList.routeName);
                },
              ),
              label: 'Mon panier',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  // Navigate to the categories screen
                  Navigator.pushNamed(context, Acountprofile.routeName);
                },
              ),
              label: 'Mon Compte',
            ),
          ],
        ),
      ),
    );
  }
}
