
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../global/environment.dart';

import 'package:http/http.dart' as http;

import '../model/user_model.dart';


class UserService with ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  Future getUser() async {

    var token = await _storage.read(key: 'token');

    final response = await http.post(Uri.parse('${Environment.apiUrl}/get/current_user'),
        headers: {'Accept': 'application/json','Content-Type': 'application/json','Authorization':'Bearer $token'}
    );

    if (response.statusCode == 200) {
      String jsonString = response.body;
      print(jsonString);
      final jsonResponse = json.decode(jsonString);
      (jsonResponse as List).map((i) => UserModule.fromJson(i)).toList();

      return true;

    } else {
      return jsonDecode(response.body)['message'];
    }

  }
}

