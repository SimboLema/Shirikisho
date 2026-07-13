import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class MalipoComponent extends StatefulWidget {
  static String tag = '/MalipoComponent';
  final dynamic itemModel;
  final bool isApplyColor;

  MalipoComponent({this.itemModel, this.isApplyColor = false});

  @override
  MalipoComponentState createState() => MalipoComponentState();
}

class MalipoComponentState extends State<MalipoComponent> {
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
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: boxDecorationRoundedWithShadow(
            16,
            backgroundColor: widget.itemModel!.color!.withOpacity(0.1),
            shadowColor: widget.isApplyColor ? Colors.transparent : Colors.grey.withOpacity(0.2),
          ),
          child: Image.asset(
            '${widget.itemModel!.image!}',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          )  ,
        ),
        8.height,
        Text(
          '${widget.itemModel!.title!}',
          style: boldTextStyle(size: 14, color: appStore.isDarkModeOn ? white : black),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ],
    );
  }
}
