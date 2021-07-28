import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:panda1/screens/sign_in/sign_in_screen.dart';

import '../../../size_config.dart';
import 'bill_history_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var pro = ChangeNotifierProvider((ref) => AuthProvider());
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, watch, _) {
        final ref = watch(pro);
        try {
          return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('bills')
                  .doc(ref.user.uid)
                  .collection(ref.user.email)
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
                      child: CircularProgressIndicator(),
                    );
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        padding: EdgeInsets.all(8),
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return FadeAnimation(
                            delay: 2 + index / 5,
                            fadeDirection: FadeDirection.left,
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                ref.deleteBill(snapshot.data.docs[index].id);
                                setState(() {
                                  count = snapshot.data.docs.length;
                                });
                              },
                              background: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFA7070),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    SvgPicture.asset("assets/icons/Trash.svg"),
                                  ],
                                ),
                              ),
                              child: BillHistoryCard(
                                  cart: snapshot.data.docs[index].data()),
                            ),
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
              });
        } catch (e) {
          return Center(
            child: MaterialButton(
              elevation: 5,
              child: Text('يجب تسجيل اولا'),
              onPressed: () {
                Navigator.pushNamed(context, SignInScreen.routeName);
              },
            ),
          );
        }
      },
    );
  }
}
