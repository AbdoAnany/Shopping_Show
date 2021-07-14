import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:panda1/ad_State.dart';
import 'package:panda1/components/coustom_bottom_nav_bar.dart';
import 'package:panda1/constants.dart';
import 'package:panda1/models/Cart.dart';
import 'package:panda1/screens/add_product/add_product_screen.dart';
import 'package:panda1/screens/cart/cart_screen.dart';
import 'package:panda1/size_config.dart';
import 'components/body.dart';
import 'components/customDrawer.dart';
import 'components/home_header.dart';
import 'package:panda1/controle/auth_provider.dart';

import 'components/icon_btn_with_counter.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                text: 'عروض  التسوق\n ',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(20),fontWeight: FontWeight.bold
                )),
            TextSpan(
                text: 'Shopping Show\n',
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(15),fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: getProportionateScreenWidth(7)))
          ]),
        ),
        actions: [
          IconBtnWithCounter(
            numOfitem: demoCarts.length,
            svgSrc: "assets/icons/Cart Icon.svg",
            press: () => Navigator.pushNamed(context, CartScreen.routeName),
          )
        ],
      ),
      drawer: CustomDrawer(),
      body: Body(),
      floatingActionButton: type=='admin'?FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
        if( type=='admin' )
          Navigator.pushNamed(context, AddProductScreen.routeName);
      },):SizedBox(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    ));
  }
}
