import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/utils/WAColors.dart';

Widget mastraDialog(BuildContext context,
    {
    String? name,
    String? title,
    String? message,
    String? assetIcon,
    Color? buttonColor,
    String? buttonText,
    double? buttonBorder,
    Function()? onPressed}) {
  double screenWidth = MediaQuery.of(context).size.width;
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    child: Container(
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: defaultBoxShadow(),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Image.asset(
            assetIcon ?? "assets/logo/success.png",
            height: screenWidth * 0.15,
            width: screenWidth * 0.4,
          ),
          5.height,
          Text(
            title ?? "title",
            textScaler: TextScaler.noScaling,
            style: boldTextStyle(size: 24),
          ),
          20.height,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message ?? "message",
              textScaler: TextScaler.noScaling,
              textAlign: TextAlign.center,
              style: primaryTextStyle(
                size: 14,
              ),
            ),
          ),
          20.height,
          Center(
            child: ElevatedButton(
              onPressed: onPressed ?? () => Navigator.pop(context),
              child: Text(
                buttonText ??"Funga",
                textScaler: TextScaler.noScaling,
                style: boldTextStyle(size: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor ?? WAPrimaryColor,
                // minimumSize: Size(MediaQuery.of(context).size.width, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
