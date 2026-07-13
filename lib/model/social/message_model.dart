
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../global/environment.dart';


class MessageListModel {

  int id;
  String? img;
  String? gp_img;
  String? name;
  String? message;
  String? lastSeen;
  String? senderName;
  String? senderLastName;
  bool? isActive;
  List<BHMessageModel>? messages;

  MessageListModel({required this.id,this.img, this.name, this.message, this.lastSeen, this.isActive,this.messages,this.senderName,this.senderLastName,this.gp_img});

  factory MessageListModel.fromJson(Map<String, dynamic> json) => MessageListModel(
    id:             json["id"],
    img:            json["img"],
    name:           json["name"],
    gp_img:          json["senders"] == null ? 'null': json["senders"]['last_name'],
    message:         json["last_message"] == null ? 'No Messages':json["last_message"]['text'],
    senderName:      json["senders"] == null ? 'null': json["senders"]['first_name'],
    senderLastName:  json["senders"] == null ? 'null': json["senders"]['last_name'],
    lastSeen: json['last_message']  == null ? DateFormat('yyyy-MM-ddTkk:mm:ss').format(DateTime.now()):json["last_message"]["created_at"]!,
    isActive: json["status"] == 'active' ? true : false,
    messages: json['messages'] != null ? (json['messages'] as List).map((i) => BHMessageModel.fromJson(i)).toList() : null,
  );
}

class BHMessageModel {
  int? senderId;
  String? senderName;
  int? receiverId;
  String? msg;
  String? time;

  BHMessageModel({this.senderId, this.receiverId, this.msg, this.time,this.senderName});

  factory BHMessageModel.fromJson(Map<String, dynamic> json) => BHMessageModel(
    senderId:   json["sender"]['user_id'],
    senderName: json["sender"]['user']['first_name'],
    receiverId: json["receiver_device_id"] == null ? 2 : 2,
    msg:        json["text"],
    time:       json["created_at"],

  );

  factory BHMessageModel.fromFileJson(Map<String, dynamic> json) => BHMessageModel(
    senderId:   json["sender_id"],
    senderName: json["sender_name"],
    receiverId: json["receiver_id"],
    msg:        json["text"],
    time:       json["created_at"],

  );

  static Map<String, dynamic> toMap(BHMessageModel message) => {
    'sender_id':    message.senderId,
    'sender_name':    message.senderName,
    'receiver_id':  message.receiverId,
    'text':         message.msg,
    'created_at':   message.time,
  };

  static String encode(List<BHMessageModel> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => BHMessageModel.toMap(music))
            .toList(),
      );

  static List<BHMessageModel> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<BHMessageModel>((item) => BHMessageModel.fromFileJson(item))
          .toList();
}

Future<List<MessageListModel>> loadConversation() async {
  const _storage = FlutterSecureStorage();
  var groups;

  var old_groups = await _storage.read(key: 'all_conversations');

  if (old_groups != null){
    groups = jsonDecode(old_groups);
  }

  loadOnlineConversation().ignore();

  return (groups as List).map((i) => MessageListModel.fromJson(i)).toList();
}


  Future<List<MessageListModel>> loadOnlineConversation() async {
  const _storage = FlutterSecureStorage();

  var token = await _storage.read(key: 'token');

  final response = await http.get(Uri.parse('${Environment.apiUrl}/chat/my_conversations'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  await _storage.write(key: 'all_conversations', value: jsonEncode(jsonResponse));

  return (jsonResponse as List).map((i) => MessageListModel.fromJson(i)).toList();
}

Future loadOnlineConversationN(cursor) async {
  const _storage = FlutterSecureStorage();

  var token = await _storage.read(key: 'token');

  var url_cursor = cursor == '' || cursor == null ? '' : '?cursor=$cursor';

  final response = await http.get(Uri.parse('${Environment.apiUrl}/chat/my_conversations_new$url_cursor'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  var pr_pg = jsonResponse['groups']['per_page'];


  List<MessageListModel> newGroups = (jsonResponse['groups']['data'] as List).map((i) => MessageListModel.fromJson(i)).toList();

  Notifiers(newGroups).ignore;

  return [newGroups,pr_pg,jsonResponse['groups']['next_cursor']];
}

Future<void> Notifiers(groups) async {
  for(final e in groups){
    var group = e;
    await FirebaseMessaging.instance.subscribeToTopic("${group.id}_group");
  }
}

Future<List<MessageListModel>> loadGroups() async {

  print('loading Group');

  const _storage = FlutterSecureStorage();
  var groups;

  var old_groups = await _storage.read(key: 'all_groups');

  if (old_groups != null){
    print('loading Old Group');
    groups = jsonDecode(old_groups);
  }


  loadOnlineGroups().ignore();
  print('loading new Group');

  List<MessageListModel> myGroups = [];

  myGroups.addAll((groups as List).map((i) => MessageListModel.fromJson(i)).toList());

  for(final e in myGroups){
    var group = e;
    print(group.id);
    await FirebaseMessaging.instance.subscribeToTopic("${group.id}_group");
  }

  return (groups).map((i) => MessageListModel.fromJson(i)).toList();
}


Future<List<MessageListModel>> loadOnlineGroups() async {
  const _storage = FlutterSecureStorage();

  var token = await _storage.read(key: 'token');

  final response = await http.get(Uri.parse('${Environment.apiUrl}/chat/my_groups'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  await _storage.write(key: 'all_groups', value: jsonEncode(jsonResponse));


  return (jsonResponse as List).map((i) => MessageListModel.fromJson(i)).toList();
}

Future loadOnlineGroupsN(cursor) async {
  const _storage = FlutterSecureStorage();

  var token = await _storage.read(key: 'token');

  var url_cursor = cursor == '' || cursor == null ? '' : '?cursor=$cursor';

  final response = await http.get(Uri.parse('${Environment.apiUrl}/chat/my_groups_new$url_cursor'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  var pr_pg = jsonResponse['groups']['per_page'];

  List<MessageListModel> newGroups = (jsonResponse['groups']['data'] as List).map((i) => MessageListModel.fromJson(i)).toList();

  Notifiers(newGroups).ignore;

  return [newGroups,pr_pg,jsonResponse['groups']['next_cursor']];
}


class DirectMessageModel {
  int? senderId;
  String? senderName;
  int? receiverId;
  String? msg;
  String? time;

  DirectMessageModel({this.senderId, this.receiverId, this.msg, this.time,this.senderName});

  factory DirectMessageModel.fromJson(Map<String, dynamic> json) => DirectMessageModel(
    senderId:   json["sender_id"],
    senderName: json["receiver_id"],
    receiverId: json["receiver_id"] == null ? 2 : 2,
    msg:        json["text"],
    time:       json["created_at"],

  );
}

Future loadOnlineDirectMessages() async {
  const _storage = FlutterSecureStorage();

  var token = await _storage.read(key: 'token');

  final response = await http.get(Uri.parse('${Environment.apiUrl}/chat/get_direct_messages'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  Map<String, dynamic> phpResp = json.decode(response.body);

  print(phpResp);

  // print(jsonResponse);

  await _storage.write(key: 'all_dms', value: jsonEncode(jsonResponse));

  return (phpResp as List).map((i) => DirectMessageModel.fromJson(i)).toList();
}