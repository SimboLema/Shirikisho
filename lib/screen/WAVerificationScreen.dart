import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shirikisho/utils/WAColors.dart';

import '../main.dart';
import '../services/auth_service.dart';
import '../services/show_alert.dart';
import 'home/DashboardScreen.dart';

class WAVerificationScreen extends StatefulWidget {
  static String tag = '/WAVerificationScreen';

  @override
  WAVerificationScreenState createState() => WAVerificationScreenState();
}

class WAVerificationScreenState extends State<WAVerificationScreen> {
  late String verificationCode = '';

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
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
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
                'Ingiza OTP',
                style: boldTextStyle(size: 20, color: black),
                textAlign: TextAlign.center,
              ),
              16.height,
              Text(
                'Tumetuma OTP code ya tarakimu 6 tafadhali ingiza hapo chini',
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
                        autoFocus: true,
                        enablePinAutofill: true,
                        keyboardType: TextInputType.number,
                        enableActiveFill: true,
                        animationType: AnimationType.fade,
                        animationDuration: Duration(milliseconds: 300),
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
                  Text('Haukupata Code?', style: secondaryTextStyle(color: gray)),
                  4.width,
                  Text('Tuma Tena OTP', style: boldTextStyle(color: WAPrimaryColor), textAlign: TextAlign.center),
                ],
              ),
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
                      _onVerifyOTPLoader();
                      final message = await authService.verifyOTP(verificationCode);
                      if (message == true) {
                        log('registered');
                        WADashboardScreen().launch(context);
                      } else {
                        Navigator.of(context).pop();
                        showAlert(context, 'Error!',message);
                      }
                    }),
              ),
            ],
          ).paddingAll(30),
        ),
      ),
    );
  }


  void _onVerifyOTPLoader() {
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
}
