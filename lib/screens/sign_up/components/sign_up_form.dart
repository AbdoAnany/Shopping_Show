import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panda1/components/custom_surfix_icon.dart';
import 'package:panda1/components/default_button.dart';
import 'package:panda1/components/form_error.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/screens/sign_in/sign_in_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String name;
  String phone;
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
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          Consumer(builder: (context, watch, _) {
            final ref = watch(pro);

            return ref.authStates == AuthStates.Authenticating
                ? CircularProgressIndicator(
                    strokeWidth: 3,
                    color: kPrimaryColor,
                  )
                : DefaultButton(
                    text: "أنشاء حساب",
                    press: () async {
                      var flag = '';
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        flag = await ref.register(name, phone, email, password);
                        print(flag);

                        if (flag == 'success') {
                          Navigator.pushNamed(context, SignInScreen.routeName);
                          ;
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

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 6) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 6) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "كلمة المرور",
        hintText: "أدخل كلمة المرور",
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
        hintText: "ادخل الايميل",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
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
        if (value.isNotEmpty) {
          removeError(error: 'رقم الهاتف فارغ');
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: 'رقم الهاتف فارغ');
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
