class MotorVerificationRes {
  VerificationHdr verificationHdr;
  VerificationDtl verificationDtl;
  String msgSignature;

  MotorVerificationRes({
    required this.verificationHdr,
    required this.verificationDtl,
    required this.msgSignature,
  });

  factory MotorVerificationRes.fromJson(Map<String, dynamic> json) {
    return MotorVerificationRes(
      verificationHdr: VerificationHdr.fromJson(json['VerificationHdr']),
      verificationDtl: VerificationDtl.fromJson(json['VerificationDtl']),
      msgSignature: json['MsgSignature'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'VerificationHdr': verificationHdr.toJson(),
      'VerificationDtl': verificationDtl.toJson(),
      'MsgSignature': msgSignature,
    };
  }
}

class VerificationHdr {
  String responseId;
  String requestId;
  String responseStatusCode;
  String responseStatusDesc;

  VerificationHdr({
    required this.responseId,
    required this.requestId,
    required this.responseStatusCode,
    required this.responseStatusDesc,
  });

  factory VerificationHdr.fromJson(Map<String, dynamic> json) {
    return VerificationHdr(
      responseId: json['ResponseId'],
      requestId: json['RequestId'],
      responseStatusCode: json['ResponseStatusCode'],
      responseStatusDesc: json['ResponseStatusDesc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ResponseId': responseId,
      'RequestId': requestId,
      'ResponseStatusCode': responseStatusCode,
      'ResponseStatusDesc': responseStatusDesc,
    };
  }
}

class VerificationDtl {
  String motorCategory;
  String registrationNumber;
  String chassisNumber;
  String make;
  String model;
  String modelNumber;
  String bodyType;
  String color;
  String engineNumber;
  String engineCapacity;
  String fuelUsed;
  String numberOfAxles;
  String axleDistance;
  String sittingCapacity;
  String yearOfManufacture;
  String tareWeight;
  String grossWeight;
  String motorUsage;
  String ownerName;
  String ownerCategory;

  VerificationDtl({
    required this.motorCategory,
    required this.registrationNumber,
    required this.chassisNumber,
    required this.make,
    required this.model,
    required this.modelNumber,
    required this.bodyType,
    required this.color,
    required this.engineNumber,
    required this.engineCapacity,
    required this.fuelUsed,
    required this.numberOfAxles,
    required this.axleDistance,
    required this.sittingCapacity,
    required this.yearOfManufacture,
    required this.tareWeight,
    required this.grossWeight,
    required this.motorUsage,
    required this.ownerName,
    required this.ownerCategory,
  });

  factory VerificationDtl.fromJson(Map<String, dynamic> json) {
    return VerificationDtl(
      motorCategory: json['MotorCategory'] ,
      registrationNumber: json['RegistrationNumber'],
      chassisNumber: json['ChassisNumber'],
      make: json['Make'],
      model: json['Model'],
      modelNumber: json['ModelNumber'],
      bodyType: json['BodyType'],
      color: json['Color'],
      engineNumber: json['EngineNumber'],
      engineCapacity: json['EngineCapacity'],
      fuelUsed: json['FuelUsed'],
      numberOfAxles: json['NumberOfAxles'],
      axleDistance: json['AxleDistance'] is String ? json['AxleDistance'] : json['AxleDistance'].toString(),
      sittingCapacity: json['SittingCapacity'],
      yearOfManufacture: json['YearOfManufacture'] is String ? json['YearOfManufacture']: json['YearOfManufacture'].toString(),
      tareWeight: json['TareWeight'],
      grossWeight: json['GrossWeight'],
      motorUsage: json['MotorUsage'],
      ownerName: json['OwnerName'],
      ownerCategory: json['OwnerCategory'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MotorCategory': motorCategory,
      'RegistrationNumber': registrationNumber,
      'ChassisNumber': chassisNumber,
      'Make': make,
      'Model': model,
      'ModelNumber': modelNumber,
      'BodyType': bodyType,
      'Color': color,
      'EngineNumber': engineNumber,
      'EngineCapacity': engineCapacity,
      'FuelUsed': fuelUsed,
      'NumberOfAxles': numberOfAxles,
      'AxleDistance': axleDistance,
      'SittingCapacity': sittingCapacity,
      'YearOfManufacture': yearOfManufacture,
      'TareWeight': tareWeight,
      'GrossWeight': grossWeight,
      'MotorUsage': motorUsage,
      'OwnerName': ownerName,
      'OwnerCategory': ownerCategory,
    };
  }
}
