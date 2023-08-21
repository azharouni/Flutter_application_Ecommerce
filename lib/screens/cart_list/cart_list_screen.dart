import 'package:flutter/material.dart';
import 'package:flutterp/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../sign_in/components/sign_form.dart';
import 'components/Res.dart';
import 'components/network.dart';
import 'package:flutterp/screens/ConfirmOrderPage/body.dart';

class CartList extends StatefulWidget {
  static String routeName = "/cart_list";

  const CartList({Key? key}) : super(key: key);

  @override
  State<CartList> createState() => _CartListState();
}

double totalPrice(List<Map<String, dynamic>> list) {
  double sum = 0;
  for (Map<String, dynamic> prod in list) {
    sum += double.parse(prod['total'].toString());
  }
  return sum;
}

class _CartListState extends State<CartList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('panier'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemCount: MyApp.test.length,
              itemBuilder: (context, int index) {
                return Stack(
                  children: [
                    CartItem(data: MyApp.test[index], index: index),
                    Positioned(
                      right: 5,
                      top: 0,
                      child: SizedBox(
                        width: 50,
                        child: IconButton(
                          onPressed: () async {
                            MyApp.test.removeAt(index);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setStringList(
                              SignForm.userId.toString(),
                              MyApp.test
                                  .map((e) => e['id'].toString())
                                  .toList(),
                            );
                            setState(() {});
                          },
                          color: Colors.red,
                          icon: const Icon(Icons.delete),
                          iconSize: 40,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              if (MyApp.test[index]['quantity'] > 1) {
                                setState(() {
                                  MyApp.test[index]['quantity']--;
                                  MyApp.test[index]['total'] =
                                      MyApp.test[index]['quantity'] *
                                          double.parse(
                                            MyApp.test[index]['price'],
                                          );
                                });
                              }
                            },
                            splashColor: Colors.redAccent.shade200,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              alignment: Alignment.center,
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                MyApp.test[index]['quantity'].toString(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                MyApp.test[index]['quantity']++;
                                MyApp.test[index]['total'] =
                                    MyApp.test[index]['quantity'] *
                                        double.parse(
                                          MyApp.test[index]['price'],
                                        );
                              });
                            },
                            splashColor: Colors.lightBlue,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              alignment: Alignment.center,
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          _checkoutSection(context),
        ],
      ),
    );
  }
}

Widget _checkoutSection(BuildContext context) {
  return Material(
    color: Colors.black12,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Row(
            children: <Widget>[
              Text(
                "Prix Total:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              Spacer(),
              Text(
                totalPrice(MyApp.test).toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            color: Color.fromARGB(255, 13, 160, 239),
            elevation: 1.0,
            child: InkWell(
              splashColor: Color.fromARGB(255, 69, 99, 139),
              onTap: () async {
                if(MyApp.test.isNotEmpty){
 List<ProductModel> produits =
                    MyApp.test.map((e) => ProductModel(productName: e['name'], productPrice: double.parse(e['price']), productQuantity: e['quantity'])).toList();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                    
                        ConfirmOrderPage(totalPrice: totalPrice(MyApp.test),products: produits,)));
                }
               
              },
              child: const SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Passer Commande",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class CartItem extends StatefulWidget {
  const CartItem({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);
  final Map<String, dynamic> data;
  final int index;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(3),
      height: 180,
      child: Row(
        children: <Widget>[
          Container(
            width: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.data['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          widget.data['name'],
                          overflow: TextOverflow.fade,
                          softWrap: true,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 30,
                    ),
                    child: Row(
                      children: <Widget>[
                        const Text("Prix: "),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.data['price'].toString() + 'DT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text("Sous-total: "),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${widget.data['total']}DT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      color: Color.fromARGB(255, 223, 226, 223),
    );
  }
}
