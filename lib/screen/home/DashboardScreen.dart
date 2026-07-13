import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/screen/home/ChatScreen.dart';
import 'package:shirikisho/screen/home/PaymentScreen.dart';
import 'package:shirikisho/screen/home/ServicesScreen.dart';
import 'package:shirikisho/screen/home/HomeScreen.dart';
import 'package:shirikisho/utils/WAColors.dart';

import '../../model/drivers_modules.dart';
import 'package:upgrader/upgrader.dart';

class WADashboardScreen extends StatefulWidget {
  static String tag = '/WADashboardScreen';

  @override
  WADashboardScreenState createState() => WADashboardScreenState();
}

class WADashboardScreenState extends State<WADashboardScreen> {
  int _selectedIndex = 0;
  var _pages = <Widget>[
    WAHomeScreen(),
    ServicesScreen(),
    // PaymentScreen(),
    ChatScreen(),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // await loadGroups();
    // await loadPosts(null);
    // await loadOnlineConversation();
    await loadOfficers();
    // await loadAllDrivers();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      barrierDismissible: false,
      showLater: true,
      showIgnore: true,
      dialogStyle: Platform.isIOS
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      upgrader: Upgrader(
        // debugDisplayAlways: true,
        debugLogging: true,
        durationUntilAlertAgain: const Duration(days: 1),
        countryCode: 'TZ',
        messages: UpgraderMessages(
          code:
              'A new version of the app is available. Please update to enjoy the latest features and improvements.',
        ),
      ),
      child: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          body: _pages.elementAt(_selectedIndex),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton: Padding(
            padding: EdgeInsets.all(6.0),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            clipBehavior: Clip.antiAlias,
            child: BottomNavigationBar(
              backgroundColor: context.cardColor,
              currentIndex: _selectedIndex,
              onTap: (index) {
                if (index == 4) {
                  toasty(context, 'Coming Soon');
                } else {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: WAPrimaryColor,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 20,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Symbols.spoke_rounded,
                      size: 20,
                    ),
                    label: 'Statistics'),
                // BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.message,
                      size: 20,
                    ),
                    label: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
