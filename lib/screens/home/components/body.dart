import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:panda1/ad_State.dart';
import 'package:panda1/controle/auth_provider.dart';
import '../../../size_config.dart';
import 'discount_banner.dart';
import 'popular_product.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final adState = AdState(MobileAds.instance.initialize());

  BannerAd _bannerAd;

  void showBannerAd() {
    super.didChangeDependencies();
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
    AuthProvider().usertype(context);
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 200,
            padding: EdgeInsets.only(right: 25, top: 15),
            // alignment: Alignment.centerRight,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                'assets/images/lo.png',
              ),
            )),
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: _bannerAd != null
                      ? AdWidget(
                          ad: _bannerAd,
                        )
                      : Text(
                          'Shopping Show  عروض التسوق ',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                ),
                DiscountBanner()
              ],
            ),
          ),
          SizedBox(
              height: getProportionateScreenHeight(10)), //   SpecialOffers(),
          PopularProducts(),
          SizedBox(height: getProportionateScreenWidth(20)),
        ],
      ),
    );
  }
}
