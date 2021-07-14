import 'package:flutter/material.dart';
import 'package:panda1/models/Cart.dart';
import 'package:panda1/screens/details/details_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, DetailsScreen.routeName,
            arguments: ProductDetailsArguments(product: cart.product));
      },
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                //    padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(
                  cart.product.image,
                  fit: BoxFit.fill,
                  frameBuilder: (BuildContext context, Widget child, int frame,
                      bool wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) return child;
                    return AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: Duration(seconds: 5),
                      curve: Curves.easeOut,
                      child: child,
                    );
                  },
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Image.asset('assets/images/log.png');
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cart.product.title,
                style: TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: "${cart.product.price.toStringAsFixed(2)}  EGP",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                  children: [
                    TextSpan(
                        text: " x${cart.numOfItem}",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}
