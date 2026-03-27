import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterp/constant.dart';
import 'package:http/http.dart' as http;
import '../Souscategoris_list/Souscategoris_list_scren.dart';

class CategoryListScreen extends StatefulWidget {
  static const String routeName = "/category_list";

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  List categories = [];
  List? filteredCategories = null;
  TextEditingController searchController = TextEditingController();

  Future<List<dynamic>> getCategories() async {
    String url = "http://192.168.1.101:8000/api/categories";
    print(url);
    var response = await http.get(Uri.parse(url));

    print(response.body);
    var data = jsonDecode(response.body);
    var categories = data['hydra:member'];

    categories.forEach((category) {
      category['image'] = 'http://192.168.1.101:8000${category['image']}';
    });

    return categories;
  }

  @override
  void initState() {
    super.initState();
  }

  void filterCategories(String query) {
    setState(() {
      filteredCategories = categories.where((category) {
        String categoryName = category['name'];
        return categoryName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void navigateToSousCategoriesList(BuildContext context, int categoryId) {
    Navigator.of(context).pushNamed(
      SousCategoriesList.routeName,
      arguments: {"categoryId": categoryId},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                
                controller: searchController,
                style: TextStyle(fontSize: 16.0),
                decoration: InputDecoration(
                  hintText: "Rechercher une catégorie",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (value) {
                  filterCategories(value);
                },
              ),
            ),
            FutureBuilder<List<dynamic>>(
              future: getCategories(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  categories = snapshot.data!;
                  filteredCategories??=categories;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(10),
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                    children: List.generate(filteredCategories!.length, (index) {
                      return InkWell(
                        onTap: () {
                          navigateToSousCategoriesList(
                            context,
                            filteredCategories![index]['id'],
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: Image.network(
                                    filteredCategories![index]['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  filteredCategories![index]['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SubcategoryListScreen extends StatelessWidget {
  final List<dynamic> subcategories;

  const SubcategoryListScreen({Key? key, required this.subcategories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sous-catégories'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subcategories[index]['name']),
          );
        },
      ),
    );
  }
}
