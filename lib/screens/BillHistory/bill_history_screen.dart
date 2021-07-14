import 'package:flutter/material.dart';
import 'package:panda1/components/coustom_bottom_nav_bar.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/models/Cart.dart';
import 'components/body.dart';

class BillHistoryScreen extends StatelessWidget {
  static String routeName = "/bill_history";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:   Text(
        "قائمة الفواتير",textDirection: TextDirection.rtl,

      ),),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
