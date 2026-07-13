import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Environment {
  // static String apiUrl = "http://192.168.1.24:8000/api";
  // static String imageUrl = "http://192.168.1.24:8000/";

  static String apiUrl = kIsWeb
      ? 'http://localhost:3000/api' // for Web http://192.168.1.24:8000/api"
      : Platform.isAndroid
          ? 'https://mfumo.shirikisho.co.tz/api' // for Android
          // ? "http://:8000/api"
          : 'https://mfumo.shirikisho.co.tz/api'; // for Others

  static String imageUrl = kIsWeb
      ? 'http://localhost:3000/api' // for Web
      : Platform.isAndroid
          ? 'https://mfumo.shirikisho.co.tz' // for Android
          : 'https://mfumo.shirikisho.co.tz'; // for Others

  static String socketUrl = kIsWeb
      ? 'http://localhost:3000' // for Web
      : Platform.isAndroid
          ? 'http://10.0.2.2:3000' // for Android
          : 'http://localhost:3000'; // for Others
}

const OldBaseUrl = 'https://assets.iqonic.design/old-themeforest-images/prokit';

const t14_profile1 = "assets/images/helment.png";
const t14_profile2 = "assets/images/helment.png";
const t14_profile3 = "assets/images/helment.png";
const t14_profile4 = "assets/images/helment.png";

var BHSender_id = getUserId();

var IsLeader = false;
var IsDriver = false;

const BHReceiver_id = 2;

final _storage = const FlutterSecureStorage();

Future<dynamic> getUserId() async {
  var user_id = await _storage.read(key: 'user_id');
  print('id was ${int.parse((user_id as String))}');
  return int.parse(user_id);
}
