import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


import '../../../global/environment.dart';

class PostModel {
  int id;
  String name;
  String? address;
  String? profileImage;
  String? postImage;
  String? time;
  String? description;
  double? aspect_ratio;
  int? commentCount;
  String? type;
  bool? like;
  int all_comments;
  int all_likes;
  List<PostCommentModule>? comments;

  PostModel({required this.id,required this.name, this.profileImage, this.postImage, this.time,
    this.description, this.commentCount, this.like, required this.all_comments,
    required this.all_likes,this.comments,this.address,this.type,this.aspect_ratio
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id:          json["id"],
    name:          json["user"]['first_name'],
    address:  json["user"]['address'],
    profileImage: '${json['user']['image_url']}',
    time:         json['created_at'],
    postImage:    json['file'],
    aspect_ratio:  json['aspect_ratio'] != null ? json['aspect_ratio'].toDouble() : null,
    description:  json['text'],
    type:         json['status'],
    all_comments:  json['all_comments'],
    all_likes:  json['all_likes'],
    commentCount: 2,
    like: json['my_like'],

    comments: json['comments'] != null ? (json['comments'] as List).map((i) => PostCommentModule.fromJson(i)).toList() : null,
  );
}


class PostCommentModule {
  int id;
  int post_id;
  String? name;
  String? profileImage;
  String? time;
  String? comment;
  int likeCount;
  bool? isCommentReply;
  bool like;
  List<PostCommentModule>? replay;

  PostCommentModule({required this.id,required this.post_id, required this.comment,
    this.profileImage,this.time,this.name,this.isCommentReply,required this.like,
    this.replay,required this.likeCount});

  factory PostCommentModule.fromJson(Map<String, dynamic> json) => PostCommentModule(
    id:       json["id"],
    post_id:  json["post_id"],
    name:     json["user"]['first_name'],
    profileImage: json["user"]['image'] == null ? '' : json["user"]['image']['image_url'],
    time: json["created_at"],
    comment: json["comment"],
    likeCount: json["likes"].length,
    isCommentReply: json["parent_comment_id"] == null ? false : true,
    like: json["my_like"],
    replay: json['replays'] != null ? (json['replays'] as List).map((i) => PostCommentModule.fromJson(i)).toList() : null,
  );

  Map<String, dynamic> toJson() => {
    "text":    id,
    "file":  comment,
  };
}


Future loadPosts(cursor) async {
  const _storage = FlutterSecureStorage();

  var old_posts = await _storage.read(key: 'all_posts');
  var per_page = await _storage.read(key: 'per_page');
  var next_cursor = await _storage.read(key: 'next_cursor');

  if (old_posts != null){
    loadOnlinePosts(cursor).ignore;
    var posts = jsonDecode(old_posts);
    print(next_cursor);

    return [(posts as List).map((i) => PostModel.fromJson(i)).toList(),3,next_cursor];
  }else{
    var res = await loadOnlinePosts(cursor);
    var posts = res[0];
    per_page = res[1];
    next_cursor = res[2];
  return [posts,per_page,next_cursor];
  }

}


Future loadOnlinePosts(cursor) async {
  const _storage = FlutterSecureStorage();

  var token = await _storage.read(key: 'token');

  var url_cursor = cursor == '' || cursor == null ? '' : '?cursor=$cursor';

  final response = await http.get(Uri.parse('${Environment.apiUrl}/chat/get_posts_new$url_cursor'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

  String jsonString = response.body;

  final jsonResponse = json.decode(jsonString);

  var pr_pg = jsonResponse['posts']['per_page'];

  print(pr_pg);

  await _storage.write(key: 'all_posts', value: jsonEncode(jsonResponse['posts']['data']));
  await _storage.write(key: 'per_page', value: '$pr_pg');
  await _storage.write(key: 'next_cursor', value: jsonResponse['posts']['next_cursor']);

  // print(jsonResponse['posts']['next_cursor']);

  List<PostModel> newPosts = (jsonResponse['posts']['data'] as List).map((i) => PostModel.fromJson(i)).toList();

  return [newPosts,pr_pg,jsonResponse['posts']['next_cursor']];

}

Future uploadPost(text,image) async {
  const _storage = FlutterSecureStorage();

  var token = await _storage.read(key: 'token');
  var stream = http.ByteStream(image.openRead());
  var length = await image.length();


  var request = http.MultipartRequest('POST', Uri.parse('${Environment.apiUrl}/chat/send_post'));
  request.fields['text'] = '$text';
  request.files.add(http.MultipartFile('post_file', stream, length, filename: image.path));
  request.headers['Authorization'] = 'Bearer $token';
  request.headers['Accept'] = 'application/json';
  http.Response response = await http.Response.fromStream(await request.send());

  var res = [response.statusCode, json.decode(response.body)];

  // await loadPosts(null);

  return res;
}



Future<PostCommentModule> sendComment(text,post_id,{parent_comment_id = null}) async {
  const _storage = FlutterSecureStorage();

  var data = jsonEncode({
    'comment': text,
    'post_id': post_id,
    'parent_comment_id': parent_comment_id,
  });

  var token = await _storage.read(key: 'token');

  final Map<String, String> oHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final response = await http.post(Uri.parse('${Environment.apiUrl}/chat/send_post_comment'), headers: oHeaders, body: data);

  var res = json.decode(response.body);
  PostCommentModule comment = PostCommentModule.fromJson(res['comment']);
  return comment;

}

Future likePostComment(comment_id) async {
  const _storage = FlutterSecureStorage();
  var token = await _storage.read(key: 'token');

  var data = jsonEncode({
    'comment_id': comment_id,
  });

  final Map<String, String> oHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  await http.post(Uri.parse('${Environment.apiUrl}/chat/send_post_comment_like'), headers: oHeaders, body: data);
}

Future unLikePostComment(comment_id) async {
  const _storage = FlutterSecureStorage();
  var token = await _storage.read(key: 'token');

  var data = jsonEncode({
    'comment_id': comment_id,
  });

  final Map<String, String> oHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  await http.post(Uri.parse('${Environment.apiUrl}/chat/send_post_comment_unlike'), headers: oHeaders, body: data);
}


Future likePost(post_id) async {
  const _storage = FlutterSecureStorage();
  var token = await _storage.read(key: 'token');

  var data = jsonEncode({
    'post_id': post_id,
  });

  final Map<String, String> oHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  await http.post(Uri.parse('${Environment.apiUrl}/chat/send_post_like'), headers: oHeaders, body: data);
}

Future unLikePost(post_id) async {
  const _storage = FlutterSecureStorage();
  var token = await _storage.read(key: 'token');

  var data = jsonEncode({
    'post_id': post_id,
  });

  final Map<String, String> oHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  await http.post(Uri.parse('${Environment.apiUrl}/chat/send_post_unlike'), headers: oHeaders, body: data);
}