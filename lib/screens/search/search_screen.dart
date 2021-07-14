import 'package:flutter/material.dart';
import 'package:panda1/components/coustom_bottom_nav_bar.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'components/category.dart';

class SearchScreen extends StatelessWidget {
  static String routeName = "/search";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Category(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.message),
    ));
  }
}
