import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shirikisho/component/PermissionExplanationDialog.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:shirikisho/utils/WAWidgets.dart';

import '../main.dart';
import '../services/auth_service.dart';
import '../services/show_alert.dart';
import 'WAVerificationScreen.dart';
import 'home/DashboardScreen.dart';

class WALoginScreen extends StatefulWidget {
  static String tag = '/WALoginScreen';

  @override
  WALoginScreenState createState() => WALoginScreenState();
}

class WALoginScreenState extends State<WALoginScreen> {
  var phoneNumberController = TextEditingController();
  var passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();

  var phoneFormatter = new MaskTextInputFormatter(
      mask: '#### ### ###',
      filter: {"#": RegExp(r'[0-9]'), "X": RegExp(r'[A-Z]')},
      type: MaskAutoCompletionType.lazy);

  bool _phoneError = false;
  bool _passError = false;
  bool _logeando = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  // Future<void> init() async {
  //   passwordController.text = 'password12345';

  // await FirebaseMessaging.instance.requestPermission(provisional: true);

  // }
  Future<void> init() async {
    passwordController.text = 'password12345';

    // Request permission
    // await FirebaseMessaging.instance.requestPermission(provisional: true);

    // Check if notification permission is granted
    PermissionStatus permissionStatus = await Permission.photos.status;

    if (!permissionStatus.isGranted) {

      // print("Permission not granted :: $permissionStatus"); 

      // If permission is not granted, show dialog
      // _showPermissionDialog();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // onWillPop: () async => false,
      //  canPop: true,
       onPopInvoked: (didPop) {
        //  Navigator.pop(context);

       },
      child: Scaffold(
        body: Container(
          width: context.width(),
          height: context.height(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/walletApp/wa_bg.jpg'),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                150.height,
                Text("Ingia",
                    textScaler: TextScaler.noScaling,
                    style: boldTextStyle(size: 24, color: black)),
                Container(
                  margin: EdgeInsets.all(16),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        width: context.width(),
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        margin: EdgeInsets.only(top: 55.0),
                        decoration: boxDecorationWithShadow(
                            borderRadius: BorderRadius.circular(30),
                            backgroundColor: context.cardColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text("Namba ya simu",
                                      textScaler: TextScaler.noScaling,
                                      style: boldTextStyle(
                                          size: 14, color: WAPrimaryColor)),
                                  8.height,
                                  AppTextField(
                                    decoration: waInputDecoration(
                                        hint: '0765 *** ***',
                                        prefixIcon: Icons.phone),
                                    textFieldType: TextFieldType.PHONE,
                                    keyboardType: TextInputType.phone,
                                    textStyle: primaryTextStyle(
                                        color: _phoneError
                                            ? Colors.red
                                            : WAPrimaryColor),
                                    controller: phoneNumberController,
                                    focus: emailFocusNode,
                                    nextFocus: passWordFocusNode,
                                    inputFormatters: [phoneFormatter],
                                    onChanged: (text) {
                                      setState(
                                        () {
                                          _phoneError = false;
                                        },
                                      );
                                    },
                                    onTap: () {
                                      setState(
                                        () {
                                          _phoneError = false;
                                        },
                                      );
                                    },
                                  ),
                                  16.height,
                                  // Text("Password", style: boldTextStyle(size: 14, color: WAPrimaryColor)),
                                  // 8.height,
                                  // AppTextField(
                                  //   decoration: waInputDecoration(hint: '********', prefixIcon: Icons.lock_outline),
                                  //   suffixIconColor: _passError ? Colors.red : WAPrimaryColor,
                                  //   textFieldType: TextFieldType.PASSWORD,
                                  //   textStyle: primaryTextStyle(color: WAPrimaryColor),
                                  //   isPassword: true,
                                  //   keyboardType: TextInputType.visiblePassword,
                                  //   controller: passwordController,
                                  //   focus: passWordFocusNode,
                                  //   onChanged: (text) {
                                  //     setState(() {
                                  //         _passError = false;
                                  //       },
                                  //     );
                                  //   },
                                  //   onTap: () {
                                  //     setState(() {
                                  //         _passError = false;
                                  //       },
                                  //     );
                                  //   }
                                  // ),
                                  16.height,
                                  Align(
                                    alignment: Alignment.centerRight,
                                    // child: Text("Forgot password?", style: primaryTextStyle()),
                                  ),
                                  30.height,
                                  btnNLoader(_logeando, context),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 100,
                        width: 100,
                        decoration: boxDecorationRoundedWithShadow(30,
                            backgroundColor: context.cardColor),
                        child: Image.asset(
                          'assets/images/logo2.png',
                          height: 100,
                          width: 100,
                          // color: appStore.isDarkModeOn ? black : white,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                ),
                16.height,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget btnNLoader(bool lder, BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    if (lder) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      );
    }

    return AppButton(
            text: "Ingia",
            color: WAPrimaryColor,
            textColor: Colors.white,
            shapeBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            width: context.width(),
            onTap: () async {
              if (validate() == true) {
                _onHorizontalLoading1();

                FocusScope.of(context).unfocus();
                final loginOK = await authService.login(
                    phoneNumberController.text.replaceAll(' ', ''),
                    passwordController.text.trim());

                // print("Login response $loginOK");
                if (loginOK == true) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WADashboardScreen(),
                    ),
                    (route) => false,
                  );
                } else if (loginOK == 'verify_otp') {
                  Navigator.of(context).pop();
                  WAVerificationScreen().launch(context);
                } else {
                  Navigator.of(context).pop();
                  // passwordController.clear();
                  showAlert(context, 'Namba Haijasajiliwa',
                      'Tafadhali wasiliana na kiongozi wako wa kituo kwa usajili.');
                }
                ;
              }
            })
        .paddingOnly(left: context.width() * 0.1, right: context.width() * 0.1);
  }

  validate() {
    var phoneNumber = phoneNumberController.text.replaceAll(' ', '');
    if (phoneNumber.length < 10) {
      setState(
        () {
          _phoneError = true;
        },
      );
      return false;
    }

    if (passwordController.text.length == 0) {
      setState(
        () {
          _passError = true;
        },
      );
      return false;
    }

    return true;
  }

  void _onHorizontalLoading1() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                  textScaler: TextScaler.noScaling,
                  style: primaryTextStyle(color: appStore.textPrimaryColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showPermissionDialog() async {
    //  await FirebaseMessaging.instance
    //     .requestPermission(provisional: true);
    showDialog(
      context: context,
      builder: (context) {
        return summaryExplanationDialog();
      },
    );
  }

  
}
