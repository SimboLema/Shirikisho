// Verify New Driver (Registering)
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shirikisho/model/region/prking_model.dart';

import '../global/environment.dart';

class DriverPhoneVerificationResponseModule {
  int otpId;
  String data;
  String state;
  String phone;

  DriverPhoneVerificationResponseModule(
      {required this.data,
      required this.otpId,
      required this.state,
      required this.phone});

  factory DriverPhoneVerificationResponseModule.fromJson(
      Map<String, dynamic> json) {
    return switch (json) {
      {
        'otp_id': int otpId,
        'data': String data,
        'state': String state,
        'phone': String phone,
      } =>
        DriverPhoneVerificationResponseModule(
            data: data, otpId: otpId, state: state, phone: phone),
      _ => DriverPhoneVerificationResponseModule(
          data: 'Unable to unload response data',
          otpId: 0,
          state: '',
          phone: '')
    };
  }
}

class UnverifiedGridDrivers {
  String fname;
  String type;
  String profile;
  String driverid;
  UnverifiedGridDrivers(
      {required this.driverid,
      required this.fname,
      required this.profile,
      required this.type});
}

class OnReviewDriverId {
  String driverId;
  OnReviewDriverId({required this.driverId});
}

class OnUpdateDriverId {
  String driverId;
  OnUpdateDriverId({required this.driverId});
}

class LoginFiDataModule {
  String state;
  String info;
  String logSess;
  String logKey;

  LoginFiDataModule(
      {required this.logKey,
      required this.info,
      required this.logSess,
      required this.state});
}

class DriverDetailsModule {
  int? id;
  String? driverId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? gender;
  int? status;
  String? licenseNumber;
  String? maritalStatus;
  String? dob;
  String? residenceAddress;
  int? parkingId;
  String? emailVerifiedAt;
  int? createdBy;
  int? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? archive;
  int? associationId;
  String? healthInsurance;
  String? parkId;
  String? chamaId;
  String? imageId;
  int? uniformId;
  int? vehicleType;
  String? message;

  bool? is_leader;
  bool? in_group;
  String? address;
  ParkingModule? parking_area;
  DriverVehicleModule? vehicle;

  DriverDetailsModule({
    this.id,
    this.driverId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.status,
    this.licenseNumber,
    this.maritalStatus,
    this.dob,
    this.residenceAddress,
    this.parkingId,
    this.emailVerifiedAt,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.archive,
    this.associationId,
    this.healthInsurance,
    this.parkId,
    this.chamaId,
    this.imageId,
    this.uniformId,
    this.vehicleType,
    this.is_leader,
    this.in_group,
    this.address,
    this.parking_area,
    this.vehicle,
    this.message,
  });

  DriverDetailsModule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    status = json['status'];
    licenseNumber = json['license_number'];
    maritalStatus = json['marital_status'];
    dob = json['dob'];
    residenceAddress = json['residence_address'];
    parkingId = json['parking_id'];
    emailVerifiedAt = json['email_verified_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    archive = json['archive'];
    associationId = json['association_id'];
    healthInsurance = json['health_insurance'];
    parkId = json['park_id'];
    chamaId = json['chama_id'];
    imageId = json['image_url'];
    uniformId = json['uniform_id'];
    vehicleType = json['vehicle_type'];
    is_leader = json['is_leader'] == null ? false : json['is_leader'];
    address = json['address'] == null ? 'Hana kituo' : json['address'];
    // in_group = json['in_group'] == null ? false : json['in_group'];
    parking_area = json['parking_area'] != null
        ? ParkingModule.fromJson(json['parking_area'])
        : null;
    vehicle = json['vehicle'] != null
        ? DriverVehicleModule.fromJson(json['vehicle'])
        : null;
    message = json['message'];

    in_group = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driver_id'] = this.driverId;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['gender'] = this.gender;
    data['status'] = this.status;
    data['license_number'] = this.licenseNumber;
    data['marital_status'] = this.maritalStatus;
    data['dob'] = this.dob;
    data['residence_address'] = this.residenceAddress;
    data['parking_id'] = this.parkingId;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['archive'] = this.archive;
    data['association_id'] = this.associationId;
    data['health_insurance'] = this.healthInsurance;
    data['park_id'] = this.parkId;
    data['chama_id'] = this.chamaId;
    data['image_id'] = this.imageId;
    data['uniform_id'] = this.uniformId;
    data['vehicle_type'] = this.vehicleType;
    data['message'] = this.message;
    return data;
  }
}

class FullDriverDetailsModule {
  String driverId;
  String fname;
  String mname;
  String lname;
  String email;
  String phone;
  String dob;
  String gender;
  String relationship;
  String residence;
  String parkArea;
  String vehicleNumber;
  String licenceNumber;
  String idType;
  String idNumber;
  String idPicture;
  String passport;
  String insurance;
  String chama;
  String kinName;
  String kinPhone;
  String status;
  FullDriverDetailsModule(
      {required this.chama,
      required this.dob,
      required this.driverId,
      required this.email,
      required this.fname,
      required this.gender,
      required this.idNumber,
      required this.idPicture,
      required this.idType,
      required this.insurance,
      required this.kinName,
      required this.kinPhone,
      required this.licenceNumber,
      required this.lname,
      required this.mname,
      required this.parkArea,
      required this.passport,
      required this.phone,
      required this.relationship,
      required this.residence,
      required this.status,
      required this.vehicleNumber});
  factory FullDriverDetailsModule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'driver_id': String driverId,
        'fname': String fname,
        'mname': String mname,
        'lname': String lname,
        'email': String email,
        'phone': String phone,
        'dob': String dob,
        'gender': String gender,
        'relationship': String relationship,
        'residence': String residence,
        'park_area': String parkArea,
        'vehicle_number': String vehicleNumber,
        'licence_number': String licenceNumber,
        'id_type': String idType,
        'id_number': String idNumber,
        'id_picture': String idPicture,
        'passport': String passport,
        'insurance': String insurance,
        'status': String status,
        'chama': String chama,
        'kin_name': String kinName,
        'kin_phone': String kinPhone,
      } =>
        FullDriverDetailsModule(
            chama: chama,
            dob: dob,
            driverId: driverId,
            email: email,
            fname: fname,
            gender: gender,
            idNumber: idNumber,
            idPicture: idPicture,
            idType: idType,
            insurance: insurance,
            kinName: kinName,
            kinPhone: kinPhone,
            licenceNumber: licenceNumber,
            lname: lname,
            mname: mname,
            parkArea: parkArea,
            passport: passport,
            phone: phone,
            relationship: relationship,
            residence: residence,
            status: status,
            vehicleNumber: vehicleNumber),
      _ => throw const FormatException(
          'Unable to unload driver details responses.')
    };
  }
}

Future<List<DriverDetailsModule>> loadAllDrivers() async {
  const _storage = FlutterSecureStorage();

  var officers;

  var old_officers = await _storage.read(key: 'all_drivers');

  if (old_officers != null) {
    officers = jsonDecode(old_officers);
  }

  loadAllOnlineDrivers(null).ignore();

  return (officers as List)
      .map((i) => DriverDetailsModule.fromJson(i))
      .toList();
}

Future loadAllOnlineDrivers(cursor) async {
  const storage = FlutterSecureStorage();

  var token = await storage.read(key: 'token');

  var url_cursor = cursor == 0 || cursor == null ? '' : '?cursor=$cursor';

  final response = await http.get(
      Uri.parse('${Environment.apiUrl}/chat/group/get/all_drivers$url_cursor'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  await storage.write(
      key: 'all_drivers', value: jsonEncode(jsonResponse['data']));

  List<DriverDetailsModule> drivers = (jsonResponse['data'] as List)
      .map((i) => DriverDetailsModule.fromJson(i))
      .toList();

  return [drivers, jsonResponse['per_page'], jsonResponse['next_cursor']];
}

Future loadSearchAllOnlineDrivers(cursor, searchTerm) async {
  const storage = FlutterSecureStorage();

  var token = await storage.read(key: 'token');

  var url_cursor = cursor == 0 || cursor == null ? '' : '?cursor=$cursor';

  print(searchTerm);

  if (searchTerm != null && searchTerm != '') {
    url_cursor = '?term=$searchTerm';
  }

  final response = await http.get(
      Uri.parse('${Environment.apiUrl}/chat/group/get/all_drivers$url_cursor'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  await storage.write(
      key: 'all_drivers', value: jsonEncode(jsonResponse['data']));

  List<DriverDetailsModule> drivers = (jsonResponse['data'] as List)
      .map((i) => DriverDetailsModule.fromJson(i))
      .toList();

  return [drivers, jsonResponse['per_page'], jsonResponse['next_cursor']];
}

Future<List<DriverDetailsModule>> loadOfficers() async {
  const _storage = FlutterSecureStorage();

  // var officers;
  List<dynamic> officers = []; // Initialize as empty list

  var old_officers = await _storage.read(key: 'my_parking_officers');

  if (old_officers != null) {
    officers = jsonDecode(old_officers);
  }

  loadOnlineOfficers().ignore();

  return (officers as List)
      .map((i) => DriverDetailsModule.fromJson(i))
      .toList();
}

Future<List<DriverDetailsModule>> loadOnlineOfficers() async {
  const storage = FlutterSecureStorage();

  var token = await storage.read(key: 'token');

  final response = await http
      .get(Uri.parse('${Environment.apiUrl}/driver/officers'), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  await storage.write(
      key: 'my_parking_officers', value: jsonEncode(jsonResponse));

  return (jsonResponse as List)
      .map((i) => DriverDetailsModule.fromJson(i))
      .toList();
}

Future createNewGroup(text, drivers) async {
  const _storage = FlutterSecureStorage();

  var token = await _storage.read(key: 'token');

  final request = {
    'name': text,
    'drivers': drivers,
  };

  final response = await http.post(
      Uri.parse('${Environment.apiUrl}/chat/group/create'),
      body: jsonEncode(request),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

  var res = [response.statusCode, json.decode(response.body)];

  return res;
}
