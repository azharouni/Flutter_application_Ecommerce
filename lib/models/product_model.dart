class ProductModel {
  final String productName;
  final double productPrice;
  final int productQuantity;

  ProductModel(
      {required this.productName,
      required this.productPrice,
      required this.productQuantity});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      productName: json['productName'],
      productPrice: json['productPrice'],
      productQuantity: json['productQuantity']);

  Map<String, dynamic> toJson() => {
      'productName':productName,
      'productPrice':productPrice,
      'productQuantity':productQuantity  
  };
}
