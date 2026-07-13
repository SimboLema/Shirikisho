import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/screen/bima/ChoosePlanScreen.dart';
import 'package:shirikisho/services/get_apis.dart';

import '../../main.dart';
import '../../screen/home/PaymentScreen.dart';
import '../../screen/services/VaziMaipoScreen.dart';
import '../../utils/WAColors.dart';
import '../../utils/styles.dart';

class PataBimaDialog extends StatefulWidget {
  static String tag = '/PataBimaDialog';

  PataBimaDialog({super.key});

  @override
  PataBimaDialogState createState() => PataBimaDialogState();
}

class PataBimaDialogState extends State<PataBimaDialog> {
  var phoneFormatter = MaskTextInputFormatter(
    mask: '#### ### ###',
    filter: {"#": RegExp(r'[0-9]'), "X": RegExp(r'[A-Z]')},
    type: MaskAutoCompletionType.lazy,
  );

  final KishoStyles appStyles = KishoStyles();
  final GetMainApis _getMainApis = GetMainApis();

  var _loadingLicense = 0; // 0: In Progress, 1: Success, 2: Failed
  var _licenseStatus = '';
  String _errorText = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  // Initialize the process by checking the license status
  init() async {
    await checkLicense();
  }

  void verifyAll() {
    List _loaders = [_loadingLicense];

    if (_loaders.contains(0) || _loaders.contains(2)) {
      log('Badoo');
    } else {
      log('Tayariiii');
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 16.0),
              Text("Tafadhali Subiri", style: boldTextStyle(size: 20, color: WAPrimaryColor), textAlign: TextAlign.center),
              SizedBox(height: 16.0),
              Divider(),
              SizedBox(height: 16.0),
              checkItems('Leseni Halali', 1, _licenseStatus),
              errWigFun(_errorText),
              const SizedBox(height: 24.0),
              LipaBili(),
            ],
          ),
        ),
      ),
    );
  }

  Widget errWigFun(String erv) {
    if (erv != '') {
      return Column(
        children: [
          Text(
            erv,
            textAlign: TextAlign.center,
            style: TextStyle(color: WAPrimaryColor, fontSize: 14),
          ),
          const SizedBox(height: 10),
        ],
      );
    }
    return const SizedBox();
  }

  Widget checkItems(String item, int code, String loaderStatusMessage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 16),
            SizedBox(
              height: 20.0,
              width: 20,
              child: _loaderStatus(code),
            ),
            SizedBox(width: 16),
            Text(item, style: primaryTextStyle(color: appStore.textPrimaryColor, size: 16)),
          ],
        ),
      ],
    );
  }

  Future<void> checkLicense() async {
    var response = await _getMainApis.verifyLicense();

    // Check if response status is true or false
    if (response[0] == 200 && response[1] == true) {
      setState(() {
        _licenseStatus = "Success";
        _loadingLicense = 1; // Status 'Success' is mapped to 1
      });
    } else {
      setState(() {
        _licenseStatus = "Failed";
        _loadingLicense = 2; // Status 'Failed' is mapped to 2
      });
    }

    // Debugging log to verify the value of _loadingLicense
    log('_loadingLicense value after checkLicense: $_loadingLicense');

    // Only verify all checks after updating the license status
    verifyAll();
  }

  Widget _loaderStatus(int code) {
    int _currentLoader;
    switch (code) {
      case 1:
        _currentLoader = _loadingLicense;
        break;
      default:
        _currentLoader = 0;
    }

    if (_currentLoader == 0) {
      return CircularProgressIndicator(
        backgroundColor: Color(0xffD6D6D6),
        strokeWidth: 4,
        valueColor: AlwaysStoppedAnimation<Color>(WAPrimaryColor),
      );
    } else if (_currentLoader == 2) {
      return Icon(Icons.close, color: Colors.red);
    } else {
      return Icon(Icons.check, color: WAPrimaryColor);
    }
  }

  Widget LipaBili() {
    // Show the appropriate UI based on the status of _loadingLicense
    if (_loadingLicense == 0) {
      return Text('Inahakiki ...'); // Verification in progress
    } else if (_loadingLicense == 2) {
      return Container(
        // child: ElevatedButton(
        //   onPressed: () {
        //     setState(() {
        //       _errorText = 'Leseni yako haikupatikana. Tafadhali jaribu tena.';
        //     });
        //   },
        //   style: appStyles.defaultButtonStyles().copyWith(
        //     minimumSize: const MaterialStatePropertyAll(Size(double.maxFinite, 45)),
        //   ),
        //   child: const Text('Jaribu tena'),
        // ),
      ); // Show nothing if verification failed
    } else if (_loadingLicense == 1) {
      return ElevatedButton(
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => ChoosePlanScreen(),
          );
        },
        style: appStyles.defaultButtonStyles().copyWith(
          minimumSize: const MaterialStatePropertyAll(Size(double.maxFinite, 45)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pata Bima'),
            SizedBox(width: 10),
            Icon(Icons.east_rounded),
          ],
        ),
      );
    } else {
      return Container(); // Default case if none of the conditions match
    }
  }
}
