import 'package:flutter/material.dart';
import 'package:shirikisho/utils/WAColors.dart';

class KishoStyles {
  ButtonStyle defaultButtonStyles() {
    ButtonStyle defaultButton = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        elevation: 0.5,
        minimumSize: const Size(30.0, 40.0),
        foregroundColor: Colors.white,
        backgroundColor: WAPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)));
    return defaultButton;
  }

  ButtonStyle saveButtonStyles() {
    ButtonStyle defaultButton = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        elevation: 0.5,
        minimumSize: const Size(30.0, 40.0),
        foregroundColor: Colors.white,
        // backgroundColor: WAPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)));
    return defaultButton;
  }

  ButtonStyle defaultBorderedButtonStyles() {
    ButtonStyle defaultButton = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        elevation: 0.5,
        minimumSize: const Size(30.0, 40.0),
        shadowColor: Colors.transparent,
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF24B42E),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(width: 1.5, color: Color(0xFF24B42E))));
    return defaultButton;
  }

  ButtonStyle roundButtonStyles() {
    ButtonStyle defaultButton = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        elevation: 0.5,
        minimumSize: const Size(40.0, 40.0),
        maximumSize: const Size(50.0, 50.0),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)));
    return defaultButton;
  }
}
