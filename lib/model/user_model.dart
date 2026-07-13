// To parse this JSON data, do
//
//     final UserModule = userFromJson(jsonString);

import 'dart:convert';

UserModule userFromJson(String str) => UserModule.fromJson(json.decode(str));

String userToJson(UserModule data) => json.encode(data.toJson());

class UserModule {
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
  String? uniformNumber;
  int? roleLevel;
  String? roleName;
  String? imageId;
  String? parking;
  String? ward;
  String? district;
  String? is_leader;
  String? is_driver;
  String? vehicle_number;
  bool? activeSubscription;

  UserModule({
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
    this.roleLevel,
    this.roleName,
    this.uniformNumber,
    this.imageId,
    this.parking,
    this.ward,
    this.district,
    this.is_leader,
    this.is_driver,
    this.vehicle_number,
    this.activeSubscription,
  });

  UserModule.fromJson(Map<String, dynamic> json) {
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
    uniformNumber = json['uniform_number'];
    roleLevel = json['role_level'];
    roleName = json['role_name'];
    imageId = json['image_url'];
    parking = json['parking'];
    ward = json['ward'];
    district = json['district'];
    is_leader = json['is_leader'];
    is_driver = json['is_driver'];
    vehicle_number = json['vehicle_number'];
    activeSubscription = json['active_subscription'] ?? false;
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
    data['uniform_number'] = this.uniformNumber;
    data['role'] = this.roleLevel;
    data['role'] = this.roleName;
    data['image_id'] = this.imageId;
    data['parking'] = this.parking;
    data['ward'] = this.ward;
    data['district'] = this.district;
    data['is_leader'] = this.is_leader;
    data['is_driver'] = this.is_driver;
    data['vehicle_number'] = this.vehicle_number;
    data['active_subscription'] = this.activeSubscription;

    return data;
  }
}
