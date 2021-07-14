import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:panda1/screens/BillHistory/bill_history_screen.dart';
import 'package:panda1/screens/favourite/favourite_screen.dart';
import 'package:panda1/screens/home/home_screen.dart';
import 'package:panda1/screens/search/search_screen.dart';

import '../constants.dart';
import 'package:panda1/controle/auth_provider.dart';

class CustomBottomNavBar extends StatelessWidget {


  InterstitialAd _interstitialAd;

   CustomBottomNavBar({
    Key key,
    this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-4604195146685998/5008228339',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            this._interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Shop Icon.svg",
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {
               //   _interstitialAd.show();
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                }

              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Heart Icon.svg",
                  color: MenuState.favourite == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {
                  try{
                    _interstitialAd.show();
                    Navigator.pushNamed(context, FavouriteScreen.routeName);
                  }catch(e){
                    Navigator.pushNamed(context, FavouriteScreen.routeName);
                  }
                }
              ),
              IconButton(
                icon: Icon(Icons.category),
                color: MenuState.message == selectedMenu
                    ? kPrimaryColor
                    : inActiveIconColor,
                onPressed: () {
              //    _interstitialAd.show();
                    Navigator.pushNamed(context, SearchScreen.routeName);}
              ),
              IconButton(
                icon: Icon(
                  Icons.history_edu,
                  color: MenuState.profile == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {
                  try{
                    _interstitialAd.show();
                    Navigator.pushNamed(context, BillHistoryScreen.routeName);
                  }catch(e){
                    Navigator.pushNamed(context, BillHistoryScreen.routeName);
                  }
                }
              ),
            ],
          )),
    );
  }
}
