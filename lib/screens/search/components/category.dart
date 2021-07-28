import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:panda1/components/FadeAnimation.dart';
import 'package:panda1/constants.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/screens/home/components/special_offers.dart';
import 'package:panda1/size_config.dart';

import 'body.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  String searchBy = 'الاكثر شيوعا';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  BannerAd _bannerAd2;
  void showBannerAd() {
    super.didChangeDependencies();
    _bannerAd2 = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-4604195146685998/7153028028',
        request: AdRequest(),
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (Ad ad) => print('Ad loaded.'),
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            print('Ad failed to load: $error');
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) => print('Ad opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) => print('Ad closed.'),
          // Called when an ad is in the process of leaving the application.
        ))
      ..load();
  }

  Future<void> categoryLists() async {
    var c = await FirebaseFirestore.instance.collection('category').get();
    popItem = c.docs[0]['category'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryLists();
    showBannerAd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Container(
            child: _bannerAd2 != null
                ? Container(
                    height: 50,
                    child: AdWidget(
                      ad: _bannerAd2,
                    ))
                : Text(
                    'Shopping Show  عروض التسوق ',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  )),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            height: SizeConfig.screenHeight,
            padding: EdgeInsets.only(bottom: getProportionateScreenHeight(200)),
            child: FutureBuilder(
                future: FirebaseFirestore.instance.collection('category').get(),
                builder: (context, snapshot) {
                  print(snapshot.data.docs[0]['category'].length);
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 100,
                            //     childAspectRatio: 1.2
                          ),
                          itemCount: snapshot.data.docs[0]['category'].length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return FadeAnimation(
                              delay: 2 + index / 5,
                              fadeDirection: FadeDirection.left,
                              child: // (snapshot.data.docs[index].data()['category'] == '${searchBy.toString()}')?
                                  SpecialOfferCard(
                                image: "assets/images/lo.png",
                                category: popItem[index],
                                numOfBrands: 0,
                                press: () {
                                  scaffoldKey.currentState
                                      .showBottomSheet((context) => Body(
                                            searchBy: popItem[index],
                                          ));
                                },
                              ),
                            )
                                //:SizedBox(),
                                ;
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
      ),
    );
  }
}
