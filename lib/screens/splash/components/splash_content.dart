import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.text,
    this.image,
  }) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return ListView(

      children: <Widget>[
        SizedBox(height: getProportionateScreenHeight(30),),
        Text(
          'مرحبا بكم في عروض التسوق \n نقدم لكم افضل العروض والامنتجات \n ',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: getProportionateScreenHeight(25),

              fontWeight: FontWeight.bold),
        ),
        Image.asset(
          image,
          fit: BoxFit.contain,
          height: getProportionateScreenHeight(400),
        ),
      ],
    );
  }
}
