// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import'dart:convert';

import 'package:shirikisho/model/user_model.dart';


LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.state,
    required this.token,
    required this.otpId,
  });

  String state;
  String token;
  String otpId;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        state: json["state"],
        token: json["token"],
        otpId: json["otp_id"],
      );

  Map<String, dynamic> toJson() => {
        "ok": state,
        "token": token,
      };
}


getUserResponse getUserResponseFromJson(String str) => getUserResponse.fromJson(json.decode(str));


class getUserResponse {
  getUserResponse({
    required this.user,
  });

  UserModule user;

  factory getUserResponse.fromJson(Map<String, dynamic> json) => getUserResponse(
    user: UserModule.fromJson(json),
  );

  Map<String, dynamic> toJson() => {
    "user": user,
  };
}


OTPResponse otpResponseFromJson(String str) => OTPResponse.fromJson(json.decode(str));

String otpResponseToJson(LoginResponse data) => json.encode(data.toJson());

class OTPResponse {
  OTPResponse({
    required this.state,
    required this.token,
    // required this.otpId,
  });

  String state;
  String token;
  // String otpId;

  factory OTPResponse.fromJson(Map<String, dynamic> json) => OTPResponse(
        state: json["state"],
        token: json["token"],
        // otpId: json["otp_id"],
      );

  Map<String, dynamic> toJson() => {
        "ok": state,
        "token": token,
      };
}
