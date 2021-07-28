import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:panda1/ad_State.dart';
import 'package:panda1/components/FadeAnimation.dart';
import 'package:panda1/components/product_card.dart';
import 'package:panda1/constants.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/models/Product.dart';
import 'package:panda1/size_config.dart';

class Body extends StatelessWidget {
  final searchBy;

  const Body({Key key, this.searchBy}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          height: SizeConfig.screenHeight,
          padding: EdgeInsets.only(bottom: getProportionateScreenHeight(200)),
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('products')
                  .doc(searchBy)
                  .collection(searchBy)
                  .get(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: Text(
                        "Nothing Here !!",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    );
                    break;
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    );
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 250,
                        ),
                        itemCount: snapshot.data.docs.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return FadeAnimation(
                              delay: 2 + index / 5,
                              fadeDirection: FadeDirection.left,
                              child: // (snapshot.data.docs[index].data()['category'] == '${searchBy.toString()}')?
                                  ProductCard(
                                product: Product.fromMap(snapshot
                                    .data.docs[index]
                                    .data()['product']),
                                id: snapshot.data.docs[index].id,
                              ) //:SizedBox(),
                              );
                        });

                    break;
                }
                return Center(
                  child: Text(
                    "Nothing Here !!",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

PopupMenuItem<String> myPopupMenuItem(
  String value,
) {
  return PopupMenuItem<String>(
    value: value,
    child: ListTile(
      title: Text(value.toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
    ),
  );
}
