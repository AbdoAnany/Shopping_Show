import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda1/models/Cart.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class BillHistoryCard extends StatefulWidget {
  BillHistoryCard({
    Key key,
    this.cart,
  }) : super(key: key);
  final cart;

  @override
  _BillHistoryCardState createState() => _BillHistoryCardState();
}

class _BillHistoryCardState extends State<BillHistoryCard> {
  void showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(
                      widget.cart['bill'].length,
                      (index) => ListTile(
                          title: Text(
                            '${widget.cart['bill'][index]['title']}',
                            textDirection: TextDirection.rtl,
                          ),
                          subtitle: Text(
                              ' \$${widget.cart['bill'][index]['price']} x '
                              '${widget.cart['bill'][index]['num']} ')),
                      growable: true),
                ],
              ),
            ),
            actions: [
              Text(
                ' \$${widget.cart['total']} المجموع  ',
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              Center(
                child: Text(
                  '    حاله الطلب     ${widget.cart['state']}',
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              )
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2.0))),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        showAlert();
      },
      child: Container(
        // height: 174,
        margin: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(15),
          horizontal: getProportionateScreenWidth(30),
        ),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              ' ${widget.cart['date']}  التاريخ  ',
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            Divider(
              height: 20,
              thickness: 3,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  ' \$${widget.cart['total']} المجموع  ',
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Text(
                  '    حاله الطلب     ${widget.cart['state']}',
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
