import 'dart:convert';

import 'package:http/http.dart' as http;
// import 'package:shirikisho/model/registration_modules.dart';


import '../../global/environment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shirikisho/model/region/region_model.dart';

import '../model/drivers_modules.dart';
import '../model/region/chombo_model.dart';



Future<List<vTypeModule>> loadVehicles() async {

  final response = await http.get(Uri.parse('${Environment.apiUrl}/get-vehicle-types'),
      headers: {'Content-Type': 'application/json'});

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  return (jsonResponse as List).map((i) => vTypeModule.fromJson(i)).toList();
}