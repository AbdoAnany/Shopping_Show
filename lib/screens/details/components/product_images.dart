import 'package:flutter/material.dart';
import 'package:panda1/models/Product.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductImages extends StatelessWidget {
  const ProductImages({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 1.4,
            child: Container(
              color: Colors.transparent,
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
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
                  return Image.asset('assets/images/logo.png');
                },
              ),
            ),
            // child: Image.network(product.description),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Card(
            elevation: 5,
            borderOnForeground: true,
            margin: EdgeInsets.only(
              left: 18,
            ),
            shadowColor: kPrimaryColor,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    //style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: '${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: ' EGP',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18,
                              fontFamily: 'ArefRuqaa',
                              fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                Text(
                  '${product.priceBefore.toStringAsFixed(2)}  EGP',
                  style: TextStyle(
                      decoration: TextDecoration.combine([
                        TextDecoration.lineThrough,
                        TextDecoration.lineThrough,
                      ]),
                      fontSize: 16),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

// GestureDetector buildSmallProductPreview(int index) {
//   return GestureDetector(
//     onTap: () {
//       setState(() {
//         selectedImage = index;
//       });
//     },
//     child: AnimatedContainer(
//       duration: defaultDuration,
//       margin: EdgeInsets.only(right: 15),
//       padding: EdgeInsets.all(8),
//       height: getProportionateScreenWidth(48),
//       width: getProportionateScreenWidth(48),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//             color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
//       ),
//       child: Image.asset(product.images[index]),
//     ),
//   );
// }
