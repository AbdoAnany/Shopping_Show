import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:panda1/components/product_card.dart';
import 'package:panda1/components/FadeAnimation.dart';
import 'package:panda1/constants.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/models/Product.dart';
import 'package:panda1/screens/search/search_screen.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
              title: "منتجات الاكثر شيوعا",
              press: () {
                Navigator.pushNamed(context, SearchScreen.routeName);
              }),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: getProportionateScreenHeight(350),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15)),
                ),
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('products')
                        .doc(popItem[0])
                        .collection(popItem[0])
                        .get(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Center(
                            child: Text(
                              "Nothing Here !!",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
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
                          return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              padding: EdgeInsets.all(8),
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                //    if (snapshot.data.docs[index].data()['product']['isPopular'] == 1)
                                return FadeAnimation(
                                  delay: 2 + index / 5,
                                  fadeDirection: FadeDirection.top,
                                  child: ProductCard(
                                    product: Product.fromMap(snapshot
                                        .data.docs[index]
                                        .data()['product']),
                                    id: snapshot.data.docs[index].id,
                                  ),
                                );
                                return SizedBox();
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
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        )
      ],
    );
  }
}
