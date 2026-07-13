import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/component/Loader.dart';
import 'package:shirikisho/screen/bima/ChoosePlanScreen.dart';
import 'package:shirikisho/screen/bima/PataBimaDialog.dart';
import 'package:shirikisho/screen/bima/components/bimacart.dart';
import 'package:shirikisho/services/auth_service.dart';
// import 'package:shirikisho/screen/bima/components/paymentPlanOption.dart';
import 'package:shirikisho/utils/WAColors.dart';

import '../../main.dart';
// import 'package:payment_card/payment_card.dart';

class NoChatsScreen2 extends StatefulWidget {
  const NoChatsScreen2({Key? key}) : super(key: key);

  @override
  _NoChatsScreen2State createState() => _NoChatsScreen2State();
}

class _NoChatsScreen2State extends State<NoChatsScreen2> {
  var feedback = false;
  var status;
  late AuthService authService;
  // late MKopoData vehicledata;
  var userName = "";
  var userPhone = "";
  var userJacket = "";
  var userImage = "";
  var isAdmin = false;
  var userId = "";
  var avatar = "/office/media/avatars/300-1.jpg";

  final _storage = const FlutterSecureStorage();
  bool isLoading = false;

  Future<void> getUserData() async {
    authService.getUser();

    var user_id = await _storage.read(key: 'user_id');
    var name = await _storage.read(key: 'full_name');
    var phone = await _storage.read(key: 'user_phone');
    var uniform = await _storage.read(key: 'user_uniform_number');
    var image = await _storage.read(key: 'user_image');
    var isLeader = await _storage.read(key: 'user_is_leader');

    setState(() {
      userId = user_id!;
      userName = name!;
      userPhone = phone!;
      userImage = image!;
      userJacket = uniform!;
      isAdmin = isLeader! == 'true' ? true : false;
    });
  }

  Future<Map<String, dynamic>> fetchData() async {
    const _storage = FlutterSecureStorage();

    var token = await _storage.read(key: 'token');
    var name = await _storage.read(key: 'full_name');

    userName = name!;

    try {
      var response = await http.get(
          Uri.parse(
              'https://mfumo.shirikisho.co.tz/api/bima/sanlam/user/latest-package/subscription'),
          headers: <String, String>{'Authorization': 'Bearer $token'});
      if (response.statusCode == 200 || response.statusCode == 201) {
        var body = jsonDecode(response.body);
        // print('body: ${body}');

        // print("function 2");
        var res = await http.post(
            Uri.parse(
                'https://mfumo.shirikisho.co.tz/api/check_bima_status_any_time'),
            body: {
              "package_id": body['data']['bima_package_id'].toString(),
              "user_id": body['data']['user_id'].toString()
            },
            headers: <String, String>{
              'Authorization': 'Bearer $token'
            });
        // print("res : ${res.body}");

        var body2 = jsonDecode(res.body);

        // print('body2: ${body2}');

        if (body2['active_bima'] == null && body2['latest_bima'] != null) {
          return {
            'status': true,
            'data': body2['latest_bima'],
            "payment": false
          };
        } else if (body2['active_bima'] != null &&
            body2['latest_bima'] != null) {
          return {
            'status': true,
            'data': body2['active_bima'],
            "payment": true
          };
        } else {
          return {'status': false, 'data': "No data found", "payment": false};
        }

        // return {'status': true, 'data': body, "payment": body2['status']};
        // return {'status': true, 'data': body, "payment": true};
      } else {
        return {'status': false, 'data': response.body};
      }
    } catch (error) {
      return {'status': 'error', 'data': error.toString()};
    }
  }

  @override
  void initState() {
    super.initState();
    authService = AuthService(); // Ensure it's initialized
    getUserData();

    fetchData();
  }

  @override
  void dispose() {
    setStatusBarColor(appStore.scaffoldBackground!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Bima',
          textScaler: TextScaler.noScaling,
          style: boldTextStyle(color: Colors.black, size: 20),
        ),
        centerTitle: true,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Icon(Icons.arrow_back),
        ).onTap(() {
          finish(context);
        }),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(), // Fetch data from the API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while waiting for data

            return customLoader(context);
          } else if (snapshot.hasError) {
            // Display an error message if an error occurred
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final result = snapshot.data!;

            if (result['status'] == true) {
              // If status is true, show the card with subscription details
              var subscriptionData = result['data'];

              status = result['payment']; // Payment status: true or false

              DateTime created_at =
                  DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'")
                      .parseUtc(subscriptionData['created_at'])
                      .toLocal();
              // Get the current time
              DateTime currentTime = DateTime.now();

// Calculate the difference in minutes
              Duration difference = currentTime.difference(created_at);

              bool isMoreThanFiveMinutes = difference.inMinutes > 0;

              return Container(
                height: context.height(),
                width: context.width(),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/walletApp/wa_bg.jpg'),
                    fit: BoxFit.cover,
                    opacity: 0.9,
                  ),
                  color: Colors.black,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: context.height() * 0.1,
                      ),
                      //
                      SizedBox(
                        height: 20,
                      ),
                      PaymentCard(
                        backgroundColor: Colors.white,
                        backgroundImage: "",
                        currency: subscriptionData['bima_package_id'] == 1
                            ? "Silver"
                            : "Gold",
                        cardNumber: "cardNumber",
                        validity: subscriptionData['end_date'],
                        start: subscriptionData['start_date'],
                        holder: userName,
                        title: "BODASURE",
                        colors: subscriptionData['bima_package_id'] == 1
                            ? Colors.grey.withOpacity(0.9)
                            : Colors.amber.withOpacity(0.9),
                        status: status,
                        statusAppear: true,
                        imagePkg:
                            subscriptionData['bima_package_id'].toString(),
                        userProfile: userImage,
                        companyLogo: "assets/bima/sanlam.png",
                        companyLogo2: "",
                        secondComp: false,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      status
                          ? Container()

                          // PARENTAL WIDGET FIX
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(context.width() * 0.36,
                                            context.height() * 0.05),
                                        backgroundColor: WAPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      onPressed: () {
                                        fetchData()
                                            .then((_) => setState(() {}));
                                      },
                                      child: Center(
                                        child: Text(
                                          "Hakiki Muamala",
                                          textScaler: TextScaler.noScaling,
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  20.width,
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(context.width() * 0.36,
                                            context.height() * 0.05),
                                        backgroundColor: WAPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChoosePlanScreen()),
                                        );
                                      },
                                      child: Center(
                                        child: Text(
                                          "Lipia Tena",
                                          textScaler: TextScaler.noScaling,
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              );
            } else {
              return _buildNoInsuranceMessage(context);
            }
          } else {
            return _buildNoInsuranceMessage(context);
          }
        },
      ),
    );
  }

// Helper method to build the "Hauna Bima" message
  Widget _buildNoInsuranceMessage(BuildContext context) {
    return Container(
      height: context.height(),
      width: context.width(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/walletApp/wa_bg.jpg'),
          fit: BoxFit.cover,
          opacity: 0.9,
        ),
        color: Colors.black,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            60.height,
            Image.asset(
              'assets/bima/no ins.png',
              height: 150,
            ),
            32.height,
            Text('Hauna Bima!',
                textScaler: TextScaler.noScaling,
                style: boldTextStyle(size: 20)),
            16.height,
            Text(
              'Hauna Bima ya Afya, Tafadhali omba bima.',
              textScaler: TextScaler.noScaling,
              style: secondaryTextStyle(),
              textAlign: TextAlign.center,
            ).paddingSymmetric(vertical: 8, horizontal: 60),
            50.height,
            AppButton(
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(30)),
              color: WAPrimaryColor,
              elevation: 10,
              onTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => PataBimaDialog(),
                );
              },
              child: Text('Omba Bima',
                      textScaler: TextScaler.noScaling,
                      style: boldTextStyle(color: Colors.white))
                  .paddingSymmetric(horizontal: 32),
            ),
          ],
        ).paddingAll(30),
      ),
    );
  }

  // Future<void> openExternalBrowser(String webUrl) async {
  //   final Uri url = Uri.parse(webUrl);
  //   if (!await launchUrl(
  //     url,
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     throw 'Could not launch $url';
  //   }
  // }
}
