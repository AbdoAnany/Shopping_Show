import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panda1/components/custom_surfix_icon.dart';
import 'package:panda1/components/default_button.dart';
import 'package:panda1/components/form_error.dart';
import 'package:panda1/constants.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/screens/home/home_screen.dart';
import 'package:panda1/screens/sign_in/sign_in_screen.dart';
import 'package:panda1/size_config.dart';

class DataForm extends StatefulWidget {
  @override
  _DataFormState createState() => _DataFormState();
}

class _DataFormState extends State<DataForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String name;
  String phone;
  String address;
  bool remember = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    var pro = ChangeNotifierProvider((ref) => AuthProvider());

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          Consumer(builder: (context, watch, _) {
            final ref = watch(pro);
            return ref.authStates == AuthStates.Authenticating
                ? CircularProgressIndicator(
                    strokeWidth: 3,
                  )
                : DefaultButton(
                    text: "ارسال",
                    press: () async {
                      var flag = '';
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        flag = await ref.account(
                            name, phone, email, password, address);
                        if (flag == 'success') {
                          Navigator.pushNamed(context, HomeScreen.routeName);

                        } else if (flag ==
                            'The email address is already in use by another account.') {
                          addError(error: 'هذا الايميل مستخدم بالفعل');
                        }
                      }
                    },
                  );
          }),
        ],
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(

      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: 'ادخل العنوان');
        } else if (value.length >= 8) {
          removeError(error:  'ادخل العنوان');
        }
        address = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error:  'ادخل العنوان');
          return "";
        }


        return null;
      },
      decoration: InputDecoration(
        labelText: "العنوان",
        hintText: "أدخل العنوان",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }


  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => name = newValue,
      validator: (value) {
        if (value.isEmpty) {
          addError(error: 'الاسم فارغ');
          return "";
        }
        if (value.isNotEmpty) {
          removeError(error: 'الاسم فارغ');
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: 'الاسم فارغ');
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "الاسم",
        hintText: "أدخل الاسم",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => phone = newValue,
      validator: (value) {
        if (value.isEmpty) {
          addError(error: 'رقم الهاتف فارغ');
          return "";
        }
        else if (value.length<8) {
          addError(error: 'رقم الهاتف غير صحيح');
        }
        if (value.isNotEmpty) {
          removeError(error: 'رقم الهاتف فارغ');
        } else if (value.length>=8) {
          removeError(error: 'رقم الهاتف غير صحيح');
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "الهاتف",
        hintText: "ادخل الهاتف",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }
}
