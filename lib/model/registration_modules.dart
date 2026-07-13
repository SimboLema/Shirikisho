class VehiclesTypesModule {
  final String vehicleId;
  final String vTypeName;
  final int vCapacity;

  VehiclesTypesModule(
      {required this.vCapacity,
      required this.vTypeName,
      required this.vehicleId});

  factory VehiclesTypesModule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'v_type_id': String vTypeId,
        'v_type_name': String vTypeName,
        'people_capacity': int peopleCapacity,
      } =>
        VehiclesTypesModule(
            vCapacity: peopleCapacity,
            vTypeName: vTypeName,
            vehicleId: vTypeId),
      _ => throw const FormatException('Failed to load vehicles types'),
    };
  }
}

class ParkAreaModule {
  final String parkId;
  final String parkName;
  final int parkSize;
  final String wardId;
  ParkAreaModule(
      {required this.parkId,
      required this.parkName,
      required this.parkSize,
      required this.wardId});

  factory ParkAreaModule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'park_id': String parkId,
        'park_name': String parkName,
        'park_size': int parkSize,
        'ward': String wardId,
      } =>
        ParkAreaModule(
            parkId: parkId,
            parkName: parkName,
            parkSize: parkSize,
            wardId: wardId),
      _ => throw const FormatException('Failed to unload parking areas'),
    };
  }
}

class ChamaModule {
  final String chamaId;
  final String chamaName;
  final String chamaPhone;
  ChamaModule(
      {required this.chamaId,
      required this.chamaName,
      required this.chamaPhone});

  factory ChamaModule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'chama_id': String chamaId,
        'jina': String chamaName,
        'simu': String chamaPhone,
      } =>
        ChamaModule(
            chamaId: chamaId, chamaName: chamaName, chamaPhone: chamaPhone),
      _ => throw const FormatException('Failed to unload parties (chama)'),
    };
  }
}

class RegionsModule {
  String regionName;
  String regId;
  String contryId;

  RegionsModule({
    required this.contryId,
    required this.regId,
    required this.regionName,
  });

  factory RegionsModule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'region_name': String regionName,
        'region_id': String regId,
        'country_id': String contryId
      } =>
        RegionsModule(contryId: contryId, regId: regId, regionName: regionName),
      _ => throw const FormatException('Failed to unload regions'),
    };
  }
}

// class DistrictModule {
//   String distName;
//   String distId;
//   String regId;
//   DistrictModule({
//     required this.distId,
//     required this.distName,
//     required this.regId,
//   });
//   factory DistrictModule.fromJson(Map<String, dynamic> json) {
//     return switch (json) {
//       {
//         'district_id': String distId,
//         'district_name': String distName,
//         'region_id': String regId
//       } =>
//         DistrictModule(distId: distId, distName: distName, regId: regId),
//       _ => throw const FormatException('Failed to unload districts'),
//     };
//   }
// }

class WardsModule {
  String wardName;
  String wardId;
  String distId;
  WardsModule({
    required this.distId,
    required this.wardId,
    required this.wardName,
  });
  factory WardsModule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'ward_id': String wardId,
        'ward_name': String wardName,
        'district_id': String distId
      } =>
        WardsModule(distId: distId, wardId: wardId, wardName: wardName),
      _ => throw const FormatException('Failed to unload wards'),
    };
  }
}

// class RegistrationGetInfo {
//   List<VehiclesTypesModule> vehicles;
//   List<ParkAreaModule> park;
//   List<RegionsModule> regions;
//   // List<DistrictModule> districts;
//   List<WardsModule> wards;
//   List<ChamaModule> chamas;
//   String message;
//   RegistrationGetInfo({
//     this.message = '',
//     required this.park,
//     required this.vehicles,
//     // required this.districts,
//     required this.regions,
//     required this.wards,
//     required this.chamas,
//   });
// }

class SubmitDriverDetailsModule {
  String fname;
  String mname;
  String lname;
  // String email;
  // String password;
  String phone;
  String dob;
  String gender;
  String relation;
  String residence;
  String parkArea;
  String vehicleNumber;
  String licenceNumber;
  String tinNumber;
  String idType;
  String idNumber;
  String idPicture;
  String insurance;
  String chama;
  String kinName;
  String kinPhone;
  String passport;
  String verid;
  SubmitDriverDetailsModule(
      {required this.chama,
      required this.dob,
      // required this.email,
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
      // required this.password,
      required this.phone,
      required this.relation,
      required this.residence,
      required this.tinNumber,
      required this.vehicleNumber,
      required this.verid});
}

// verification phone number initial response

class VerificationResponseModule {
  String state;
  String data;
  String otpId;
  String token;

  VerificationResponseModule(
      {required this.data, required this.otpId, required this.state,required this.token});

  factory VerificationResponseModule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'state': String state,
        'data': String data,
        'otp_id': String otpId,
        'token': String token,
      } =>
        VerificationResponseModule(data: data, otpId: otpId, state: state, token: token),
      _ => VerificationResponseModule(
          data: 'Unable to unload response data', otpId: '', state: 'error', token: '')
    };
  }
}

// verification response codeid Module

class VerificationCodeResponseModule {
  String state;
  String data;
  String verid;

  VerificationCodeResponseModule(
      {required this.data, required this.verid, required this.state});

  factory VerificationCodeResponseModule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'state': String state,
        'data': String data,
        'verid': String otpId,
      } =>
        VerificationCodeResponseModule(data: data, verid: otpId, state: state),
      _ => VerificationCodeResponseModule(
          data: 'Unable to unload response data', verid: '', state: 'error')
    };
  }
}

// image upload response module

class ImageUploadResponseModule {
  String state;
  String info;
  String imageId;

  ImageUploadResponseModule({
    required this.imageId,
    required this.info,
    required this.state,
  });
}

// driver registration
class DriversRegresponseModule {
  String state;
  String info;
  DriversRegresponseModule({
    required this.info,
    required this.state,
  });
}
