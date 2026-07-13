import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../WAColors.dart';

class TopCard extends StatelessWidget {
  final String name;
  final String acno;
  final String item1;
  final String item2;
  final String bal;

  TopCard(
      {Key? key,
      required this.name,
      required this.acno,
      required this.item1,
      required this.item2,
      required this.bal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      height: context.height(),
      color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet,
                        color: WAPrimaryColor, size: 30)
                    .paddingOnly(top: 8, left: 20),
                Text(name, style: boldTextStyle(size: 16))
                    .paddingOnly(left: 8, top: 8)
                    .expand(),
                Icon(Icons.info, color: WAPrimaryColor, size: 20)
                    .paddingOnly(right: 30)
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item1,
                      textScaler: TextScaler.noScaling,
                      style: boldTextStyle(size: 14))
                  .paddingOnly(left: 30, top: 8, bottom: 8),
              Text(acno,
                      textScaler: TextScaler.noScaling,
                      style: boldTextStyle(size: 14, color: Colors.green))
                  .paddingOnly(right: 30, top: 8, bottom: 8),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item2,
                style: boldTextStyle(size: 14),
                textScaler: TextScaler.noScaling,
              ).paddingOnly(left: 30, top: 8, bottom: 8),
              Text(
                bal,
                style: boldTextStyle(size: 14, color: Colors.green),
                textScaler: TextScaler.noScaling,
              ).paddingOnly(right: 30, top: 8, bottom: 8),
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

AppBar appBar(BuildContext context, String title,
    {List<Widget>? actions,
    bool showBack = true,
    Color? color,
    Color? iconColor,
    Color? textColor}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: color ?? appStore.appBarColor,
    leading: showBack
        ? IconButton(
            onPressed: () {
              finish(context);
            },
            icon: Icon(Icons.arrow_back,
                color: appStore.isDarkModeOn ? white : black),
          )
        : null,
    title:
        appBarTitleWidget(context, title, textColor: textColor, color: color),
    actions: actions,
    elevation: 0.5,
  );
}

Widget appBarTitleWidget(context, String title,
    {Color? color, Color? textColor}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 60,
    color: color ?? appStore.appBarColor,
    child: Row(
      children: <Widget>[
        Text(
          title,
          textScaler: TextScaler.noScaling,
          style: boldTextStyle(
              color: color ?? appStore.textPrimaryColor, size: 20),
          maxLines: 1,
        ).expand(),
      ],
    ),
  );
}
