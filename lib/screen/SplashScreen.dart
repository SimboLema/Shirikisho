import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gif_view/gif_view.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shirikisho/model/user_model.dart';
import 'package:shirikisho/screen/home/DashboardScreen.dart';
import 'package:shirikisho/screen/LoginScreen.dart';
import 'package:shirikisho/screen/WalkThroughScreen.dart';
import 'package:shirikisho/services/user_service.dart';
import 'package:shirikisho/utils/WAColors.dart';

import '../services/auth_service.dart';


class WASplashScreen extends StatefulWidget {
  static String tag = '/WASplashScreen';

  @override
  WASplashScreenState createState() => WASplashScreenState();
}

class WASplashScreenState extends State<WASplashScreen> {
  late UserModule selectedCard ;
  late AuthService authService;

  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    authService = Provider.of<AuthService>(context, listen: false);
    checkLoginState(context);
    init();
  }

  Future<void> init() async {
    setStatusBarColor(WAPrimaryColor, statusBarIconBrightness: Brightness.light);
    await Future.delayed(Duration(seconds: 3));
    if (mounted) finish(context);
    // WADashboardScreen().launch(context);
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.white, statusBarIconBrightness: Brightness.dark);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appBackgroundColorBlack,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GifView.asset(
              'assets/images/spashgif.gif',
            ).center(),
          ],
        ),
      ),
    );
  }

    Future checkLoginState(BuildContext context) async {
    log('Check Login');


    final authService = Provider.of<AuthService>(context, listen: false);

    // final uerService = Provider.of<UserService>(context, listen: false);

    final auth = await authService.logged();

    if (auth == true) {
      // final user = await uerService.getUser();
      await authService.connectPusher();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => WADashboardScreen(),
        ),
            (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => WALoginScreen(),
        ),
            (route) => false,
      );
    }
  }
}
