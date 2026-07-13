import 'dart:convert';

import 'package:shirikisho/model/region/ward_model.dart';

ParkingModule parkingFromJson(String str) =>
    ParkingModule.fromJson(json.decode(str));

String parkingToJson(ParkingModule data) => json.encode(data.toJson());

class ParkingModule {
  ParkingModule({required this.id, required this.name, this.ward});

  int id;
  String? name;
  String? vehicle_number;
  WardModule? ward;

  factory ParkingModule.fromJson(Map<String, dynamic> json) => ParkingModule(
        id: json["id"],
        name: json["name"],
        ward: json["ward"] == null ? null : WardModule.fromJson(json["ward"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

DriverVehicleModule vehicleFromJson(String str) =>
    DriverVehicleModule.fromJson(json.decode(str));

String vehicleToJson(DriverVehicleModule data) => json.encode(data.toJson());

class DriverVehicleModule {
  DriverVehicleModule({required this.id, required this.name, 
  required this.vehicle_number,


  
  this.ward});

  int id;
  String? name;
  String? vehicle_number;

  WardModule? ward;

  factory DriverVehicleModule.fromJson(Map<String, dynamic> json) =>
      DriverVehicleModule(
        id: json["id"],
        name: json["name"],
        vehicle_number: json["vehicle_number"],
        ward: json["ward"] == null ? null : WardModule.fromJson(json["ward"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
              };
}
