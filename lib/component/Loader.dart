import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/utils/WAColors.dart';

Widget customLoader(BuildContext context) {
  return Container(
    height: context.height(),
    width: context.width(),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/walletApp/wa_bg.jpg'),
        fit: BoxFit.cover,
        opacity: 0.9,
      ),
      color: Colors.black,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: CircularProgressIndicator(
          color: WAPrimaryColor,
        )),
        10.height,
        Text(
          'Tafadhali Subiri ...',
          textScaler: TextScaler.noScaling,
          style: boldTextStyle(color: WAPrimaryColor),
        ),
      ],
    ),
  );
}
