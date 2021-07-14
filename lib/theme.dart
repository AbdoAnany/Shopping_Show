import 'package:flutter/material.dart';
import 'package:panda1/constants.dart';

ThemeData theme() {
  return ThemeData(

    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.red,
    accentColor: Colors.red,

    snackBarTheme: SnackBarThemeData(
        actionTextColor: Colors.white, backgroundColor: Color(0xffe90909)),
    fontFamily: "Muli",
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    primaryIconTheme: IconThemeData(color: Color(0xffe90909)),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: kTextColor),
    //  gapPadding: 10,
  );
  return InputDecorationTheme(
    // If  you are using latest version of flutter then lable text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: kTextColor),
    bodyText2: TextStyle(color: kTextColor),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: kPrimaryColor,
    elevation: 5,centerTitle: true,shadowColor: Colors.black,


    brightness: Brightness.light,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20) ,

    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      headline6: TextStyle(color: Colors.white, fontSize: 20),
    ),
  );
}
