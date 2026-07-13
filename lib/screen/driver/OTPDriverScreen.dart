import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shirikisho/screen/driver/RegisterDriverScreen.dart';
import 'package:shirikisho/screen/home/HomeScreen.dart';
import 'package:shirikisho/utils/WAColors.dart';

import '../../main.dart';
import '../../model/drivers_modules.dart';
import '../../services/auth_service.dart';
import '../../services/post_apis.dart';
import '../home/DashboardScreen.dart';

class OTPDriverScreen extends StatefulWidget {
  static String tag = '/OTPDriverScreen';



  @override
  OTPDriverScreenState createState() => OTPDriverScreenState();
}

class OTPDriverScreenState extends State<OTPDriverScreen> {
  late String verificationCode = '';

  String _errorText = '';

  final TextEditingController _verificationCodeController = TextEditingController();


  final PostMainApis postMainApis = PostMainApis();
  final _storage = const FlutterSecureStorage();

  Timer? _timer;
  int _start = 60;


  @override
  void initState() {
    super.initState();
    startTimer();
    init();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
    final authService = Provider.of<AuthService>(context);



    return WillPopScope(
      onWillPop: () async {
        return Navigator.canPop(context);
      },
      child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: context.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Icon(Icons.arrow_back, color: appStore.isDarkModeOn ? white : black),
        ).onTap(() {
          finish(context);
          WADashboardScreen().launch(context);
        }),
      ),
      body: Container(
        height: context.height(),
        width: context.width(),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/walletApp/wa_bg.jpg'), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              30.height,
              Image.asset(
                'assets/images/intro.png',
              ),
              8.height,
              Text(
                'Sajili Dereva',
                style: boldTextStyle(size: 20, color: black),
                textAlign: TextAlign.center,
              ),
              16.height,
              Text(
                'Tumetuma OTP code ya namba sita kwenda namba ya dereva. Tafadhali ingiza namba hiyo kuhakiki namba ya dereva.',
                style: secondaryTextStyle(color: gray),
                textAlign: TextAlign.center,
              ),
              30.height,
              Wrap(
                children: [
                  SizedBox(
                      height: 60,
                      width: context.width(),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: _verificationCodeController,
                        keyboardType: TextInputType.number,
                        enableActiveFill: true,
                        autovalidateMode: AutovalidateMode.disabled,
                        onChanged: (value) {
                          setState(() {
                            verificationCode = value;
                          });
                        },
                        useHapticFeedback: true,
                        // #
                        pinTheme: PinTheme(
                            inactiveColor: WAPrimaryColor,
                            inactiveFillColor: const Color(0x1A505F79),
                            activeColor: WAPrimaryColor,
                            selectedColor: Banking_TextLightGreenColor,
                            selectedFillColor: Colors.grey.shade100,
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(4),
                            fieldHeight: 50,
                            fieldWidth: 45,
                            activeFillColor: const Color.fromARGB(255, 255, 255, 255)),
                      )
              ),
                ],
              ),
              16.height,
              Row(
                //    mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Hajapata OTP?', style: secondaryTextStyle(color: gray)),
                  4.width,

                  _tryText(),
                ],
              ),
              16.height,
              errWigFun(_errorText),
              16.height,
              SizedBox(
                width: context.width() * 0.5,
                child: AppButton(
                    text: "Hakiki",
                    color: WAPrimaryColor,
                    textColor: Colors.white,
                    shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    width: context.width(),
                    onTap: () async {
                      _loader();
                      FocusScope.of(context).unfocus();

                      final message = await authService.verifyOTPDriver(verificationCode);
                      if (message == true) {
                        Navigator.of(context).pop();
                        FocusScope.of(context).unfocus();
                        RegisterDriverScreen().launch(context);
                      } else {
                        Navigator.of(context).pop();
                        showAlert(context, 'Error!',"Umekosea OTP");
                      }
                    }),
              ),
            ],
          ).paddingAll(30),
        ),
      ),
    ),
    );
  }

  void _loader() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: context.scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                children: [
                  16.width,
                  CircularProgressIndicator(
                    backgroundColor: Color(0xffD6D6D6),
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                  ),
                  16.width,
                  Text(
                    "Tafadhali Subiri....",
                    style: primaryTextStyle(color: appStore.textPrimaryColor),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

  _tryText(){
    const oneSec = const Duration(seconds: 1);

    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );

    if(_start > 0){
      return Text('Jaribu tena Baada ya $_start', style: secondaryTextStyle(color: gray));
    }else{
      return Text('Tuma Tena', style: boldTextStyle(color: WAPrimaryColor), textAlign: TextAlign.center)
          .onTap(() async {
        _loader();
        startTimer();
        var phone = await _storage.read(key: 'driver_phone');
        DriverPhoneVerificationResponseModule resp = await postMainApis.sendDriverPhoneForverification('$phone');

        if (resp.state != 'success') {
          setState(() {
            Navigator.of(context).pop();
            showAlert(context, 'Error!',resp.data);
            _start = 60;
          });
          return 0;
        }

        setState(() {
            _start = 60;
            _errorText = "Umekosea OTP";
            log(_errorText);
          });



        Navigator.of(context).pop();


      });
    }
  }

  void startTimer() {
  const oneSec = const Duration(seconds: 10);
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    },
  );
}

Widget errWigFun(String erv) {
    if (erv != '') {
      return Column(
        children: [
          Text(
            erv,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red, fontSize: 14),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    }
    return const SizedBox();
  }

  showAlert(BuildContext context, String title, String subtitle) {
  if (kIsWeb || Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(subtitle),
              actions: [
                MaterialButton(
                  elevation: 5,
                  textColor: Colors.green,
                  onPressed: () {
                    _verificationCodeController.clear;
                    Navigator.pop(context);
                  },
                  child: const Text('Sawa'),
                )
              ],
            ));
  }

  showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(subtitle),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              )
            ],
          ));
}

}
