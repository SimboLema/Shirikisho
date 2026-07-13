import 'dart:convert';

import 'package:shirikisho/model/region/region_model.dart';
import 'package:shirikisho/model/region/ward_model.dart';

import 'association_model.dart';

DistrictModule districtFromJson(String str) =>
    DistrictModule.fromJson(json.decode(str));

String districtToJson(DistrictModule data) => json.encode(data.toJson());

class DistrictModule {
  DistrictModule({
    this.id,
    this.name,
    required this.wards,
    required this.associations,
    this.region
  });

  int? id;
  String? name;
  List<WardModule>? wards;
  List<AssociationModule>? associations;
  RegionModule? region;

  factory DistrictModule.fromJson(Map<String, dynamic> json) => DistrictModule(
        id: json["id"],
        name: json["name"],
        wards: json['wards'] != null
            ? (json['wards'] as List)
                .map((i) => WardModule.fromJson(i))
                .toList()
            : null,
        associations: json['associations'] != null
            ? (json['associations'] as List)
                .map((i) => AssociationModule.fromJson(i))
                .toList()
            : null,
            region: json['region'] != null
            ? RegionModule.fromJson(json['region'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "wards": wards,
        "associations": associations,
      };
}
