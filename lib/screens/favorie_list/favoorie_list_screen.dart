import 'package:flutter/material.dart';
import '../../main.dart';
import 'components/Res.dart';
import 'components/network.dart';

class FavorieList extends StatefulWidget {
  static String routeName = "/favorie_list";

  const FavorieList({Key? key}) : super(key: key);

  @override
  State<FavorieList> createState() => _FavorieListState();
}

class _FavorieListState extends State<FavorieList> {
  bool itemExist(
      List<Map<String, dynamic>> list, Map<String, dynamic> product) {
    return list.contains(product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('favoris'),
      ),
      body: ListView.builder(
        itemCount: MyApp.testfavoris.length,
        itemBuilder: (context, int index) {
          final postfavoris = MyApp.testfavoris[index];
          postfavoris["total"] =
              double.parse(postfavoris['price']) * postfavoris['quantity'];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: Image.network(
                postfavoris['image'],
                height: 120,
                fit: BoxFit.cover,
              ),
              title: Text(
                postfavoris['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                'Prix: ${postfavoris['price']}DT',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      if (!itemExist(MyApp.test, postfavoris)) {
                        MyApp.test.add(postfavoris);
                      }
                    },
                    color: Colors.blue,
                    icon: const Icon(Icons.shopping_cart),
                    iconSize: 40,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        MyApp.testfavoris.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Produit supprimé des favoris'),
                        ),
                      );
                    },
                    color: Colors.red,
                    icon: const Icon(Icons.delete),
                    iconSize: 40,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
