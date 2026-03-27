import 'package:flutterp/models/product_model.dart';

class CommandModel {
  final String commandID;
  final String date;
  final String status;
  final List<dynamic> products;
  final double totalPrice;
  final String address;
  final String phone;

  CommandModel(
      {required this.commandID,
      required this.date,
      required this.status,
      required this.products,
      required this.totalPrice,
      required this.address,
      required this.phone});

  factory CommandModel.fromJson(Map<String, dynamic> json) => CommandModel(
      commandID: json['commandID'],
      date: json['date'],
      status: json['status'],
      products: json['products'],
      totalPrice: json['totalPrice'],
      address: json['address'],
      phone: json['phone']);

  Map<String, dynamic> toJson() => {
    'commandID':commandID,
    'date':date,
    'status':status,
    'products':products,
    'totalPrice':totalPrice,
    'address':address,
    'phone':phone

  };
}
