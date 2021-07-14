import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:panda1/models/Product.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key key,
    @required this.product,
    this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;
  final GestureTapCallback pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text(
            product.title,
            overflow: TextOverflow.fade,
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Container(
          //     margin: EdgeInsets.only(left: 15,right: 50,top: 60),
          padding: EdgeInsets.all(getProportionateScreenWidth(10)),
          child: Row(
            children: [
              RatingBar.builder(
                initialRating: product.rating,
                minRating: 1,
                itemSize: 25,
                glow: false,
                maxRating: 5,
                direction: Axis.horizontal,
                //glow: true,
                allowHalfRating: true,
                itemCount: 5,
                tapOnlyMode: true,
                ignoreGestures: true,
                itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 10,
                ),
                onRatingUpdate: (rating) {
                  rating = product.rating;

                  print(rating);
                },
              ),
              Text('(${product.rating.toStringAsFixed(1)})')
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(20),
          ),
          child: Text(
            product.description,
            overflow: TextOverflow.clip,
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }
}
