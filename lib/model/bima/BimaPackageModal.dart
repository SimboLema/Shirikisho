import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../global/environment.dart';



class BimaPackageModal {
  int? id;
  String? name;
  int? price;
  String? insuranceClassCode;
  int? durationPeriod;
  String? insuranceTypeCode;
  String? institution;
  String? appType;
  String? serviceMsgType;
  String? status;
  int? sumInsured;
  String? description;

  BimaPackageModal(
      {this.id,
      this.name,
      this.price,
      this.insuranceClassCode,
      this.durationPeriod,
      this.insuranceTypeCode,
      this.institution,
      this.appType,
      this.serviceMsgType,
      this.status,
      this.sumInsured,
      this.description});

  BimaPackageModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    insuranceClassCode = json['insuranceClassCode'];
    durationPeriod = json['duration_period'];
    insuranceTypeCode = json['insuranceTypeCode'];
    institution = json['institution'];
    appType = json['appType'];
    serviceMsgType = json['serviceMsgType'];
    status = json['status'];
    sumInsured = json['sumInsured'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['insuranceClassCode'] = this.insuranceClassCode;
    data['duration_period'] = this.durationPeriod;
    data['insuranceTypeCode'] = this.insuranceTypeCode;
    data['institution'] = this.institution;
    data['appType'] = this.appType;
    data['serviceMsgType'] = this.serviceMsgType;
    data['status'] = this.status;
    data['sumInsured'] = this.sumInsured;
    data['description'] = this.description;
    return data;
  }
}



const _storage = FlutterSecureStorage();


Future<List<BimaPackageModal>> loadPosts() async {

  var old_packages = await _storage.read(key: 'all_plans');

  if (old_packages != null){
    loadOnlinePackages().ignore;
    var posts = jsonDecode(old_packages);

    print(' PACKAGE :: ${old_packages}');

    return (posts as List).map((i) => BimaPackageModal.fromJson(i)).toList();
  }else{
    return  await loadOnlinePackages();
  }

}


Future loadOnlinePackages() async {
  const _storage = FlutterSecureStorage();

  var token = await _storage.read(key: 'token');

  final response = await http.get(Uri.parse('${Environment.apiUrl}/bima/sanlam/packages'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  // var events = jsonResponse['packages'];

  await _storage.write(key: 'all_plans', value: jsonEncode(jsonResponse));

  List<BimaPackageModal> newPosts = (jsonResponse as List).map((i) => BimaPackageModal.fromJson(i)).toList();

  return newPosts;

}



