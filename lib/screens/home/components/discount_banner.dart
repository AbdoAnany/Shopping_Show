import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:panda1/constants.dart';

import '../../../size_config.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: FutureBuilder(
            future: FirebaseFirestore.instance.collection('offers').get(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(
                    child: Text(
                      "Nothing Here !!",
                      style: TextStyle(fontSize: 20, color: Color(0xF0000000)),
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
                  return Container(
                    height: 120,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: SizeConfig.screenWidth * .9,
                          margin:
                              EdgeInsets.all(getProportionateScreenWidth(10)),
                          padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20),
                            vertical: getProportionateScreenWidth(15),
                          ),
                          decoration: BoxDecoration(
                            color: Color(snapshot.data.docs[index]['color'])
                                .withOpacity(.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                  text:
                                      "${snapshot.data.docs[index]['title']}\n",
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "${snapshot.data.docs[index]['subtitle']}",
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            textDirection: TextDirection.rtl,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                      //  pagination: new SwiperPagination(),
                      // control: new SwiperControl(),
                      itemCount: snapshot.data.docs.length,
                      viewportFraction: 1.0,
                      autoplayDelay: 15000,
                      autoplay: true,
                      scale: .7,
                    ),
                  );
                  break;
              }
              return Center(
                child: Text(
                  "Nothing Here !!",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              );
            }));
  }
}
