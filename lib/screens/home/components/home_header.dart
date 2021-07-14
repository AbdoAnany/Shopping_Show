import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:panda1/ad_State.dart';
import 'package:panda1/models/Cart.dart';
import 'package:panda1/screens/cart/cart_screen.dart';
import 'package:panda1/size_config.dart';
import 'icon_btn_with_counter.dart';

class HomeHeader extends StatefulWidget {
  HomeHeader({
    Key key,
  }) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final infuture = MobileAds.instance.initialize();
  BannerAd _bannerAd;
  void showBannerAd() {
    super.didChangeDependencies();
    final adState = AdState(infuture);
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-4604195146685998/1960411096',
        request: AdRequest(),
        listener: adState.listener)
      ..load();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showBannerAd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 25, top: 10, right: 10),
      padding: EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: _bannerAd != null
                ? Container(
                    width: SizeConfig.screenWidth * .6,
                    child: AdWidget(
                      ad: _bannerAd,
                    ))
                : SizedBox(),
          ),
          SizedBox(
            width: 10,
          ),
          //  SearchField(),

          IconBtnWithCounter(
            numOfitem: demoCarts.length,
            svgSrc: "assets/icons/Cart Icon.svg",
            press: () => Navigator.pushNamed(context, CartScreen.routeName),
          ),
          // IconBtnWithCounter(
          //   svgSrc: "assets/icons/Bell.svg",
          //   numOfitem: 3,
          //   press: () {},
          // ),
        ],
      ),
    );
  }
}
