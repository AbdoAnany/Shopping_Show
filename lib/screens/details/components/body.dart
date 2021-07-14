import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panda1/components/default_button.dart';
import 'package:panda1/components/rounded_icon_btn.dart';
import 'package:panda1/constants.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/models/Cart.dart';
import 'package:panda1/models/Product.dart';
import 'package:panda1/models/dbHelper.dart';
import '../../../size_config.dart';
import 'color_dots.dart';
import 'product_description.dart';
import 'product_images.dart';

class Body extends StatefulWidget {
  final Product product;

  Body({Key key, @required this.product}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  DbHelper _dbHelper = DbHelper();

  int count = 0;
  bool flag = false;

  counts() {
    demoCarts.forEach((element) {
      if (element.product.id == widget.product.id) {
        element.numOfItem = element.numOfItem;
        count = element.numOfItem;
      }
    });

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Tez))
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    counts();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
      Hero(tag:widget.product.id,
        child:   ProductImages(product: widget.product),),
        Container(
          padding: EdgeInsets.only(
              top: getProportionateScreenWidth(10),
              bottom: getProportionateScreenWidth(20)),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, blurRadius: 5, offset: Offset(-2, -2)),
            ],
          ),
          child: Column(
            children: [
              ProductDescription(
                product: widget.product,
                pressOnSeeMore: () {},
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: getProportionateScreenWidth(10)),
                padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFECD8DE),
                  borderRadius: BorderRadius.only(
                      //      topLeft: Radius.circular(40),
                      //     topRight: Radius.circular(40),
                      ),
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedIconBtn(
                      icon: Icons.remove,
                      press: () {
                        if (count != 0)
                          setState(() {
                            count = count - 1;
                          });
                      },
                    ),
                    SizedBox(width: getProportionateScreenWidth(10)),
                    Text('$count'),
                    SizedBox(width: getProportionateScreenWidth(10)),
                    RoundedIconBtn(
                      icon: Icons.add,
                      showShadow: true,
                      press: () {
                        if (count >= 0)
                          setState(() {
                            count = count + 1;
                          });
                      },
                    ),
                    SizedBox(width: getProportionateScreenWidth(10)),
                    DefaultButton(
                      text: "أضف الي العربة",
                      press: () {
                        print(widget.product.id);

                        demoCarts.forEach((element) {
                          if (element.product.id == widget.product.id) {
                            element.numOfItem = count;
                            flag = true;
                          }
                        });
                        if (!flag) {
                          demoCarts.add(
                            Cart(
                                product: widget.product,
                                numOfItem: count),
                          );
                        }
                        if (count == 0)
                          demoCarts.forEach((element) {
                            if (element.product.id == widget.product.id &&
                                element.numOfItem == 0) {
                              demoCarts.remove(element);
                            }
                          });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    ' تم اضافة المنتج الي العربة ')));
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
