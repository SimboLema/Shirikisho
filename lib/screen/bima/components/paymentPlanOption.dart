// payment_options_dialog.dart

// ignore_for_file: dead_code

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/global/environment.dart';
import 'package:shirikisho/services/auth_service.dart';
import 'package:shirikisho/utils/WAColors.dart'; // Import for number formatting

class PaymentOptionCard extends StatefulWidget {
  final int duration; // Duration in months
  final String packageName;
  final double packagePrice;
  final String packageId;

  PaymentOptionCard(
      {required this.duration,
      required this.packageName,
      required this.packagePrice,
      required this.packageId});

  @override
  State<PaymentOptionCard> createState() => _PaymentOptionCardState();
}

class _PaymentOptionCardState extends State<PaymentOptionCard> {
  late AuthService authService;
  var userName = "";
  var userPhone = "";
  var userJacket = "";
  var userImage = "";
  var isAdmin = false;
  var avatar = "/office/media/avatars/300-1.jpg";

  final _storage = const FlutterSecureStorage();

  Future<void> getUserData() async {
    authService.getUser();

    var name = await _storage.read(key: 'full_name');
    var phone = await _storage.read(key: 'user_phone');
    var uniform = await _storage.read(key: 'user_uniform_number');
    var image = await _storage.read(key: 'user_image');
    var isLeader = await _storage.read(key: 'user_is_leader');

    setState(
      () {
        userName = name!;
        userPhone = phone!;
        userImage = image!;
        userJacket = uniform!;
        isAdmin = isLeader! == 'true' ? true : false;
      },
    );
    // print("USER ::${name}");
  }

  void initState() {
    super.initState();
    authService = AuthService();

    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount =
        widget.packagePrice * widget.duration; // Calculate total amount

    return Card(
      // margin: EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        style: ListTileStyle.drawer,
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        title: Text(
          // "$duration Month${duration > 1 ? 's' : ''} Subscription",

          "${widget.duration > 1 ? 'Miezi' : 'Mwezi'} ${widget.duration}",
          textScaler: TextScaler.noScaling,

          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Jumla: TZS ${NumberFormat.decimalPattern().format(totalAmount)}',
          style: TextStyle(color: Colors.grey),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            // primary: Colors.blue, // Use your app's primary color
            backgroundColor: WAPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            // Navigate to the SummaryPage with selected options
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => SummaryPage(
            //     packageName: packageName,
            //     duration: duration,
            //     packagePrice: packagePrice,
            //   ),
            // ));
            showSummaryDialog(
                context,
                widget.packageId,
                widget.packageName,
                widget.duration,
                widget.packagePrice,
                userPhone,
                userName,
                false);
            // Navigator.of(context).pop();
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text("Umechagua miezi $duration ")),

            // );
          },
          child: Text("Lipia", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

void showPaymentOptionsDialog(BuildContext context, String packageName,
    double packagePrice, String packageID) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text("Chagua namna ya Kulipia",
            textScaler: TextScaler.noScaling,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PaymentOptionCard(
                duration: 1,
                packageName: packageName,
                packagePrice: packagePrice,
                packageId: packageID,
              ),
              SizedBox(height: 8),
              PaymentOptionCard(
                duration: 3,
                packageName: packageName,
                packagePrice: packagePrice,
                packageId: packageID,
              ),
              SizedBox(height: 8),
              PaymentOptionCard(
                duration: 6,
                packageName: packageName,
                packagePrice: packagePrice,
                packageId: packageID,
              ),
              SizedBox(height: 8),
              PaymentOptionCard(
                duration: 12,
                packageName: packageName,
                packagePrice: packagePrice,
                packageId: packageID,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Cancel",
                textScaler: TextScaler.noScaling,
                style: TextStyle(
                    color: WAPrimaryColor, fontWeight: FontWeight.w500)),
          ),
        ],
      );
    },
  );
}

void showSummaryDialog(
    BuildContext context,
    String packageId,
    String packageName,
    int duration,
    double packagePrice,
    String userPhone,
    String userName,
    bool isLoading) {
  double totalAmount = packagePrice * duration; // Calculate total amount
  TextEditingController phoneController =
      TextEditingController(text: userPhone); // Autofill phone number

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // bool isLoading = false;

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              "Taarifa za Malipo",
              textScaler: TextScaler.noScaling,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  SizedBox(height: 8),
                  Text("Jina : $userName",
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text("Aina ya Kifurushi: $packageName",
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                      "Muda wa Kulipia: $duration Month${duration > 1 ? 's' : ''}",
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                      "Kiasi kwa Mwezi: Tsh. ${NumberFormat.decimalPattern().format(packagePrice)}",
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                      "Jumla: Tsh. ${NumberFormat.decimalPattern().format(totalAmount)}",
                      textScaler: TextScaler.noScaling,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text("Weka Namba Ya Simu:",
                      textScaler: TextScaler.noScaling,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: phoneController,
                    maxLength: 12,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "0711xxxxxx",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: WAPrimaryColor
                        )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid, color: WAPrimaryColor)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid, color: WAPrimaryColor)),
                      counterText: '',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("*Tumia namba hii kulipia , au weka namba nyingine ",
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(fontSize: 12, color: WAPrimaryColor)),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Sitisha",
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                        color: WAPrimaryColor, fontWeight: FontWeight.w500)),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true; // Set loading state to true
                  });

                  String phoneNumber = phoneController.text;

                  var res = await submitPayment(
                      phoneNumber, packageId, duration, packagePrice);

                  // print("RESPONSE   :: $res");

                  Future.delayed(Duration(seconds: 8), () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pop(); // Additional pops if needed
                    Navigator.of(context).pop();

                    setState(() {
                      isLoading = false; // Set loading state to false
                    });
                  });
                },
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        "Lipa",
                        textScaler: TextScaler.noScaling,
                        style: TextStyle(color: Colors.white),
                      ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: WAPrimaryColor,
                    textStyle: TextStyle(color: whiteColor)),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<String> submitPayment(String phoneNumber, String packageId, int duration,
    double packagePrice) async {
  // Replace with your actual endpoint
  String apiUrl = '${Environment.apiUrl}/bima/sanlam/request';
  // String apiUrl = 'http://192.168.100.90:8000/api/bima/sanlam/request';

  try {
    const _storage = FlutterSecureStorage();

    var token = await _storage.read(key: 'token');
    // print("TOKEN :: $token");
    // Construct the request body
    Map<String, dynamic> requestBody = {
      'phone_number': phoneNumber,
      'package_id': packageId,
      'months': duration
      // 'total_amount': packagePrice * duration,
    };

    // print("request body ${requestBody}");
    // Make the POST request
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );
    // print("request  response body ${response.body} ");

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Handle success response

      var res = jsonDecode(response.body);
      // print('Payment successful: ');

      return "success";
      // return {"status": "success", "data":res};
    } else {
      // Handle non-200 response
      // print(
      //     'Failed to submit payment. Status code: ${response.statusCode}  with response body ${response.body}');
      return "fail";
    }
  } catch (e) {
    // Handle any exceptions
    // print('Error occurred while submitting payment: $e ,  from response  ');

    return "error";
  }
}
