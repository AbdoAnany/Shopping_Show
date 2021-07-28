import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:panda1/components/FadeAnimation.dart';
import 'package:panda1/components/default_button.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/models/Cart.dart';
import 'package:panda1/screens/sign_in/sign_in_screen.dart';
import '../../../size_config.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var pro = ChangeNotifierProvider((ref) => AuthProvider());
  String address = ' أضف العنوان';
  int cost = 0;
  InterstitialAd _interstitialAd;
  Map<String, dynamic> addressList = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressLists();
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-4604195146685998/8873303800',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            this._interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _interstitialAd.dispose();
  }

  Future<void> addressLists() async {
    var c = await FirebaseFirestore.instance.collection('address').get();
    addressList = c.docs[0]['address'];
  }

  @override
  @override
  Widget build(BuildContext context) {
    total = 0;

    demoCarts.forEach((element) {
      total = total + element.product.price * element.numOfItem;
    });

    return Scaffold(
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          Align(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: ListView.builder(
                itemCount: demoCarts.length,
                itemBuilder: (context, index) {
                  if (demoCarts[index].numOfItem > 0)
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: FadeAnimation(
                        delay: 2 + index / 5,
                        fadeDirection: FadeDirection.left,
                        child: Dismissible(
                          key: UniqueKey(),
                          // Key(demoCarts[index].product.id.toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            demoCarts.removeAt(index);
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
                          child: CartCard(cart: demoCarts[index]),
                        ),
                      ),
                    );

                  return SizedBox();
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenWidth(15),
                horizontal: getProportionateScreenWidth(30),
              ),
              // height: 174,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -15),
                    blurRadius: 2,
                    color: Color(0xFF3D3B3B).withOpacity(0.2),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: getProportionateScreenWidth(40),
                        width: getProportionateScreenWidth(40),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset("assets/icons/receipt.svg"),
                      ),
                      Spacer(),
                      Container(
                        width: getProportionateScreenWidth(200),
                        child: PopupMenuButton<String>(
                          child: Text(address,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          onSelected: (value) => setState(() {
                            address = value;
                          }),
                          itemBuilder: (context) => [
                            ...List.generate(
                                addressList.length,
                                (index) => myPopupMenuItem(
                                    addressList.keys.elementAt(index),
                                    addressList.values.elementAt(index)),
                                growable: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Total:\n",
                          children: [
                            TextSpan(
                              text:
                                  "${double.parse((total.toStringAsFixed(2)))} EPG",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(190),
                        child: Consumer(
                          builder: (BuildContext context, watch, _) {
                            final ref = watch(pro);
                            return DefaultButton(
                                text: "أرسال طلب",
                                press: () async {
                                  if (userid == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: MaterialButton(
                                          elevation: 5,
                                          child: Text(
                                            'يجب تسجيل اولا',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                SignInScreen.routeName);
                                          },
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  if (await ref.addBill(
                                          demoCarts, address, total) ==
                                      'success') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('تم ارسال الطلب'),
                                    ));
                                    demoCarts.clear();
                                    _interstitialAd.show();
                                  }
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "العربة التسوق",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "${demoCarts.length} منتج ",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> myPopupMenuItem(key, value) {
    return PopupMenuItem<String>(
      value: '$key = $value EGP',
      child: ListTile(
        //  leading: Icon(icons, size: 25, color: Colors.green),
        title: Text('$key = $value EGP',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
