import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shirikisho/global/environment.dart';

import '../controllers/registration_info_controllers.dart';
import '../model/drivers_modules.dart';
import '../model/registration_modules.dart';

class PostMainApis {
  PostMainApis();
  final String coreUrl = 'https://users.shirikisho.co.tz';
  final String baseUrl = Environment.apiUrl;
  final _storage = const FlutterSecureStorage();

  final Map<String, String> nHeaders = {
    'Content-Type': 'application/json',
  };

  Future<DriverPhoneVerificationResponseModule> sendDriverPhoneForverification(
      String phone) async {
    try {
      var data = jsonEncode({
        'phone': phone,
      });

      var token = await _storage.read(key: 'token');

      print(token);

      final Map<String, String> oHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final verResp = await http.post(Uri.parse('$baseUrl/driver/verify/phone'),
          headers: oHeaders, body: data);

      if (verResp.statusCode == 200) {
        Map<String, dynamic> phpResp = jsonDecode(verResp.body);
        if (phpResp.containsKey('state') && phpResp['state'] == 'success') {
          return DriverPhoneVerificationResponseModule.fromJson(phpResp);
        } else if (phpResp.containsKey('state') &&
            phpResp['state'] != 'success' &&
            phpResp.containsKey('data')) {
          return DriverPhoneVerificationResponseModule(
              data: phpResp['data'], state: '', otpId: 0, phone: '');
        } else {
          return DriverPhoneVerificationResponseModule(
              data: 'Tatizo lisilojulikana limejitokeza',
              state: '',
              otpId: 0,
              phone: '');
        }
      } else {
        return DriverPhoneVerificationResponseModule(
          data: 'Unable to connect to the server',
          state: '',
          otpId: 0,
          phone: '',
        );
      }
    } catch (e) {
      return DriverPhoneVerificationResponseModule(
        data: 'Major error has occurred on the app',
        state: '',
        otpId: 0,
        phone: '',
      );
    }
  }

  Future<ImageUploadResponseModule> uploadingImageFun(
      {required File imageFile}) async {
    // check file length if is more than 26Mb
    // var fl = File(imageFile);
    if (imageFile.lengthSync() > 26000000) {
      return ImageUploadResponseModule(
          imageId: '',
          info:
              'Picha unayotaka kutuma nikubwa. Hakikisha picha inaukubwa wa Mb 24',
          state: 'error');
    }

    var token = await _storage.read(key: 'token');

    var request = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/driver/upload_image'))
      ..fields['purpose'] = 'someone@somewhere.com'
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var rspBody = await response.stream.bytesToString();
      Map<String, dynamic> imgAns = jsonDecode(rspBody);
      if (imgAns.containsKey('state') &&
          imgAns['state'] == 'success' &&
          imgAns.containsKey('data') &&
          imgAns['data'] is Map) {
        return ImageUploadResponseModule(
            imageId: imgAns['data']['image_id'],
            info: imgAns['data']['info'],
            state: imgAns['state']);
      } else if (imgAns.containsKey('state') &&
          imgAns['state'] == 'success' &&
          (!imgAns.containsKey('data') || imgAns['data'] is! Map)) {
        return ImageUploadResponseModule(
            imageId: '',
            info:
                'Major error on response sent by the server. If app update exist please update your application',
            state: 'error');
      } else if (imgAns.containsKey('state') &&
          imgAns['state'] != 'success' &&
          imgAns.containsKey('data') &&
          imgAns['data'] is String) {
        return ImageUploadResponseModule(
            imageId: '', info: imgAns['data'], state: 'error');
      } else if (imgAns.containsKey('state') && imgAns['state'] != 'success') {
        return ImageUploadResponseModule(
            imageId: '',
            info:
                'Tatizo lisilotazamiwa limejitokeza. Tafadhali jaribu tena baadae',
            state: 'error');
      }
      return ImageUploadResponseModule(
          imageId: '',
          info: 'Tatizo lisilotazamiwa limejitokeza.',
          state: 'error');
    } else {
      return ImageUploadResponseModule(
          imageId: '',
          info: 'Tatizo la kimtandao limejitokeza',
          state: 'error');
    }
  }

  Future postProfile(phone, avatar) async {
    var token = await _storage.read(key: 'token');
    var stream = http.ByteStream(avatar.openRead());
    var length = await avatar.length();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/driver/upload_image'));
    request.fields['phone'] = phone;
    request.files.add(
        http.MultipartFile('avatar', stream, length, filename: avatar.path));
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    http.Response response =
        await http.Response.fromStream(await request.send());

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['id'];
    } else {
      return 0;
    }
  }

  Future updateDriverImage(id, avatar) async {
    var token = await _storage.read(key: 'token');
    var stream = http.ByteStream(avatar.openRead());
    var length = await avatar.length();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/driver/update_image'));
    request.fields['user_id'] = '$id';
    request.files.add(
        http.MultipartFile('avatar', stream, length, filename: avatar.path));
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    http.Response response =
        await http.Response.fromStream(await request.send());

    print("token :: $token");
    print(
        "response from uploading driver photo ::: $response res code:: ${response.statusCode} and the boddy  ::: ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      return 'true';
    } else {
      return 'false';
    }
  }

  Future updateDriverDetails(first_name, middle_name, last_name, license,
      vehicle_type, driver_id) async {
    var token = await _storage.read(key: 'token');

    Map<String, String> sendData = {
      "first_name": first_name,
      "middle_name": middle_name,
      "last_name": last_name,
      "license_number": license,
      "vehicle_type_id": '$vehicle_type',
    };

    final Map<String, String> nHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.post(
        Uri.parse('${Environment.apiUrl}/driver/$driver_id/store'),
        headers: nHeaders,
        body: jsonEncode(sendData));

    print(response);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return 'true';
    } else {
      return 'false';
    }
  }

  Future<DriversRegresponseModule> sendDriverInfo() async {
    try {
      SubmitDriverDetailsController subDa =
          Get.put(SubmitDriverDetailsController());

      SubmitDriverDetailsModule drData = subDa.subData.value;

      Map<String, String> sendData = {
        "fname": drData.fname,
      };

      final String baseUrl = 'https://mfumo.shirikisho.co.tz/api';

      final Map<String, String> nHeaders = {
        'Content-Type': 'application/json',
      };

      var resp = await http.post(Uri.parse('$baseUrl/driver/store_driver'),
          headers: nHeaders, body: jsonEncode(sendData));

      if (resp.statusCode == 200) {
        Map<String, dynamic> rspBody = jsonDecode(resp.body);
        if (rspBody.containsKey('state') &&
            rspBody['state'] == 'success' &&
            rspBody.containsKey('data') &&
            rspBody['data'] is Map) {
          return DriversRegresponseModule(
              info: rspBody['data']['info'], state: rspBody['state']);
        } else if (rspBody.containsKey('state') &&
            rspBody['state'] == 'success' &&
            (!rspBody.containsKey('data') || rspBody['data'] is! Map)) {
          return DriversRegresponseModule(
              info:
                  'Major error on response sent by the server. If app update exist please update your application',
              state: 'error');
        } else if (rspBody.containsKey('state') &&
            rspBody['state'] != 'success' &&
            rspBody.containsKey('data') &&
            rspBody['data'] is String) {
          return DriversRegresponseModule(
              info: rspBody['data'], state: 'error');
        } else if (rspBody.containsKey('state') &&
            rspBody['state'] != 'success') {
          return DriversRegresponseModule(
              info:
                  'Tatizo lisilotazamiwa limejitokoeza. Tafadhali jaribu tena baadae.',
              state: 'error');
        }
        return DriversRegresponseModule(
            info: 'Tatizo limejitokoeza. Tafadhali jaribu tena baadae.',
            state: 'error');
      } else {
        return DriversRegresponseModule(
            info: 'Tatizo la kimtandao limejitokeza, tafadhali jaribu tena',
            state: 'error');
      }
    } catch (e) {
      return DriversRegresponseModule(
          info: 'Major program error has occurred while sending driver details',
          state: 'error');
    }
  }

  Future saveDriver(
    fname,
    mname,
    lname,
    phone,
    license_number,
    address,
    marital_status,
    dob,
    gender,
    kin_name,
    kin_phone,
    chombo_type,
    chombo_no,
    is_owner,
    owner_name,
    owner_phone,
    bima_chombo,
    bima_afya,
    ward_id,
    association_id,
    park_id,
    image_id,
  ) async {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final request = {
      'first_name': fname,
      'middle_name': mname,
      'last_name': lname,
      'phone_number': phone,
      'license_number': license_number,
      'address': address,
      'marital_status': marital_status,
      'dob': dob,
      'gender': gender,
      'kin_name': kin_name,
      'kin_phone': kin_phone,
      'chombo_type': chombo_type,
      'chombo_no': chombo_no,
      'is_owner': is_owner,
      'owner_name': owner_name,
      'owner_phone': owner_phone,
      'bima_chombo': bima_chombo == "Ndio" ? 1 : 0,
      'bima_afya': bima_afya == "Ndio" ? 1 : 0,
      'ward_id': ward_id,
      'association_id': association_id,
      'parking_area_id': park_id,
      'image_id': image_id,
    };

    final response = await http.post(Uri.parse('$baseUrl/driver/store'),
        body: jsonEncode(request),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 201 || response.statusCode == 200) {
      return 'success';
    } else {
      return jsonDecode(response.body)['message'];
    }
  }
}
