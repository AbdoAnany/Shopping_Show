import 'package:flutter/material.dart';
import 'package:panda1/size_config.dart';

const kPrimaryColor = Color(0xFAC80505);
const kPrimaryLightColor = Color(0xFFE8FFDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFF3E44), Color(0xFFF32323)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "لو سمحت ادخل الاميل";
const String kInvalidEmailError = "لو سمحت ادخل الاميل بشكل صحيح";
const String kPassNullError = "لو سمحت ادخل كلمة السر";
const String kShortPassError =
    "يجب ان تكون كلمة المرور اكثر من 6 احرف او ارقام";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "لوسمحت ادخل الاسم";
const String kPhoneNumberNullError = "لوسمحت ادخل رقم الهاتف";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // if (settings.arguments) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}
