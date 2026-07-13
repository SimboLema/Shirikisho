import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../global/environment.dart';
import '../model/drivers_modules.dart';

class GetMainApis with ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  late DriverDetailsModule driver;

  Future<dynamic> findDriver(type, id) async {
    var token = await _storage.read(key: 'token');

    final Map<String, String> nHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final verResp = await http.get(
        Uri.parse('${Environment.apiUrl}/driver/get?type=$type&id=$id'),
        headers: nHeaders);

    if (verResp.statusCode == 200) {
      Map<String, dynamic> driverRes = jsonDecode(verResp.body);
      return DriverDetailsModule.fromJson(driverRes);
      // return true;
    } else {
      try {
        final errorRes = jsonDecode(verResp.body);
        return DriverDetailsModule(id: null, message: errorRes['message']);
      } catch (e) {
        return DriverDetailsModule(id: null, message: "Something went wrong");
      }
      // return DriverDetailsModule(id: null);
      // return false;
    }
  }

  Future<dynamic> hakikiVazi(phone, int? driverId) async {
    var token = await _storage.read(key: 'token');

    final Map<String, String> nHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final verResp = await http.post(
      Uri.parse('${Environment.apiUrl}/driver/hakiki/vazi'),
      headers: nHeaders,
      body: jsonEncode({"phone": phone, "driver_id": driverId}),
    );

    if (verResp.statusCode == 200) {
      Map<String, dynamic> driverRes = jsonDecode(verResp.body);
      print("Hakiika Vazi Response: $driverRes");
      return driverRes;
    } else {
      Map<String, dynamic> errorRes = jsonDecode(verResp.body);
      throw Exception(errorRes['message'] ?? 'Unknown error');
    }
  }

  Future<dynamic> verifyLicense1() async {
    var token = await _storage.read(key: 'token');

    final Map<String, String> nHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final verResp = await http.get(
        Uri.parse('${Environment.apiUrl}/uniform/verify/license'),
        headers: nHeaders);

    var response = jsonDecode(verResp.body);

    var _licenseResponse = [verResp.statusCode, response['message']];

    return _licenseResponse;
  }

  // Update verifyLicense to handle exceptions
  Future<dynamic> verifyLicense() async {
    try {
      var token = await _storage.read(key: 'token');

      print("token: $token");

      final Map<String, String> nHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final verResp = await http.get(
          Uri.parse('${Environment.apiUrl}/bima/check/license'),
          headers: nHeaders);

      var response = jsonDecode(verResp.body);
      var _licenseResponse = [verResp.statusCode, response['status']];

      print("License Response: $_licenseResponse");

      return _licenseResponse;
    } catch (e) {
      throw Exception("Network issue or API error");
    }
  }

  // Future<dynamic> verifyBima() async {
  //   var token = await _storage.read(key: 'token');

  //   final Map<String, String> nHeaders = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };

  //  try{ var response = await http.get(
  //       Uri.parse(
  //           'https://mfumo.shirikisho.co.tz/api/bima/sanlam/user/latest-package/subscription'),
  //       headers: <String, String>{'Authorization': 'Bearer $token'});
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     var body = jsonDecode(response.body);

  //     print("DATAD FROM API ENDPOINT 1  :: $body");

  //     // var res = await http.post(
  //     //     Uri.parse(
  //     //         'https://mfumo.shirikisho.co.tz/api/bima/sanlam/check_status'),
  //     //     body: {"package_id": body['data']['bima_package_id'].toString()},
  //     //     headers: <String, String>{'Authorization': 'Bearer $token'});
  //     // var body2 = jsonDecode(res.body);

  //     var res = await http.post(
  //         Uri.parse(
  //             'https://mfumo.shirikisho.co.tz/api/check_bima_status_any_time'),
  //         body: {
  //           "package_id": body['data']['bima_package_id'].toString(),
  //           "user_id": body['data']['user_id'].toString()
  //         },
  //         headers: <String, String>{
  //           'Authorization': 'Bearer $token'
  //         });
  //     var body2 = jsonDecode(res.body);
  //     print("res body $body2");

  //     return body2;
  //   }}catch(e){
  //     return  e;

  //   }
  // }

  Future<dynamic> verifyBima() async {
    try {
      var token = await _storage.read(key: 'token');

      final Map<String, String> nHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await http.get(
          Uri.parse(
              'https://mfumo.shirikisho.co.tz/api/bima/sanlam/user/latest-package/subscription'),
          headers: <String, String>{'Authorization': 'Bearer $token'});

      if (response.statusCode == 200 || response.statusCode == 201) {
        var body = jsonDecode(response.body);

        print("DATAD FROM API ENDPOINT 1  :: $body");

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
        var body2 = jsonDecode(res.body);
        print("res body $body2");

        return body2;
      } else {
        throw Exception("Failed to verify insurance");
      }
    } catch (e) {
      throw Exception("Network issue or API error");
    }
  }
}
