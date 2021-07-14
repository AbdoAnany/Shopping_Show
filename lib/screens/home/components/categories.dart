import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../size_config.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": "assets/icons/Flash Icon.svg", "text": "خضراوات"},
      {"icon": "assets/icons/Bill Icon.svg", "text": "ملابس"},
      {"icon": "assets/icons/Game Icon.svg", "text": "منتجات"},
      {"icon": "assets/icons/Gift Icon.svg", "text": "مخبوزات"},
      {"icon": "assets/icons/Discover.svg", "text": "لحوم"},
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            press: () {},
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.all(5),
        child: Column(
          children: [
            FilterChip(
                label: Text(text.toUpperCase()),
                selected: true,
                onSelected: (value) {}),
          ],
        ),
      ),
    );
  }
}
