import 'package:flutter/widgets.dart';
import 'package:panda1/screens/cart/cart_screen.dart';
import 'package:panda1/screens/details/details_screen.dart';
import 'package:panda1/screens/favourite/favourite_screen.dart';
import 'package:panda1/screens/profile/profile_screen.dart';
import 'package:panda1/screens/home/home_screen.dart';
import 'package:panda1/screens/sign_in/sign_in_screen.dart';
import 'package:panda1/screens/sign_up/sign_up_screen.dart';
import 'package:panda1/screens/splash/splash_screen.dart';

import 'screens/BillHistory/bill_history_screen.dart';
import 'screens/account/account_screen.dart';
import 'screens/add_product/add_product_screen.dart';
import 'screens/search/search_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  AccountScreen.routeName: (context) => AccountScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  FavouriteScreen.routeName: (context) => FavouriteScreen(),
  BillHistoryScreen.routeName: (context) => BillHistoryScreen(),
  SearchScreen.routeName: (context) => SearchScreen(),
  AddProductScreen.routeName: (context) => AddProductScreen(),
};
