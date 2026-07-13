import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:shirikisho/utils/WAWidgets.dart';

import '../global/environment.dart';
import '../main.dart';
import '../services/auth_service.dart';
import 'LoginScreen.dart';

class WAMyProfileScreen extends StatefulWidget {
  static String tag = '/WAMyProfileScreen';

  @override
  WAMyProfileScreenState createState() => WAMyProfileScreenState();
}

class WAMyProfileScreenState extends State<WAMyProfileScreen> {
  late AuthService authService;
  var profileImage = "";
  var userName = "";
  var userImage = "";
  var phone = "";
  var avatar = "/office/media/avatars/300-1.jpg";
  bool? isDarkMode = true;

  @override
  void initState() {
    authService = Provider.of<AuthService>(context, listen: false);
    getUserData();

    super.initState();
    init();
  }

  init() async {
    //
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
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Akaunti Yangu',
              style: boldTextStyle(color: Colors.black, size: 20)),
          leading: Container(
            margin: EdgeInsets.all(8),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: context.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Icon(Icons.arrow_back,
                color: appStore.isDarkModeOn ? white : black),
          ).onTap(() {
            finish(context);
          }),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Container(
          height: context.height(),
          width: context.width(),
          padding: EdgeInsets.only(top: 60),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/walletApp/wa_bg.jpg'),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                waCommonCachedNetworkImage(
                  '${Environment.imageUrl}/$userImage',
                  fit: BoxFit.cover,
                  height: 120,
                  width: 120,
                ).cornerRadiusWithClipRRect(60),
                16.height,
                Text(userName, style: boldTextStyle()),
                Text(phone, style: secondaryTextStyle()),
                16.height,
                // SettingItemWidget(
                //     title: 'Edit Profile',
                //     decoration: boxDecorationRoundedWithShadow(12, backgroundColor: context.cardColor),
                //     trailing: Icon(Icons.arrow_right, color: grey.withOpacity(0.5)),
                //     onTap: () {
                //       WAEditProfileScreen(isEditProfile: true).launch(context);
                //     }),
                // 16.height,
                // SettingItemWidget(
                //     title: 'Manage Wallet',
                //     decoration: boxDecorationRoundedWithShadow(12, backgroundColor: context.cardColor),
                //     trailing: Icon(Icons.arrow_right, color: grey.withOpacity(0.5)),
                //     onTap: () {
                //       //
                //     }),
                // 16.height,
                // SettingItemWidget(
                //     title: 'Transaction History',
                //     decoration: boxDecorationRoundedWithShadow(12, backgroundColor: context.cardColor),
                //     trailing: Icon(Icons.arrow_right, color: grey.withOpacity(0.5)),
                //     onTap: () {
                //       //
                //     }),
                // 16.height,
                // SettingItemWidget(
                //     title: 'Settings',
                //     decoration: boxDecorationRoundedWithShadow(12, backgroundColor: context.cardColor),
                //     trailing: Icon(Icons.arrow_right, color: grey.withOpacity(0.5)),
                //     onTap: () {
                //       //
                //     }),
                // 16.height,
                // SettingItemWidget(
                //     title: 'Dark Mode',
                //     decoration: boxDecorationRoundedWithShadow(12, backgroundColor: context.cardColor),
                //     trailing: Switch(
                //       value: appStore.isDarkModeOn,
                //       activeColor: appColorPrimary,
                //       onChanged: (s) {
                //         appStore.toggleDarkMode(value: s);
                //       },
                //     ),
                //     onTap: () {
                //       //
                //     }),
                SettingItemWidget(
                    title: 'Delete Account',
                    decoration: boxDecorationRoundedWithShadow(12,
                        backgroundColor: context.cardColor),
                    trailing:
                        Icon(Icons.arrow_right, color: grey.withOpacity(0.5)),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (builder) {
                            return notifyDialog();
                          });
                    }),
                SettingItemWidget(
                    title: 'Logout',
                    decoration: boxDecorationRoundedWithShadow(12,
                        backgroundColor: context.cardColor),
                    trailing:
                        Icon(Icons.arrow_right, color: grey.withOpacity(0.5)),
                    onTap: () {
                      authService.logout();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WALoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    }),
                16.height,
              ],
            ).paddingAll(16),
          ),
        ),
      ),
    );
  }

  Future<void> getUserData() async {
    setState(
      () {
        userName = authService.user.firstName!;
        userImage = authService.user.imageId!;
        phone = authService.user.phoneNumber!;

        log(userImage);
      },
    );
  }

  Widget notifyDialog() {
    return StatefulBuilder(
      builder: (Builder, setState) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 1.0,
          child: Container(
            decoration: BoxDecoration(
              // color: context.scaffoldBackgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              // boxShadow: defaultBoxShadow(),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        'Are you sure you want to delete your account?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Your information will be deleted totally including your booking and appointment, and you will have to create new account.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: WAPrimaryColor,
                            ),
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => LoginScreen()),
                              // );
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: WAPrimaryColor,
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              // Navigator.pop(context);
                              authService.logout();

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WALoginScreen()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text(
                              'Delete Account',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
