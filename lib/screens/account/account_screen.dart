import 'package:flutter/material.dart';
import 'package:panda1/components/coustom_bottom_nav_bar.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/screens/account/body.dart';


class AccountScreen extends StatelessWidget {
  static String routeName = "/account";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(),
      body: Body(),
    );
  }
}
