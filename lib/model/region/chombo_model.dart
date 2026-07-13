import 'dart:convert';

// import 'package:shirikisho/model/bima/BimaPackageModal.dart';

vTypeModule vTypeFromJson(String str) => vTypeModule.fromJson(json.decode(str));

String vTypeToJson(vTypeModule data) => json.encode(data.toJson());

class vTypeModule {
  vTypeModule(
      {required this.id,
      required this.name,
      required this.description,
      required this.total_amount,
      required this.installment_duration,
      required this.down_payment_percent,
      required this.coverage,
      required this.daily_paid_amount,
      required this.weekly_paid_amount,
      required this.monthly_paid_amount});

  int id;
  String? name;
  String? description;
  int? total_amount;
  int? installment_duration;

  int? down_payment_percent;

  String? coverage;
  int? daily_paid_amount;
  int? weekly_paid_amount;
  int? monthly_paid_amount;

  factory vTypeModule.fromJson(Map<String, dynamic> json) => vTypeModule(
      id: json["id"],
      name: json["v_type_name"],
      description: json["description"],
      total_amount: json["total_amount"],
      installment_duration: json["installment_duration"],
      down_payment_percent: json["down_payment_percent"],
      coverage: json["coverage"],
      daily_paid_amount: json["daily_paid_amount"],
      weekly_paid_amount: json["weekly_paid_amount"],
      monthly_paid_amount: json["monthly_paid_amount"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "v_type_name": name,
        "description": description,
        "total_amount": total_amount,
        "installment_duration": installment_duration,
        "down_payment_percent": down_payment_percent,
        "coverage": coverage,
        "daily_paid_amount": daily_paid_amount,
        "weekly_paid_amount": weekly_paid_amount,
        "monthly_paid_amount": monthly_paid_amount
      };
}

BimaPkgModel bimaPackageFromJson(String str) =>
    BimaPkgModel.fromJson(json.decode(str));
String bimaPackageToJson(BimaPkgModel data) => json.encode(data.toJson());

class BimaPkgModel {
  BimaPkgModel({
    required this.id,
    required this.package_name,
    required this.description,
  });

  int id;
  String? package_name;
  String? description;

  factory BimaPkgModel.fromJson(Map<String, dynamic> json) => BimaPkgModel(
        id: json['id'],
        package_name: json['package_name'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_name": package_name,
        "description": description,
      };
}

// PAYMENT METHOD MODEL
PaymentMethodModel paymentMethodFromJson(String str) =>
    PaymentMethodModel.fromJson(json.decode(str));
String paymentMethodToJson(PaymentMethodModel data) =>
    json.encode(data.toJson());

class PaymentMethodModel {
  PaymentMethodModel({
    required this.id,
    required this.method_name,
    required this.description,
  });

  int id;
  String? method_name;
  String? description;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        id: json['id'],
        method_name: json['method_name'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "method_name": method_name,
        "description": description,
      };
}

// LOAN INSTALLMENT dURATUON MODEL
BimaLoanTypesModel BimaLoanTypesFromJson(String str) =>
    BimaLoanTypesModel.fromJson(json.decode(str));
String BimaLoanTypesToJson(BimaLoanTypesModel data) =>
    json.encode(data.toJson());

class BimaLoanTypesModel {
  BimaLoanTypesModel({
    required this.id,
    required this.name,
  });

  int id;
  String? name;

  factory BimaLoanTypesModel.fromJson(Map<String, dynamic> json) =>
      BimaLoanTypesModel(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class IdListModel {
  final int id;
  final String name;

  IdListModel({required this.id, required this.name});

  @override
  String toString() => name;
}

List<IdListModel> id_list = [
  IdListModel(id: 1, name: "NIDA"),
  IdListModel(id: 2, name: "Mpiga Kura"),
  IdListModel(id: 3, name: "Hati ya Kusafiria"),
  IdListModel(id: 4, name: "Leseni"),
  IdListModel(id: 5, name: "Mzanzibari Mkazi"),
  IdListModel(id: 6, name: "TIN"),
];
