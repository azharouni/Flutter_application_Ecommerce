import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterp/screens/login_success/login_success_screen.dart';
import '../../models/command_model.dart';
import 'app_color.dart';

class detailcommande extends StatelessWidget {
  final CommandModel command;

  static String routeName = "/detailcommande";

  const detailcommande({Key? key, required this.command}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('prod ${command.products}');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("commande détails"), //Détails de la commande
      ),
      body: _buildBody(context),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 184,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginSuccessScreen()));
                },
                child: Text(
                  'Continuer à acheter',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: 'poppins',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: Color.fromARGB(0, 174, 170, 170),
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 800,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 162, 159, 159),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CommandID: ${command.commandID}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adresse: ${command.address}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'télephone:  ${command.phone}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '\t\t\tproduits',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: command.products
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                  '${e.productName}, ${e.productPrice}DT x ${e.productQuantity}'),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Prix total: ${command.totalPrice}\Dt',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Paiement  à la livraison ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
