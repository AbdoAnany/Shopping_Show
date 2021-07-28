import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/screens/account/account_screen.dart';
import 'package:panda1/screens/add_product/add_product_screen.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends ConsumerWidget {
  var pro = ChangeNotifierProvider((ref) => AuthProvider());

  @override
  Widget build(BuildContext context, watch) {
    final ref = watch(pro);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 200,
            child: Image.asset("assets/images/logo.png"),
          ),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () =>
                {Navigator.pushNamed(context, AccountScreen.routeName)},
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {
              ref.logOut(context);
            },
          ),
        ],
      ),
    );
  }
}
