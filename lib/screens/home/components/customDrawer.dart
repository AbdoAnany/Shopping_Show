import 'package:flutter/material.dart';
import '../../profile/profile_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(

      elevation: 5,
      child: ProfileScreen(),
    );
  }
}
