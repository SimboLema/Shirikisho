import 'package:shirikisho/model/region/chombo_model.dart';

class LoanModel {
  LoanModel(
      {required this.id,
      required this.bima_ya_chombo_loan_type_id,
      required this.vehicleTypeId,
      required this.packageId,
      required this.status,
      required this.totalAmount,
      required this.paidAmount,
      required this.remainBalance,
      required this.paymentId,
      this.request,
      this.loan_type,
      this.vehicle_type});

  int id;
  int bima_ya_chombo_loan_type_id;
  int vehicleTypeId;
  int packageId;
  String status;
  double totalAmount;
  double paidAmount;
  double remainBalance;
  int paymentId;
  RequestModel? request;
  BimaLoanTypesModel? loan_type;
  vTypeModule? vehicle_type;

  factory LoanModel.fromJson(Map<String, dynamic> json) => LoanModel(
        id: json["id"],
        bima_ya_chombo_loan_type_id: json["bima_ya_chombo_loan_type_id"],
        vehicleTypeId: json["vehicle_type_id"],
        packageId: json["bima_ya_chombo_package_id"],
        status :json['status'],
        totalAmount: json["total_amount"].toDouble(),
        paidAmount: json["paid_amount"].toDouble(),
        remainBalance: json["remain_balance"].toDouble(),
        paymentId: json["payment_id"],
        request: json["request"] == null
            ? null
            : RequestModel.fromJson(json["request"]),
        loan_type: json["loan_type"] == null
            ? null
            : BimaLoanTypesModel.fromJson(json["loan_type"]),
        vehicle_type: json["vehicle_type"] == null
            ? null
            : vTypeModule.fromJson(json["vehicle_type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bima_ya_chombo_loan_type_id": bima_ya_chombo_loan_type_id,
        "vehicle_type_id": vehicleTypeId,
        "bima_ya_chombo_package_id": packageId,
        "status": status,
        "total_amount": totalAmount,
        "paid_amount": paidAmount,
        "remain_balance": remainBalance,
        "payment_id": paymentId,
      };
}

class RequestModel {
  RequestModel({
    required this.id,
    required this.phone,
    required this.vehicleNumber,
    required this.start_date,
    required this.end_date,
    this.response,
  });

  int id;
  String? phone;
  String? vehicleNumber;
  String start_date;
  String end_date;

  ResponseModel? response;

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        id: json["id"],
        phone: json["phone"],
        vehicleNumber: json["reg"],
        start_date: json["start_date"],
        end_date: json["end_date"],
        response: json["response"] == null
            ? null
            : ResponseModel.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "reg": vehicleNumber,
        "start_date": start_date,
        "end_date": end_date,
      };
}

class ResponseModel {
  ResponseModel({
    required this.id,
    required this.covernote_start_date,
    required this.covernote_end_date,
    required this.covernote_number,
    required this.covernote_id,
  });

  int id;
  String covernote_start_date;
  String covernote_end_date;
  String? covernote_number;
  int covernote_id;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        id: json["id"],
        covernote_start_date: json["covernote_start_date"],
        covernote_end_date: json["covernote_end_date"],
        covernote_number: json["covernote_number"],
        covernote_id: json["covernote_id"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "covernote_start_date": covernote_start_date,
        "covernote_end_date": covernote_end_date,
        "covernote_number": covernote_number,
        "covernote_id": covernote_id,
      };
}
