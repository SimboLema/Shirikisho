import 'dart:async';
import 'dart:convert';


import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


import '../global/environment.dart';
import '../model/social/message_model.dart';


  final _storage = const FlutterSecureStorage();

  Future<dynamic> getMyGroups() async {
    var token = await _storage.read(key: 'token');

    final Map<String, String> nHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final verResp = await http.get(Uri.parse('${Environment.apiUrl}/chat/my_groups'), headers: nHeaders);

    var response = jsonDecode(verResp.body);

    var _licenseResponse = [verResp.statusCode,response];

    return _licenseResponse;

  }


Future SendMessage(message,sender_id,group_id) async {
  const storage = FlutterSecureStorage();

  var token = await storage.read(key: 'token');
  var data = jsonEncode({
        'message': message,
        'sender_id': sender_id,
        'group_id': group_id,
      });

  final response = await http.post(Uri.parse('${Environment.apiUrl}/chat/send_message'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body:data
  );

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  print(jsonResponse['message']);
}

Future  SendDirectMessage(message,sender_id,receiver_id,{group_id = null}) async {
  const storage = FlutterSecureStorage();

  var token = await storage.read(key: 'token');
  var data = jsonEncode({
        'text':     message,
        'from_id':  sender_id,
        'to_id':    receiver_id,
        'group_id': group_id,
      });

  final response = await http.post(Uri.parse('${Environment.apiUrl}/chat/send_direct_message'),
      headers: {'Content-Type': 'application/json','Accept':'application/json', 'Authorization': 'Bearer $token'},
      body:data
  );

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  return [jsonResponse['message'], MessageListModel.fromJson(jsonResponse['group'])];
}
