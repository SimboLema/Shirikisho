import 'package:flutter/material.dart';

ExactAssetImage buildExactAssetImage(String? backgroundImage) {
  if (backgroundImage != null) {
    return ExactAssetImage(
      backgroundImage,
    );
  } else {
    return const ExactAssetImage(
      // "Constants.worldMapImage",
      "assets/bima/sanlam.png",

      // package: "Constants.packageName,"
    );
  }
}

/// Builds a widget to display currency text.
///
/// [currency] is the Text widget containing the currency data to display.
/// It returns a Text widget styled with a default or custom TextStyle for the currency text.
///
// Widget buildCurrencyText(Text? currency, Color? colors) {
//   // Default text style for currency
//   TextStyle textStyle = const TextStyle(
//     fontWeight: FontWeight.bold,
//     color:colors,
//     fontSize: 15,
//   );

//   // If the currency text has a custom style, apply it to the text style
//   if (currency!.style != null) {
//     textStyle = currency.style!.copyWith(
//       fontWeight: FontWeight.bold,
//       fontSize: 15,
//     );
//   }

//   return Builder(builder: (context) {
//     // Build a SizedBox with fixed width and height to constrain the currency text
//     return SizedBox(
//       width: 130,
//       height: 20,
//       // Display the currency text with the calculated text style
//       child: Text(currency.data!, style: textStyle.applyPackage),
//     );
//   });
// }

Widget buildCurrencyText(Text? currency, Color? colors) {
  // Default text style for currency
  TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: colors, // No const because colors is a variable
    fontSize: 12,
  );

  // If the currency text has a custom style, apply it to the text style
  if (currency?.style != null) {
    textStyle = currency!.style!.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
  }

  return Text(
      textScaler: TextScaler.noScaling, currency?.data ?? '', style: textStyle);
}

extension TextStyleExt on TextStyle {
  /// Applies the package name to the TextStyle.
  TextStyle get applyPackage {
    return copyWith(package: " helper");
  }
}

///The `getTypeIcon()` function then returns the widget.
// Widget getTypeIcon(String number, bool isStrict) {
//   if (isStrict) {
//     return Matcher.resolvePrefix(number, (a, b) => this != CardNetwork.verve ? a : b);
//   } else {
//     return switch (this) {
//       CardNetwork.visa => CardNetworkIcon.visa,
//       CardNetwork.mastercard => CardNetworkIcon.mastercard,
//       CardNetwork.verve => CardNetworkIcon.verve,
//       CardNetwork.americanExpress => CardNetworkIcon.americanExpress,
//       CardNetwork.discover => CardNetworkIcon.discover,
//       CardNetwork.jcb => CardNetworkIcon.jcb,
//       _ => CardNetworkIcon.visa,
//     };
//   }
// }
