import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shirikisho/model/region/region_model.dart';

// import 'package:shirikisho/model/registration_modules.dart';

import '../../global/environment.dart';
import '../model/region/chombo_model.dart';

Future<List<RegionModule>> loadRegions() async {
  const storage = FlutterSecureStorage();

  var token = await storage.read(key: 'token');

  final response = await http.get(Uri.parse('${Environment.apiUrl}/region'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  // print("Region responses:: $jsonResponse");
  return (jsonResponse as List).map((i) => RegionModule.fromJson(i)).toList();
}

Future<List<vTypeModule>> loadVehicles() async {
  final response = await http.get(
      Uri.parse('${Environment.apiUrl}/get-vehicle-types'),
      headers: {'Content-Type': 'application/json'});

  const storage = FlutterSecureStorage();

  // var token = await storage.read(key: 'token');

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  // print(
  //     "Vehicle type response ::: ${jsonResponse}"); // prints the JSON response

  return (jsonResponse as List).map((i) => vTypeModule.fromJson(i)).toList();
}

//FETCHING MKOPO WA BIMA YA CHOMBO
Future<List<BimaPkgModel>> loadPackages() async {
  const storage = FlutterSecureStorage();

  var token = await storage.read(key: 'token');
  final response = await http.get(
      Uri.parse('${Environment.apiUrl}/bima-ya-chombo-packages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

  String jsonString = response.body;
  final JsonResponse = json.decode(jsonString);

  // print("Bima packagess ::: ${JsonResponse['data']}");

  return (JsonResponse['data'] as List)
      .map((item) => BimaPkgModel.fromJson(item))
      .toList();
}

//FETCHING PAYMENT METHOD FOR MKOPO WA BIMA
Future<List<PaymentMethodModel>> loadPaymentMethod() async {
  const storage = FlutterSecureStorage();

  var token = await storage.read(key: 'token');
  final response = await http
      .get(Uri.parse('${Environment.apiUrl}/payment-methods'), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  });

  String jsonString = response.body;
  final JsonResponse = json.decode(jsonString);

  // print("Payment method ::: ${JsonResponse}");

  return (JsonResponse['data'] as List)
      .map((item) => PaymentMethodModel.fromJson(item))
      .toList();
}

// FETCHOING BIMA LOAN TYPRS
Future<List<BimaLoanTypesModel>> loadLoanTypes() async {
  const storage = FlutterSecureStorage();

  var token = await storage.read(key: 'token');
  final response = await http.get(
      Uri.parse('${Environment.apiUrl}/bima-ya-chombo-loan-types'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

  String jsonString = response.body;
  final JsonResponse = json.decode(jsonString);

  // print("Payment method ::: ${JsonResponse}");

  return (JsonResponse['data'] as List)
      .map((item) => BimaLoanTypesModel.fromJson(item))
      .toList();
}

Future saveKituo(wardId, name, latitude, longitude) async {
  final data = {
    "ward_id": wardId,
    "name": name,
    "owner": "Halmashauri",
    "members_capacity": 200,
    "latitude": latitude,
    "longitude": longitude
  };

  // print("Data to send :: ${data}");

  const storage = FlutterSecureStorage();

  var token = await storage.read(key: 'token');
  final response = await http.post(
      Uri.parse('${Environment.apiUrl}/addParking'),
      body: jsonEncode(data),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

  // print(
  //     "responses status code :: ${response.statusCode} Response :: ${response.body} and decoded :: ${jsonDecode(response.body)}"); // prints the JSON response

  if ((response.statusCode == 200 || response.statusCode == 201) &&
      jsonDecode(response.body)['status'] == true) {
    return {
      "status": "success",
      "message":
          "Kituo cha ${jsonDecode(response.body)['data']['name']} kimefanikiwa kusajiliwa",
    };
  } else {
    return {"status": "fail", "message": "Kituo  hakikufanikiwa kusajiliwa"};
  }
}

Future updateKituo(id, wardId, name, latitude, longitude) async {
  final data = {
    // "ward_id": wardId,
    "name": name,
    // "owner": "Halmashauri",
    // "members_capacity": 200,
    "latitude": latitude,
    "longitude": longitude
  };

  print("Data to send :: ${data}");

  const storage = FlutterSecureStorage();

  var token = await storage.read(key: 'token');
  final response = await http.post(
      Uri.parse('${Environment.apiUrl}/leader/updateParking/$id'),
      body: jsonEncode(data),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

  if ((response.statusCode == 200 || response.statusCode == 201) &&
      jsonDecode(response.body)['status']) {
    return {
      "status": "success",
      "message":
          "Kituo cha ${jsonDecode(response.body)['data']['name']} kimefanikiwa kuhakikiwa",
    };
  } else {
    return {"status": "fail", "message": "Kituo  hakikufanikiwa kuhakikiwa"};
  }
}

Future loadParking() async {
  const storage = FlutterSecureStorage();

  var token = await storage.read(key: 'token');
  final response = await http
      .get(Uri.parse('${Environment.apiUrl}/leader/parking'), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  });

  // print("Response :: ${json.decode(response.body)}");
  // String jsonString = response.body;
  final JsonResponse = json.decode(response.body);

  return JsonResponse;
}




