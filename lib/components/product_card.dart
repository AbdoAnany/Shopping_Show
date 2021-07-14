import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/models/Cart.dart';
import 'package:panda1/models/Product.dart';
import 'package:panda1/screens/details/details_screen.dart';

import '../constants.dart';
import '../size_config.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    Key key,
    this.width = 160,
    this.aspectRetio = 1.02,
    this.id,
    @required this.product,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;
  final id;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: getProportionateScreenHeight(250),
        padding: EdgeInsets.symmetric(horizontal:getProportionateScreenWidth(10)),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            DetailsScreen.routeName,
            arguments: ProductDetailsArguments(product: product),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          type =='admin'   ?Expanded(child: IconButton(onPressed: (){
            AuthProvider().deleteProduct(product.category,id);
          }, icon: Icon(Icons.clear))):SizedBox(),
              Expanded(
                  flex: 5,
                  child: Container(
                    width: getProportionateScreenWidth(200),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            spreadRadius: .5,
                            blurRadius: 2,
                            offset: Offset(2, 4)),
                        BoxShadow(color: Colors.white, offset: Offset(0, 0)),
                      ],
                      borderRadius: BorderRadius.circular(5),
                      // image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(product.image,),)
                    ),
                    child: Hero(
                      tag: product.id,
                      child: Image.network(
                        product.image,
                        fit: BoxFit.fill,
                        frameBuilder: (BuildContext context, Widget child,
                            int frame, bool wasSynchronouslyLoaded) {
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
                              color: kPrimaryColor,
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
                  )),
              Expanded(
                   flex: 1,
                child: Text(
                  product.title,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  textAlign: TextAlign.justify,
                ),
              ),
              Expanded(
                  flex: 2,
                  child: RichText(
                    text: TextSpan(
                      //style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                            text: '${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                        TextSpan(
                            text: ' EGP',
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                        product.priceBefore != null?   TextSpan(
                            text: '\n${product.priceBefore.toStringAsFixed(2)}  EGP',
                          style: TextStyle(
                            decoration: TextDecoration.combine([
                              TextDecoration.lineThrough,
                              TextDecoration.lineThrough
                            ]),
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),):  TextSpan(text: ''),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}
