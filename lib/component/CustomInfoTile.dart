import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/main.dart';

class CustomInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const CustomInfoTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor = const Color(0xFF26C884),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 16),
      decoration: boxDecorationRoundedWithShadow(16,
          backgroundColor: context.cardColor),
      child: ListTile(
        tileColor: Colors.red,
        enabled: true,
        contentPadding: EdgeInsets.zero,
        leading: Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          decoration: boxDecorationWithRoundedCorners(
            boxShape: BoxShape.circle,
            backgroundColor: Colors.white.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            size: 24,
            color: iconColor,
          ),
        ),
        title: RichTextWidget(
          list: [
            TextSpan(
              text: title,
              style: boldTextStyle(
                  size: 14, color: appStore.isDarkModeOn ? white : black),
            ),
          ],
          maxLines: 1,
        ),
        subtitle: Text(
          subtitle,
          style: primaryTextStyle(
            color: appStore.isDarkModeOn ? white : Colors.black54,
            size: 14,
          ),
        ),
      ),
    );
  }
}
