import 'package:flutter/material.dart';

import 'Product.dart';

class Cart {
  final Product product;
  int numOfItem;

  Cart({@required this.product, @required this.numOfItem});
}

// Demo data for our cart
double total = 0.00;
int count = 0;

double billTotal() {
  total = 0.00;
  demoCarts.forEach((element) {
    total = total + element.product.price * element.numOfItem;
  });
  return total;
}

List<Cart> demoCarts = [
  // Cart(product: demoProducts[0], numOfItem: 2),
  // Cart(product: demoProducts[1], numOfItem: 1),
  // Cart(product: demoProducts[3], numOfItem: 1),
];
