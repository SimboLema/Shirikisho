// Get today's date
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path_provider/path_provider.dart';

var plateFormatter = new MaskTextInputFormatter(
    mask: 'MC ### XXX',
    filter: {"#": RegExp(r'[0-9]'), "X": RegExp(r'[A-Z]')},
    type: MaskAutoCompletionType.lazy);

var plateNewFormatter = new MaskTextInputFormatter(
    mask: 'MC###XXX',
    filter: {"#": RegExp(r'[0-9]'), "X": RegExp(r'[A-Z]')},
    type: MaskAutoCompletionType.lazy);
String cleanPlate(String formattedPlate) {
  return formattedPlate.replaceAll(' ', '').trim();
}

String currentDate() {
  DateTime today = DateTime.now();

  // Format the date as "day-month-year"
  String formattedDate = DateFormat('dd-MM-yyyy').format(today);

  // print(formattedDate);

  return formattedDate;
}

double downPayment(int? percentage, int? total_amount) {
  if (percentage == null || total_amount == null) {
    return 0.0; // Return a default value if null
  }
  return (percentage / 100) * total_amount;
}

double remainAmount(int? percentage, int? total_amount) {
  if (percentage == null || total_amount == null) {
    return 0.0;
  }

  return total_amount - downPayment(percentage, total_amount);
}

double mweziPayment(int? percentage, int? total_amount, int? duration) {
  if (percentage == null || total_amount == null || duration == null) {
    return 0.0;
  }
  return remainAmount(percentage, total_amount) / duration;
}

String formatAmount(int? amount, {int decimalPlaces = 0}) {
  // Create a NumberFormat instance for formatting
  final formatter = NumberFormat.currency(
    locale: 'sw_TZ', // Change to your locale if needed
    symbol: '', // Leave empty for no currency symbol
    decimalDigits: decimalPlaces,
  );

  // Format the given amount
  return formatter.format(amount);
}

String phoneFormat(String? phone) {
  if (phone == null || phone.length < 12 || !phone.startsWith('255')) {
    throw ArgumentError('Invalid phone number format');
  }

  // Replace '255' with '0'
  return '0${phone.substring(3)}';
}

String toInternationalFormat(String? phone) {
  if (phone == null || phone.length < 10 || !phone.startsWith('0')) {
    throw ArgumentError('Invalid phone number format');
  }

  // Remove the leading '0' and add '255'
  return '255${phone.substring(1)}';
}

double dailyPayment(double monthlyPayment) {
  // Get the current month and year
  DateTime today = DateTime.now();
  // int daysInMonth = DateTime(today.year, today.month + 1, 0).day;
  int daysInMonth = 30;

  // Calculate daily payment
  double daily = monthlyPayment / daysInMonth;

  // Custom rounding logic: Always round up to the next hundred
  int roundedPayment = ((daily / 100).ceil()) * 100;

  return roundedPayment.toDouble();
}

Future<File> fromAsset(String asset, String filename) async {
  // To open from assets, you can copy them to the app storage folder, and the access them "locally"
  Completer<File> completer = Completer();

  try {
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$filename");
    var data = await rootBundle.load(asset);
    var bytes = data.buffer.asUint8List();
    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
  } catch (e) {
    throw Exception('Error parsing asset file!');
  }

  return completer.future;
}

Future<void> delayedNavigatorPop(BuildContext context, int milliseconds) async {
  await Future.delayed(Duration(milliseconds: milliseconds));
  Navigator.pop(context);
}

double percentage(double remainAmount, double totalAmount) {
  return double.parse((remainAmount / totalAmount).toStringAsFixed(2));

}

String formatPhoneNumber(String phoneNumber) {
  if (phoneNumber.startsWith('0')) {
    return '255${phoneNumber.substring(1)}';
  }
  return phoneNumber;
}

String? calculateEndDate(String? startDate) {
  if (startDate == null || startDate.isEmpty) return null;

  try {
    // Parse the start date
    DateTime parsedStartDate = DateTime.parse(startDate);

    // Add 90 days to the start date
    DateTime endDate = parsedStartDate.add(Duration(days: 90));

    // Format the end date as a string (adjust format if needed)
    return '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
  } catch (e) {
    // Handle invalid date formats
    return null;
  }
}


// const MethodChannel _channel = MethodChannel('com.humtech.shirikisho3/dev_mode');

// //  open settings menu
// Future<void> openSettings() async {
//   try {
//     if (Platform.isAndroid) {
//       await _channel.invokeMethod('openSettings');
//     } else {
//       SystemNavigator.pop();
//     }
//   } on PlatformException catch (e) {
//     print('Failed to open settings: $e');
//     SystemNavigator.pop();
//   }
// }