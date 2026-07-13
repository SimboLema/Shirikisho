import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../../global/environment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


Future<String> loadContentAsset(String path) async {
  return await rootBundle.loadString(path);
}

Future<ByteData> loadContentAssetNetwork(String path) async {
  return await rootBundle.load(path);
}


Future applyLoan(loan,rDays,dDays,notes) async {
  const storage = FlutterSecureStorage();
  var token = await storage.read(key: 'token');


  final request = {'loan': loan,'payment_recurrence_days': rDays,'loan_duration_days': dDays,'other': notes,'is_app':true};

  final response = await http.post(Uri.parse('${Environment.apiUrl}/applications/apply'),
      body: jsonEncode(request),
      headers: {'Accept': 'application/json','Content-Type': 'application/json','Authorization':'Bearer $token'});

  if (response.statusCode == 200) {
    print('done');
      return true;
    } else {
      return jsonDecode(response.body)['message'];
    }
}

Future<int> updateProgress(key,score) async {
  const _storage = FlutterSecureStorage();

  var token = await _storage.read(key: 'token');

  final response = await http.post(Uri.parse('${Environment.apiUrl}/update_video_progress'),
          body: {'key': key,'score': score},
          headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'});

  return 200;
}


// Future<List<Course>> loadCoursesOnline() async {
//   String jsonString = (await loadContentAssetNetwork('$MtuliUrl/api/courses')) as String;
//   final jsonResponse = json.decode(jsonString);
//   return (jsonResponse as List).map((i) => Course.fromJson(i)).toList();
// }