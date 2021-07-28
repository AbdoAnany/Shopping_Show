import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:panda1/components/FadeAnimation.dart';
import 'package:panda1/components/default_button.dart';
import 'package:panda1/components/product_card.dart';
import 'package:panda1/constants.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/models/Cart.dart';
import 'package:panda1/models/Cart.dart';
import 'package:panda1/models/Product.dart';
import 'package:panda1/models/dbHelper.dart';
import 'package:panda1/screens/details/details_screen.dart';

import '../../../size_config.dart';
import 'favourite_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var pro = ChangeNotifierProvider((ref) => AuthProvider());
  DbHelper _dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dbHelper.allDateItem(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: FadeAnimation(
                delay: 2 + index / 5,
                fadeDirection: FadeDirection.left,
                child: Dismissible(
                  key: UniqueKey(),
                  // Key(demoCarts[index].product.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _dbHelper.deleteDateItem(snapshot.data[index]['id']);
                    setState(() {});
                  },
                  background: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE6E6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Spacer(),
                        SvgPicture.asset("assets/icons/Trash.svg"),
                      ],
                    ),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, DetailsScreen.routeName,
                          arguments: ProductDetailsArguments(
                              product: Product.fromMap(snapshot.data[index])));
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 88,
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F6F9),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: .5,
                                  blurRadius: 2,
                                  offset: Offset(2, 4)),
                              BoxShadow(
                                  color: Colors.white, offset: Offset(0, 0)),
                            ],
                          ),
                          child: Image.network(
                            snapshot.data[index]['image'],
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
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return Image.asset('assets/images/log.png');
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Flexible(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data[index]['title'],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              maxLines: 2,
                              softWrap: true,
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                text: "${snapshot.data[index]['price']}  EGP",
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
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
