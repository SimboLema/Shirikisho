import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        _updateConnectionStatus(results.first);
      }
    });
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    // launch snackbar when there is no netowkr connectivity
    if (connectivityResult == ConnectivityResult.none) {
      Get.rawSnackbar(
        isDismissible: false,
        duration: Duration(days: 1),
        titleText: Text(
          'No Internet Connection',
          textScaler: TextScaler.noScaling,
          style: boldTextStyle(size: 14, color: Colors.white),
        ),
        messageText: Text(
          "Please check your internet connection and try again",
          textScaler: TextScaler.noScaling,
          style: primaryTextStyle(size: 12, color: Colors.white),
        ),
        icon: Icon(
          Icons.wifi_off,
          color: Colors.white,
        ),
        snackStyle: SnackStyle.GROUNDED,
        shouldIconPulse: true,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        margin: EdgeInsets.zero,
      );
    } else {
      // to close snackbar once the network is restored
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
