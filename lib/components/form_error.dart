import 'package:flutter/material.dart';

import '../size_config.dart';
class FormError extends StatelessWidget {
  const FormError({
    key,
    required this.errors,
  });

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:List.generate
      (errors.length,
       (index) => formErrorText(error: errors[index])),
    );
  }

  Row formErrorText({required String error}) {
    return Row(
       children: [
         const Icon(Icons.error,color: Colors.red,size: 20),
         SizedBox(width: getProportionateScreenWidth(14)),
         Text(error),
       ],
      );
  }
}

