import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panda1/components/custom_surfix_icon.dart';
import 'package:panda1/components/form_error.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/helper/keyboard.dart';
import 'package:panda1/screens/home/home_screen.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
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
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("تذكرني"),
              Spacer(),
              GestureDetector(
                //        onTap: () => Navigator.pushNamed(context, ForgotPasswordScreen.routeName),
                child: Text(
                  "نسيت كلمة المرور",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          Consumer(builder: (context, watch, _) {
            final ref = watch(pro);

            return ref.authStates == AuthStates.Authenticating
                ? CircularProgressIndicator(
                    color: kPrimaryColor,
                    strokeWidth: 3,
                  )
                : DefaultButton(
                    text: "تسجيل",
                    press: () async {
                      KeyboardUtil.hideKeyboard(context);

                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        KeyboardUtil.hideKeyboard(context);

                        var flag = '';
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          flag = await ref.login(email, password);

                          if (flag == 'success') {
                            Navigator.pushNamed(context, HomeScreen.routeName);
                          } else {
                            KeyboardUtil.hideKeyboard(context);
                          }
                        }
                      }
                    },
                  );
          }),
          SizedBox(height: getProportionateScreenHeight(20)),
          MaterialButton(
            elevation: 5,
            child: Text("زيارة بدون تسجيل"),
            onPressed: () async {
              KeyboardUtil.hideKeyboard(context);
              userid = null;
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          )
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "كلمة السر",
        hintText: "أدخل كلمة السر",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "الايميل",
        hintText: "أدخل الايميل الخاص بك",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
