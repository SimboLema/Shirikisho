import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shirikisho/global/environment.dart';
import 'package:shirikisho/helpers/constantFunctions.dart';
import 'package:shirikisho/model/bima/bima_chombo_model.dart';

class BimaChomboApis {
  BimaChomboApis();
  // final String baseUrl = Environment.apiUrl;
  // final String baseUrl = "https://mfumo.shirikisho.co.tz/api";
  final String baseUrl = Environment.apiUrl;
  // final String baseUrl = "http://192.168.100.90:8000/api";

  final _storage = const FlutterSecureStorage();

  Future saveMkopo(
      vehicle_number,
      coverage,
      phone,
      id_type,
      id_number,
      bima_pkg_id,
      payment_method,
      vehicle_type,
      bima_ya_chombo_loan_type_id) async {
    final data = {
      "reg": vehicle_number,
      "coverage": coverage,
      "phone": phone,
      "id_type": id_type,
      "id_number": id_number,
      "bima_ya_chombo_package_id": bima_pkg_id,
      "payment_method_id": payment_method,
      "vehicle_type_id": vehicle_type,
      "bima_ya_chombo_loan_type_id": bima_ya_chombo_loan_type_id,
    };

    // print("Data to send :: ${data}");

    var token = await _storage.read(key: 'token');
    // print("Token :: ${token}");

    try {
      final response = await http.post(
          Uri.parse('$baseUrl/bima-ya-chombo/create/installments'),
          body: jsonEncode(data),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });

      // print(
      // "Code  :: ${response.statusCode} from this response :: ${response} response :: ${response.body} ");

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          jsonDecode(response.body)['status']) { 
        // Introduce a 5-second delay before making the payment request
        await Future.delayed(Duration(seconds: 5));
        // print(
        //     "Code  :: ${response.statusCode} from this response :: ${response} response :: ${response.body} ");
        var res = await makePaymentOfLoanRequested(
            jsonDecode(response.body)['loan_id']);
        // print("mkopo create res :: ${jsonDecode(response.body)}");

        // print("Payment response :: ${res}");

        if (res['message'] == "success" || res['message'] == "processing") {
          return {
            "status": "success",
            "message": "Malipo yanafanyiwa kazi ",
            "provider_message": jsonDecode(response.body)['responseStatusDesc'],
            // "loan_id": jsonDecode(response.body)['loan']['id']
            "loan_id": jsonDecode(response.body)['loan_id']
          };
        } else {
          return {
            "status": "fail",
            "message": res['message'],
            "provider_message": jsonDecode(response.body)['responseStatusDesc'],
            "loan_id": jsonDecode(response.body)['loan_id']
          };
        }

        // return {
        //   "status": "success",
        //   "message": jsonDecode(response.body)['message']
        // };
      } else {
        // return jsonDecode(response.body)['message'];
        return {
          "status": "fail",
          "message":
              "mkopo wako haujafanikiwa : ${jsonDecode(response.body)['message']}"
        };
      }
    } catch (error) {
      print("Catched error ::: $error");
      return {
        "status": "error",
        "message":
            "Samahani kuna tatizo la kimtandao, mkopo wako haujafanikiwa. Jaribu tena baadae "
      };
    }
  }

  Future makePaymentOfLoanRequested(int? loanId) async {
    var token = await _storage.read(key: 'token');

    final response = await http.post(
      Uri.parse('$baseUrl/bima-ya-chombo/make_payment/$loanId'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    // print(
    //     "Response of Payment:: ${response.body} with code ${response.statusCode}");

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        jsonDecode(response.body)['message'] == "success") {
      return {
        "status": "success",
        "message": jsonDecode(response.body)['message'],
      };
    } else {
      return {
        "status": "fail",
        "message": jsonDecode(response.body)
        // "message": "Payment failed"
      };
    }
  }

  Future paymentStatus(int? loanId) async {
    var token = await _storage.read(key: 'token');

    final response = await http.post(
      Uri.parse('$baseUrl/bima-ya-chombo/is_paid/$loanId'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    // print(
    //     "Response of Payment Status checker :: ${response.body} with code ${response.statusCode}");

    if ((response.statusCode == 200) &&
        jsonDecode(response.body)['status'] == 202) {
      return {
        "status": "success",
        "message": jsonDecode(response.body)['message']
        // "message": response.body
      };
    } else {
      return {
        "status": "fail",
        "message": jsonDecode(response.body)['message']
      };
      // return {"status": "fail", "message": "Payment failed"};
    }
  }

  Future installmentPayment(String? phone, String? installmentId) async {
    var token = await _storage.read(key: 'token');

    print("Data for payment :: ${phone} :: ${installmentId}");
    try {
      var body = jsonEncode({
        "phone": formatPhoneNumber(phone!),
      });
      final response = await http.post(
          Uri.parse('$baseUrl/installments/${installmentId}/payment'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          // body: jsonEncode({
          //   "phone": formatPhoneNumber(phone!),
          // })

          body: body);

      // print(
      //     "Data sent ${body} Response of Installment Payment :: ${response.body} with code ${response.statusCode}");
      if ((response.statusCode == 200) &&
          jsonDecode(response.body)['status'] == 202) {
        return {
          "status": "success",
          "message": jsonDecode(response.body)['message'],
          // "payment_id": jsonDecode(response.body)['payment']['id'],
          // "installment_id": jsonDecode(response.body)['installmentId']
        };
      } else {
        return {"status": "fail", "message": jsonDecode(response.body)};
      }
    } catch (error) {
      return {
        "status": "error",
        "message": "Malipo yameshindikana, kuna tatizo la kimtandao"
      };
    }
  }

  Future installmentPaymentChecker(String installmentId, int paymentId) async {
    var token = await _storage.read(key: 'token');
    final response = await http.get(
        Uri.parse('$baseUrl/payment/${paymentId}/status/${installmentId}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    // print(
    //     "Response of Installment Payment :: ${response.body} with code ${response.statusCode}");
    if ((response.statusCode == 200) &&
        jsonDecode(response.body)['status'] == 202) {
      return {
        "status": "success",
        "message": jsonDecode(response.body)['message']
      };
    } else {
      return {
        "status": "fail",
        "message": jsonDecode(response.body)['message']
      };
    }
  }

  Future verifyChombo(String vehicleReg) async {
    // var token = await getToken();
    // print("VEHICLE TO VERIFY :: ${vehicleReg.trim()}  cleanred :: ${cleanPlate(vehicleReg)}");

    try {
      final response = await http.post(
        Uri.parse('https://portal.bimakwik.com/api/tra-motor-search'),
        body: jsonEncode({
          "motor_category": 1,
          "motor_registration_number": cleanPlate(vehicleReg)
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token'
          'Authorization':
              'Bearer 7629|93XhrHBQe9B3e6cVvp8ORrgspjFTkHEd3JhgqBNS'
        },
      );

      // print(
      //     "response status code ${response.statusCode} and ${jsonDecode(response.body)['MotorVerificationRes']['VerificationHdr']['ResponseStatusCode']} esponse BODY:: ${response.body}  FROMR thisr response $response");
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          jsonDecode(response.body)['MotorVerificationRes']['VerificationHdr']
                  ['ResponseStatusCode'] ==
              "TIRA001") {
        // final motorVerificationRes = MotorVerificationRes.fromJson(
        //     jsonDecode(response.body)['MotorVerificationRes']);
        // print('suuccess');
        return {
          "status": "success",
          "message": jsonDecode(response.body)['MotorVerificationRes']
              ['VerificationHdr']['ResponseStatusDesc'],
          // "data": motorVerificationRes
          "data": jsonDecode(response.body)['MotorVerificationRes']
              ['VerificationDtl']
        };
      } else {
        // print("fail");
        return {
          "status": "fail",
          "message": jsonDecode(response.body)['MotorVerificationRes']
              ['VerificationHdr']['ResponseStatusDesc']
        };
      }
    } catch (error) {
      return {"status": "error", "message": "Failed to verify vehicle"};
    }
  }

  Future getToken() async {
    final response = await http.post(
        Uri.parse('http://portal.bimakwik.com/api/get-Token'),
        body: jsonEncode({"username": "humtech", "password": "123456"}),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        });
    return jsonDecode(response.body);

    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   return {"status": "success", "message": jsonDecode(response.body)};
    // } else {
    //   return {"status": "fail", "message": jsonDecode(response.body)};
    // }
  }

  Future<LoanModel?> getUserLoans() async {
    var token = await _storage.read(key: 'token');
    // print("Loan user token ${token}");

    var res = await http.get(
      Uri.parse('$baseUrl/bima-ya-chombo/user/loans'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    String jsonString = res.body;
    final jsonResponse = json.decode(jsonString);

    // print("User loans :: ${jsonResponse}");

    if (jsonResponse['data'] == null ||
        (jsonResponse['data'] as List).isEmpty) {
      return null; // Return null if no loans exist
    } else {
      // Assuming the data is already sorted in descending order of creation
      final lastLoan = jsonResponse['data'].first;

      // Convert the last loan to LoanModel
      return LoanModel.fromJson(lastLoan);
    }
  }

  Future getInstallments(int loanId) async {
    var token = await _storage.read(key: 'token');

    var res = await http.get(
      Uri.parse('$baseUrl/bima-ya-chombo/loans/$loanId/installments'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    String jsonString = res.body;
    final jsonResponse = json.decode(jsonString);

    // print("Installments :: ${jsonResponse}");

    if (jsonResponse['data'] == null) {
      // print("empty");
      return [];
    } else {
      return jsonResponse['data'];
    }
  }

// STEP 2
  Future checkCovernoteInfo(int? covernote_id) async {
    var res = await http.post(
        Uri.parse(
            "https://portal.bimakwik.com/api/get-motor-cover/${covernote_id}"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 2907|8AtZ7ElfVW9euMMmsYqdmOx5PhUfMkyRWIrKJaCm'
        });
    String jsonString = res.body;
    final jsonResponse = json.decode(jsonString);
    // print("Covenote check Info :: ${jsonResponse}");
    if (jsonResponse['MotorCoverNoteRefReqAck']['AcknowledgementStatusCode'] ==
        "TIRA001") {
      // return {
      //   "status": "success",
      //   "message": "successfully verified covernote",
      //   "covernote_id": covernote_id,
      // };
      var result = await checkCoverTransactionInfo(covernote_id!);
      // print("result :: $result");
      if (result['status'] == "success") {
        return {
          "status": "success",
          "message": "successfully verified covernote",
          "covernote_id": covernote_id,
        };
      } else {
        return {
          "status": "fail",
          "message":
              "imeshindikana kuhakiki, covernote yako hivyo huezi kupata nakala",
        };
      }
    } else {
      return {
        "status": "fail",
        "message": "failed to verify covernote",
      };
    }
  }

  Future checkCoverTransactionInfo(int covernote_id) async {
    var res = await http.post(
        Uri.parse(
            "https://portal.bimakwik.com/api/transaction-info/${covernote_id}"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 2907|8AtZ7ElfVW9euMMmsYqdmOx5PhUfMkyRWIrKJaCm'
        });
    String jsonString = res.body;
    final jsonResponse = json.decode(jsonString);
    // print("Transaction Info :: ${jsonResponse}");
    if (jsonResponse['transaction']['response_status_code'] == 'TIRA001') {
      return {
        "status": "success",
        "message": "Success, new covenote exist obtained "
      };
    } else {
      return {
        "status": "fail",
        "message": "failed to verify Transaction for covernote",
      };
    }
  }
}


 // Future<List<LoanModel>> getUserLoans() async {
  //   var token = await _storage.read(key: 'token');

  //   var res = await http.get(
  //     Uri.parse('$baseUrl/bima-ya-chombo/user/loans'),
  //     headers: {
  //       'Accept': 'application/json',
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token'
  //     },
  //   );

  //   String jsonString = res.body;
  //   final jsonResponse = json.decode(jsonString);
  //   print("User loans :: ${jsonResponse}");
  //   if (jsonResponse['data'] == null) {
  //     return [];
  //   } else {
  //     return (jsonResponse['data'] as List)
  //         .map((item) => LoanModel.fromJson(item))
  //         .toList();
  //   }
  // }
