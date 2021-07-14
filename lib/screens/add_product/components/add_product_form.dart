import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panda1/components/custom_surfix_icon.dart';
import 'package:panda1/components/default_button.dart';
import 'package:panda1/components/form_error.dart';
import 'package:panda1/constants.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/models/Product.dart';

import '../../../size_config.dart';

class AddProductForm extends StatefulWidget {
  @override
  _AddProductFormFormState createState() => _AddProductFormFormState();
}

class _AddProductFormFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  TextEditingController title,
      price,
      priceBefore,
      image,
      barcode,
      description,
      category,
      ratting;
  File file = null;
  Product product;
  var pro = ChangeNotifierProvider((ref) => AuthProvider());

  Future<void> photo(imageSource) async {
    final _picker = ImagePicker();
    var image = await _picker.getImage(source: imageSource);
    setState(() {
      file = File(image.path);
    });
  }

  Future<void> categoryLists() async {
    var c = await FirebaseFirestore.instance.collection('category').get();
    popItem = c.docs[0]['category'];
  }

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
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryLists();
    product = Product();
    title = TextEditingController();
    price = TextEditingController();
    priceBefore = TextEditingController();
    barcode = TextEditingController();
    ratting = TextEditingController(text: '3.2');
    description = TextEditingController();
    image = TextEditingController();
    category = TextEditingController(text: 'الاكثر شيوعا');
  }

  @override
  Widget build(BuildContext context) {
    var pro = ChangeNotifierProvider((ref) => AuthProvider());

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () async {
                  photo(ImageSource.gallery);
                },
                color: kPrimaryColor,
                icon: Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 40,
                ),
              ),
              IconButton(
                onPressed: () async {
                  photo(ImageSource.camera);
                },
                color: kPrimaryColor,
                icon: Icon(
                  Icons.add_a_photo_outlined,
                  size: 40,
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          file == null
              ? SizedBox()
              : Container(
                  height: 200,
                  width: SizeConfig.screenWidth,
                  child: Image.file(
                    file,
                    fit: BoxFit.fill,
                  ),
                ),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildFormField('Enter Name Product', 'Title', 'Enter Name Product',
              Icon(Icons.title), title),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: getProportionateScreenWidth(150),
                child: buildPriceFormField(),
              ),
              SizedBox(width: getProportionateScreenHeight(10)),
              Container(
                width: getProportionateScreenWidth(150),
                child: buildPriceBeforeFormField(),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: getProportionateScreenWidth(200),
                child: buildFormField('Enter barcode', 'Barcode', 'barcode',
                    Icon(Icons.qr_code_scanner_outlined), barcode),
              ),
              SizedBox(width: getProportionateScreenHeight(10)),
              Container(
                width: getProportionateScreenWidth(100),
                child: PopupMenuButton<String>(
                  child: Text(category.text,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  onSelected: (value) => setState(() => category.text = value),
                  itemBuilder: (context) => [
                    ...List.generate(popItem.length,
                        (index) => myPopupMenuItem(popItem[index]),
                        growable: true),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildFormField(
              'Enter description',
              'description',
              'Enter description ',
              Icon(Icons.description_outlined),
              description),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: 2.5,
                minRating: 1, maxRating: 4.8,
                itemSize: 35,
                direction: Axis.horizontal, //glow: true,
                //  allowHalfRating: true,
                itemCount: 5, allowHalfRating: true, glow: true, glowRadius: .5,
                itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 10,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                  setState(() {
                    ratting.text = (rating + .2).toString();
                  });
                },
              ),
              Text(ratting.text)
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          Consumer(builder: (context, watch, _) {
            final ref = watch(pro);
            return DefaultButton(
              text: "أضافة المنتج ",
              press: () async {
                //    await FirebaseFirestore.instance.collection('category').doc().set({
                //       'category':popItem, 'categoryShow':[{'type':'عروض رجالي','subTitle':'أكثر من 100 منتج'}]}).then((value) =>print('value'));

                if (file == null) {
                  scaffoldMessenger('  أضافة صورة');
                  return;
                }
                if (double.parse(priceBefore.text) < double.parse(price.text)) {
                  scaffoldMessenger('سعر  قبل اقل من سعر المنتج');
                  return;
                }
                if (_formKey.currentState.validate()) {
                  scaffoldMessenger('جاري اجراء الطلب .......');

                  await AuthProvider().uploadImageToFirebase(
                      file, category.text, title.text, barcode.text);

                  product = Product(
                    isPopular: 0,
                    barcode: barcode.text,
                    title: title.text,
                    price: double.parse(price.text),
                    description: description.text,
                    image: imagePath,
                    category: category.text,
                    type: 'normal',
                    priceBefore: double.parse(priceBefore.text),
                    rating: double.parse(ratting.text),
                  );

                  if (await AuthProvider().addProduct(product) == 'success') {
                    scaffoldMessenger(' تم أضافة المنتج');
                  }
                  barcode.clear();
                  title.clear();
                  barcode.clear();
                  price.clear();
                  priceBefore.clear();
                  image.clear();
                  description.clear();
                }
              },
            );
          }),
        ],
      ),
    );
  }

  scaffoldMessenger(message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      message,
      textDirection: TextDirection.rtl,
    )));
  }

  TextFormField buildFormField(error, label, hint, Icon, output) {
    return TextFormField(
      keyboardType: hint.toString() == 'barcode'
          ? TextInputType.number
          : TextInputType.text,
      controller: output,
      onSaved: (newValue) => output = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: error);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: error);
          return "";
        }
        return null;
      },
      maxLines: label == 'description' ? 5 : 1,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        suffixIcon: Icon,
      ),
    );
  }

  TextFormField buildTitleFormField() {
    return TextFormField(
      onSaved: (newValue) => title.text = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: 'Enter Title ');
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: 'Enter Title ');
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Title",
        hintText: "Enter your Tile",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPriceFormField() {
    return TextFormField(
      controller: price,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => price.text = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: 'Enter Price');
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: 'Enter Price');
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(getProportionateScreenWidth(5)),
            gapPadding: 0.2),

        labelText: "Price",
        hintText: "\$00.00",
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.attach_money),
      ),
    );
  }

  TextFormField buildPriceBeforeFormField() {
    return TextFormField(
      controller: priceBefore,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => priceBefore.text = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: 'Enter Price Before');
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: 'Enter Price Before');
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: " Price Before",
        hintText: "\$00.00",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.money_off_csred_outlined),
      ),
    );
  }

  PopupMenuItem<String> myPopupMenuItem(String value) {
    return PopupMenuItem<String>(
      value: value,
      child: ListTile(
        //  leading: Icon(icons, size: 25, color: Colors.green),
        title: Text(value.toUpperCase(),
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
