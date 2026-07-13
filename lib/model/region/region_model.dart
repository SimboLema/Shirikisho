import 'dart:convert';

import 'package:shirikisho/model/region/district_model.dart';



RegionModule regionFromJson(String str) => RegionModule.fromJson(json.decode(str));

String regionToJson(RegionModule data) => json.encode(data.toJson());

class RegionModule {
  RegionModule({
    required this.id,
    required this.name,
    this.districts,
  });

  int id;
  String? name;
  List<DistrictModule>? districts;

  factory RegionModule.fromJson(Map<String, dynamic> json) => RegionModule(
    id: json["id"],
    name: json["name"],
    districts: json['districts'] != null ? (json['districts'] as List).map((i) => DistrictModule.fromJson(i)).toList() : null,
  );

  Map<String, dynamic> toJson() => {
    "id":    id,
    "name":  name,
    "districts":  districts,
  };
}