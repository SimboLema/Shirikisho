

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../WAColors.dart';

class VerTopCard extends StatelessWidget {
  final String name;
  final String acno;
  final String item1;
  final String item2;
  final String bal;

  VerTopCard({Key? key, required this.name, required this.acno, required this.item1,required this.item2, required this.bal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      height: context.height(),
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet, color: WAPrimaryColor, size: 30).paddingOnly(top: 8, left: 8),
                Text(name, style: primaryTextStyle(size: 18)).paddingOnly(left: 8, top: 8).expand(),
                Icon(Icons.info, color: appShadowColorDark, size: 20).paddingOnly(right: 8)
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item1, style: secondaryTextStyle(size: 16)).paddingOnly(left: 8, top: 8, bottom: 8),
              Text(acno, style: primaryTextStyle(color: Colors.green)).paddingOnly(right: 8, top: 8, bottom: 8),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item2, style: secondaryTextStyle(size: 16)).paddingOnly(left: 8, top: 8, bottom: 8),
              // Text(bal, style: primaryTextStyle(color: Colors.green)).paddingOnly(right: 8, top: 8, bottom: 8),
            ],
          )
        ],
      ),
    );
  }

  Widget appLogo() {
    return Image.asset(
      'images/orapay/opsplash.png',
      width: 36,
      height: 36,
      fit: BoxFit.fill,
    );
  }

}