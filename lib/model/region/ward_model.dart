import 'dart:convert';

import 'package:shirikisho/model/region/district_model.dart';
import 'package:shirikisho/model/region/prking_model.dart';

WardModule wardFromJson(String str) => WardModule.fromJson(json.decode(str));

String wardToJson(WardModule data) => json.encode(data.toJson());

class WardModule {
  WardModule({
    required this.id,
    required this.name,
    required this.parkings,
    this.district
  });

  int id;
  String? name;
  List<ParkingModule>? parkings;
  DistrictModule? district;

  factory WardModule.fromJson(Map<String, dynamic> json) => WardModule(
        id: json["id"],
        name: json["name"],
        parkings: json['parking_areas'] != null
            ? (json['parking_areas'] as List)
                .map((i) => ParkingModule.fromJson(i))
                .toList()
            : null,
        
        district: json['district'] == null
        ? null
        : DistrictModule.fromJson(json['district'])
        
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "parking_areas": parkings,
      };
}
