import 'package:flutter/material.dart';
import 'package:panda1/models/Cart.dart';
import 'package:panda1/models/Product.dart';
import 'package:panda1/screens/details/details_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class FavouriteCard extends StatelessWidget {
  const FavouriteCard({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.pushNamed(context, DetailsScreen.routeName,
            arguments: ProductDetailsArguments(product: product));
      },
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(
                  product.image,
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
                product.title,
                style: TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  //  text: "\$${product.price}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: kPrimaryColor),
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}
