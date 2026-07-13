import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ServicesComponent extends StatefulWidget {
  static String tag = '/ServicesComponent';
  final dynamic itemModel;
  final bool isApplyColor;

  ServicesComponent({this.itemModel, this.isApplyColor = false});

  @override
  ServicesComponentState createState() => ServicesComponentState();
}

class ServicesComponentState extends State<ServicesComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: boxDecorationRoundedWithShadow(
            16,
            backgroundColor: widget.itemModel!.color!.withOpacity(0.2),
            // shadowColor: widget.isApplyColor ? Colors.transparent : Colors.grey.withOpacity(0.2),
          ),
          child: Image.asset(
            '${widget.itemModel!.image!}',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
        8.height,
        Text(
          '${widget.itemModel!.title!}',
          style: boldTextStyle(
              size: 16, color: appStore.isDarkModeOn ? white : black),
          textAlign: TextAlign.center,
          overflow: TextOverflow.clip,
          maxLines: 2,
          // textScaleFactor: 1,
          textScaler: TextScaler.linear(1),
        ),
      ],
    );
  }
}
