import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'latra_api_service.dart';

class LAConfig {
  static const String baseUrl = 'https://mfumo.shirikisho.co.tz/api';
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'token'; // matches AuthService._saveToken()

  /// Agent's UID for LATRA calls that require it (e.g. service-types lookup,
  /// applications/bills). Confirmed working value from curl testing.
  /// TODO: if agents differ per logged-in user, read this from user profile
  /// storage instead of hardcoding — see AuthService's 'user_id' key.
  static const String agentUid = 'b8ef2f94-97c0-4a19-ac15-e71812900819';

  static LatraApiService buildService() {
    return LatraApiService(
      baseUrl: baseUrl,
      getAppAuthToken: () async => await _storage.read(key: _tokenKey) ?? '',
    );
  }
}