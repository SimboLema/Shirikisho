import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../global/environment.dart';
import '../model/drivers_modules.dart';
import '../model/login_response.dart';
import '../model/user_model.dart';
import '../screen/sms/GroupChattingScreen.dart';

class AuthService with ChangeNotifier {
  late UserModule user;
  late DriverDetailsModule driver;

  bool _logeando = false;

  final _storage = const FlutterSecureStorage();

  final GroupChattingScreen _groupChatScreen = GroupChattingScreen();

  bool get logeando => _logeando;

  set logeando(value) {
    _logeando = value;
    notifyListeners();
  }

  Future login(String phone, String password) async {
    logeando = true;

    final request = {
      'phone': '255${phone.substring(1)}',
      'password': password,
      'device_name': 'mobile'
    };

    final response = await http.post(Uri.parse('${Environment.apiUrl}/login'),
        body: jsonEncode(request),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    // print("login code ${response.statusCode} the response :: ${response} and the bodyy :: ${response.body}");

    logeando = false;

    if (response.statusCode == 201) {
      await _storage.delete(key: 'token');
      await _saveToken(jsonDecode(response.body)['access_token']);

      await _saveOTPStatus('false');

      getUser();

      return jsonDecode(response.body)['message'];
    } else {
      return false;
    }
  }

  Future verifyOTP(String otp) async {
    logeando = true;

    String? device_id = await FirebaseMessaging.instance.getToken();
    var token = await _storage.read(key: 'token');

    final request = {'otp': otp, 'device_id': device_id};

    final response = await http.post(
        Uri.parse('${Environment.apiUrl}/verify_otp'),
        body: jsonEncode(request),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 201) {
      _saveOTPStatus('true');
      return true;
    } else {
      return jsonDecode(response.body)['message'];
    }
  }

  Future<dynamic> getUserDetails(token) async {
    String? device_id = await FirebaseMessaging.instance.getToken();

    final response = await http
        .get(Uri.parse('${Environment.apiUrl}/current_user'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    // log(response.statusCode as String);
    if (response.statusCode == 200) {
      final data = getUserResponseFromJson(response.body);
      user = data.user;

      await _storage.write(key: 'user_id', value: '${user.id}');
      await _storage.write(key: 'user_name', value: user.firstName);
      await _storage.write(key: 'user_phone', value: user.phoneNumber);
      await _storage.write(
          key: 'user_uniform_number', value: user.uniformNumber);
      await _storage.write(key: 'user_image', value: user.imageId);
      await _storage.write(key: 'user_district', value: user.district);
      await _storage.write(key: 'user_parking', value: user.parking);

      return true;
    }
  }

  Future register(String name, String email, String password) async {
    logeando = true;

    final request = {
      'registration_name': name,
      'phone': email,
      'password': password
    };

    final response = await http.post(
        Uri.parse('${Environment.apiUrl}/register'),
        body: jsonEncode(request),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        });
    logeando = false;

    if (response.statusCode == 200) {
      final data = loginResponseFromJson(response.body);
      await _saveToken(data.token);
      return true;
    } else {
      return jsonDecode(response.body)['message'];
    }
  }

  Future verifyOTPDriver(String otp) async {
    var phone = await _storage.read(key: 'driver_phone');

    final request = {'otp': otp, 'phone': phone};

    var token = await _storage.read(key: 'token');

    final response = await http.post(
        Uri.parse('${Environment.apiUrl}/driver/verify/otp'),
        body: jsonEncode(request),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    logeando = false;

    if (response.statusCode == 200) {
      return true;
    } else {
      return jsonDecode(response.body)['message'];
    }
  }

  Future _saveToken(String token) async {
    var writeToken = await _storage.write(key: 'token', value: token);
    return writeToken;
  }

  Future _saveOTPStatus(status) async {
    var writeOTPStatus = await _storage.write(key: 'otp_status', value: status);
    return writeOTPStatus;
  }

  Future<bool> logged() async {
    log('checking');
    var token = await _storage.read(key: 'token');
    var otp_status = await _storage.read(key: 'otp_status');

    if (token != null && otp_status == 'true') {
      log('Logged IN');
      getUserDetails(token);
      return true;
    } else {
      log('Not IN');
      return false;
    }
  }

  Future logout() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'otp_status');

    await _storage.deleteAll();
  }

  //si quiero el token sin referenciar a la clase, la hago static
  static Future<String?> getToken() async {
    final _storage = FlutterSecureStorage();
    return await _storage.read(key: 'token');
  }

  //si quiero el token sin referenciar a la clase, la hago static
  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future getUser() async {
    var token = await _storage.read(key: 'token');

    final response = await http
        .get(Uri.parse('${Environment.apiUrl}/current_user'), headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final data = getUserResponseFromJson(response.body);
      user = data.user;

      IsLeader = user.is_leader == 'true' ? true : false;
      IsDriver = user.is_driver == 'true' ? true : false;

      await _storage.write(key: 'user_id', value: '${user.id}');
      await _storage.write(key: 'user_name', value: user.firstName);
      await _storage.write(
          key: 'full_name',
          value:
              user.firstName! + ' ' + user.middleName! + ' ' + user.lastName!);

      await _storage.write(key: 'user_phone', value: user.phoneNumber);
      await _storage.write(
          key: 'user_uniform_number', value: user.uniformNumber);
      await _storage.write(key: 'user_image', value: user.imageId);
      await _storage.write(key: 'user_image', value: user.imageId);
      await _storage.write(key: 'user_district', value: user.district);
      await _storage.write(key: 'user_parking', value: user.parking);
      await _storage.write(key: 'user_is_leader', value: user.is_leader);
      await _storage.write(key: 'user_is_driver', value: user.is_driver);

      await _storage.write(key: 'vehicle_number', value: user.vehicle_number);
      await _storage.write(
          key: 'user_active_subscription', value: '${user.activeSubscription}');

      await FirebaseMessaging.instance.subscribeToTopic("${user.id}_user");

      return true;
    }

    //
    // if (response.statusCode == 200) {
    //   String jsonString = response.body;

    //   final jsonResponse = json.decode(jsonString);
    //   (jsonResponse as List).map((i) => UserModule.fromJson(i)).toList();
    //
    //   return true;
    //
    // } else {
    //   return jsonDecode(response.body)['message'];
    // }
  }

  Future<dynamic> findDriver(type, id) async {
    var token = await _storage.read(key: 'token');

    final Map<String, String> nHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final verResp = await http.get(
        Uri.parse('${Environment.apiUrl}/driver/get?type=$type&id=$id'),
        headers: nHeaders);
    if (verResp.statusCode == 200) {
      Map<String, dynamic> driverRes = jsonDecode(verResp.body);
      var d = DriverDetailsModule.fromJson(driverRes);
      getDriver(d.id);
    }
  }

  Future<dynamic> getDriver(id) async {
    var token = await _storage.read(key: 'token');

    final Map<String, String> nHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final verResp = await http.get(
        Uri.parse('${Environment.apiUrl}/driver/get?type=id&id=$id'),
        headers: nHeaders);

    if (verResp.statusCode == 200) {
      Map<String, dynamic> driverDetils = jsonDecode(verResp.body);

      if (driverDetils.containsKey('id')) {
        final ans = DriverDetailsModule.fromJson(driverDetils);
        driver = ans;

        return true;
      }
      return false;
    }
  }

  Future connectPusher() async {}
}
