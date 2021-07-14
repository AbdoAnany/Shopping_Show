import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:panda1/constants.dart';
import 'package:panda1/controle/auth_provider.dart';
import 'package:panda1/models/Product.dart';
import 'package:panda1/models/dbHelper.dart';

import '../../../size_config.dart';

class CustomAppBar extends PreferredSize {
  final Product product;

  CustomAppBar({@required this.product});

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
  DbHelper _dbHelper = DbHelper();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Row(
          children: [
            SizedBox(
              height: getProportionateScreenWidth(40),
              width: getProportionateScreenWidth(40),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
                color: Colors.white,
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  "assets/icons/Back ICon.svg",
                  height: 15,
                ),
              ),
            ),
            Spacer(),
            IconButton(
                onPressed: () async {
                  print('favorite');
                  await _dbHelper.createDateItem(product);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: kPrimaryColor,
                      content: Text(' تم أضافة المنتج الي قائمة المفضلات ')));
                },
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Text(
                    "${product.category}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SvgPicture.asset("assets/icons/Star Icon.svg"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
