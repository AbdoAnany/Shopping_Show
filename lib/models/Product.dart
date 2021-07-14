import 'package:flutter/material.dart';

class Product {
  int id, isFavourite, isPopular, colors;
  String title, description, image, date, type, category, barcode;
  double price, priceBefore, rating;

  Product({
    @required this.id,
    @required this.image,
    this.colors,
    this.barcode,
    this.date,
    this.priceBefore,
    this.type,
    this.category,
    this.rating,
    this.isFavourite = 0,
    this.isPopular = 0,
    @required this.title,
    @required this.price,
    this.description,
  });

  Product.a(dynamic obj) {
    id = obj['id'];
    title = obj['name'];
    priceBefore = obj['priceBefore'];
    price = obj['price'];
    date = obj['date'].toString();
    barcode = obj['barcode'];
    description = obj['description'];
    image == [] ? image = obj['image'][0] : image = '';
    type = obj['type'].toString();
    (category == []) ? category = obj['category'][0] : category = '';
    rating = obj['rating'];
    isPopular = obj['isPopular'];
  }

  Product.fromMap(Map<String, dynamic> obj) {
    id = obj['id'];
    title = obj['title'];
    priceBefore = obj['priceBefore'].toDouble();
    price = obj['price'].toDouble();
    date = obj['date'];
    barcode = obj['barcode'];
    description = obj['description'];
    image = obj['image'];
    type = obj['type'];
    category = obj['category'];
    rating = obj['rating'].toDouble();
    isPopular = obj['isPopular'];
  }

  Map<String, dynamic> toMaps() => {
        if (id != null) 'id': id,
        'title': title,
        'price': price,
        'priceBefore': priceBefore,
        'date': date,
        'barcode': barcode,
        'description': description,
        'image': image,
        'type': type,
        'category': category,
        'rating': rating,
        'isPopular': isPopular,
      };
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    id: 1,
    image: "assets/images/ps4_console_white_1.png",
    colors: 0xFFFFFFFF,
    barcode: '278654765',
    category: 'Close',
    date: '',
    type: 'Limited',
    title: "Wireless Controller for PS4™",
    price: 64.99,
    priceBefore: 70.00,
    description: description,
    rating: 4.8,
    // isFavourite: 1,
    isPopular: 1,
  ),
  Product(
    id: 4,
    title: "Logitech Head",
    price: 20.20,
    isPopular: 1,
    priceBefore: 25.00,
    isFavourite: 1,
    rating: 4.1,
    image: "assets/images/wireless headset.png",
    barcode: '765555',
    category: 'Close',
    date: '',
    type: 'Limited',
    colors: 0xFFFFFFFF,
    description: description,
  ),
  Product(
    id: 2,
    image: "assets/images/Image Popular Product 2.png",
    colors: 0xFFFFFFFF,
    barcode: '24455454',
    category: 'Close',
    date: '',
    type: 'Limited',
    isFavourite: 0,
    title: "Nike Sport White - Man Pant",
    price: 50.5,
    description: description,
    rating: 3.5,
    isPopular: 1,
  ),
  Product(
    id: 3,
    image: "assets/images/glap.png",
    colors: 0xFFFFFFFF,
    title: "Gloves XC Omega - Polygon",
    price: 36.55,
    barcode: '557555',
    category: 'Close',
    date: '',
    priceBefore: 40.00,
    type: 'Limited',
    description: description,
    rating: 3.8,
    isFavourite: 1,
    isPopular: 1,
  ),
];

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
