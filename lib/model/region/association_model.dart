import 'dart:convert';


AssociationModule associationFromJson(String str) => AssociationModule.fromJson(json.decode(str));

String associationToJson(AssociationModule data) => json.encode(data.toJson());

class AssociationModule {
  AssociationModule({
    required this.id,
    required this.name,
  });

  int  id;
  String? name;

  factory AssociationModule.fromJson(Map<String, dynamic> json) => AssociationModule(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id":   id,
    "name": name,
  };
}