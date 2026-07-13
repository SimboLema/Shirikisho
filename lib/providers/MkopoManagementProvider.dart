import 'dart:convert';
import "dart:io";

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shirikisho/global/apidio.dart';
import 'package:shirikisho/global/appConstants.dart';
import "package:shirikisho/global/http.dart";
import 'package:http/http.dart' as http;

import 'package:path/path.dart';

class Mkopomanagementprovider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  var _vehicle_types;
  var _vehicles;
  var _userLoans;
  var _regionalLoans;

  get vehicle_models => _vehicle_types;
  get brands => _vehicles;
  get userLoan => _userLoans;
  get regionalLoans => _regionalLoans;

  Future<bool> getVehicles() async {
    try {
      var res = await ApiClientHttp(headers: <String, String>{
        'Accept': 'application/json',
      }).getRequest("api/get-vehicle-types");

      // print("vehiclesss ::: ${res}");

      if (res == null) {
        return false;
      } else {
        var body = res;

        _vehicle_types = body;

        String encodedVehicles = jsonEncode(_vehicle_types);

        await _secureStorage.write(key: 'vehicleTypes', value: encodedVehicles);

        // print("vehiclesss ::: ${body}");
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> getVehicleBrands() async {
    try {
      var res = await ApiClientHttp(headers: <String, String>{
        'Content-type': 'application/json',
      }).getRequest("api/vehicles");

      if (res == null) {
        return false;
      } else {
        var body = res;
        _vehicles = body['data'];
        var encode = jsonEncode(_vehicles);

        await _secureStorage.write(key: 'brands', value: encode);
        // print("Brandss ${_vehicles}");
        notifyListeners();
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateLicense(ctx, data) async {
    var token = await _secureStorage.read(key: 'token');

    print("token :: $token");

    try {
      var res = await ApiClientHttp(
              headers: <String, String>{'Authorization': 'Bearer $token'})
          .putRequest("api/update-license", data);

      print("response res :: ${res}");

      if (res == null) {
        return false;
      }
      {
        var body = res;
        print("response ${body}");

        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> loanApplication(ctx, Map<String, dynamic> data) async {
    var token = await _secureStorage.read(key: 'token');
    print("token :: $token");

    try {
      // Create a multipart request
      var uri = Uri.parse(AppConstants.apiBaseUrl + 'api/loan-application');
      var request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      // Add fields (from data map)
      request.fields['transaction_id'] = data['transaction_id'] ?? '';
      request.fields['account_number'] = data['account_number'] ?? '';
      request.fields['vehicle_type_id'] = data['vehicle_type_id'].toString();
      request.fields['vehicle_id'] = data['vehicle_id'].toString();

      // // Check if formYaDhamana is present in data
      // if (data.containsKey('formYaDhamana') && data['formYaDhamana'] != null) {
      //   File formYaDhamanaFile = data['formYaDhamana'];

      //   // Add the file to the multipart request
      //   var multipartFile = await http.MultipartFile.fromPath(
      //     'file_url', // Adjust the field name if needed by your backend
      //     formYaDhamanaFile.path,
      //     filename: basename(formYaDhamanaFile.path),
      //   );
      //   request.files.add(multipartFile);
      // }
      // Check if there are support documents to upload
      if (data.containsKey('support_documents') &&
          data['support_documents'] != null) {
        List<File> supportDocuments = data['support_documents'];

        // Add each file in supportDocuments to the request
        for (var file in supportDocuments) {
          var multipartFile = await http.MultipartFile.fromPath(
            'file_url[]', // Ensure this matches your backend parameter for lists of files
            file.path,
            filename: basename(file.path),
          );
          request.files.add(multipartFile);

          print("files sent  $multipartFile");
        }
      }

      // Send the request
      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseBody = response.body;
        print("Response ::: $responseBody");

        var body = jsonDecode(responseBody);

        if (body['status']) {
          return true;
        } else {
          return false;
        }
      } else {
        print("Failed: ${response.statusCode}");
        return false;
      }
    } catch (error) {
      print("Error: $error");
      return false;
    }
  }

  Future<bool> getUserLoanApplications() async {
    var token = await _secureStorage.read(key: 'token');

    try {
      var res = await ApiClientHttp(
              headers: <String, String>{'Authorization': 'Bearer  $token'})
          .getRequest('api/loan-applications');
      if (res == null) {
        return false;
      } else {
        var body = res;
        _userLoans = body['data'];
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> getRegionalApplications() async {
    var token = await _secureStorage.read(key: 'token');

    var res = await ApiClientHttp(headers: <String, String>{
      'Authorization': 'Bearer  $token',
    }).getRequest('api/region_manager_loan-applications');

    print('RES: ${res}');

    if (res == null) {
    } else {
      if (res['status'] == true) {
        var body = res;
        _regionalLoans = body['loans'];
        
      }
    }
  }
}
