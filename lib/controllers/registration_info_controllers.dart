import 'package:get/get.dart';

import '../model/drivers_modules.dart';
import '../model/registration_modules.dart';

class SubmitDriverDetailsController extends GetxController {
  var subData = SubmitDriverDetailsModule(
          chama: '',
          dob: '',
          // email: '',
          fname: '',
          gender: '',
          idNumber: '',
          idPicture: '',
          idType: '',
          insurance: '',
          licenceNumber: '',
          lname: '',
          kinName: '',
          kinPhone: '',
          mname: '',
          parkArea: '',
          passport: '',
          // password: '',
          phone: '',
          relation: '',
          residence: '',
          tinNumber: '',
          vehicleNumber: '',
          verid: ''
  )
      .obs;

    void updateDriverInfo({
      required String fname,
      required String mname,
      required String lname,
      // required String email,
      // required String password,
      required String phone,
      required String dob,
      required String gender,
      required String relation,
      required String residence,
      required String parkArea,
      required String vehicleNumber,
      required String licenceNumber,
      required String tinNumber,
      // required String idType,
      // required String idNumber,
      // required String idPicture,
      required String insurance,
      required String chama,
      required String kinName,
      required String kinPhone,
      required String passport,
      required String verid,
  }) {
    subData.update((val) {
      val!.fname = fname;
      val.mname = mname;
      val.lname = lname;
      val.phone = phone;
      val.dob = dob;
      val.gender = gender;
      val.relation = relation;
      val.residence = residence;
      val.parkArea = parkArea;
      val.vehicleNumber = vehicleNumber;
      // val.idPicture = idPicture;
      val.insurance = insurance;
      val.chama = chama;
      val.kinName = kinName;
      val.kinPhone = kinPhone;
      val.passport = passport;
    });
  }

  void updateContactInfo(
      {required String fname,
      required String mname,
      required String lname,
      required String phone,
      // required email,
      // required password
      }) {
    subData.update((val) {
      val!.fname = fname;
      val.mname = mname;
      val.lname = lname;
      val.phone = phone;
      // val.email = email;
      // val.password = password;
    });
  }

  void updateVeridInfo({required String verid}) {
    subData.update((val) {
      val!.verid = verid;
    });
  }

  void updateParkingInfo({required String parkArea, required String chama}) {
    subData.update((val) {
      val!.parkArea = parkArea;
      val.chama = chama;
    });
  }


  void updatePersonalInfo({
    required String residence,
    required String relation,
    required String tinNumber,
    required String licenceNumber,
    required String dob,
    required String gender,
    required String kinName,
    required String kinPhone,
  }) {
    subData.update((val) {
      val!.dob = dob;
      val.residence = residence;
      val.relation = relation;
      val.tinNumber = tinNumber;
      val.licenceNumber = licenceNumber;
      val.gender = gender;
      val.kinName = kinName;
      val.kinPhone = kinPhone;
    });
  }

  void updateVehicleInfo(
      {required String vehicleNumber, required String insurance}) {
    subData.update((val) {
      val!.insurance = insurance;
      val.vehicleNumber = vehicleNumber;
    });
  }

  void updateCardsDetailsInfo(
      {required String idType,
      required String idPicture,
      required String idNumber,
      required String passport}) {
    subData.update((val) {
      val!.idType = idType;
      val.idPicture = idPicture;
      val.idNumber = idNumber;
      val.passport = passport;
    });
  }
}

class PhoneInitVerificationCodeResponseController extends GetxController {
  var phoneVerRespo =
      VerificationResponseModule(data: '', otpId: '', state: '', token: '').obs;
  updateRespos(VerificationResponseModule resp) {
    phoneVerRespo.update((val) {
      val!.data = resp.data;
      val.otpId = resp.otpId;
      val.state = resp.state;
    });
  }
}


class DriverPhoneInitVerificationCodeResponseController extends GetxController {
  var phoneVerRespo =
      DriverPhoneVerificationResponseModule(data: '',state: '', phone: '', otpId: 0).obs;
  updateDrvRespos(DriverPhoneVerificationResponseModule resp) {
    phoneVerRespo.update((val) {
      val!.data = resp.data;
      val.state = resp.state;
      val.otpId = resp.otpId;
      val.phone = resp.phone;
    });
  }
}
