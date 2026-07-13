import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../utils/SVCommon.dart';
import '../../../../utils/SVConstants.dart';

class SVPostTextComponent extends StatelessWidget {
  const SVPostTextComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: radius(SVAppCommonRadius)),
      child: TextField(
        autofocus: false,
        maxLines: 4,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Whats On Your Mind',
          hintStyle: secondaryTextStyle(size: 12, color: svGetBodyColor()),
        ),
      ),
    );
  }
}
