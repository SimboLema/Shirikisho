import 'dart:convert';
import 'package:http/http.dart' as http;

/// Talks to YOUR Laravel backend's /api/latra/* routes.
/// The Flutter app never sees LATRA's base_url, Basic Auth secret, or
/// OAuth token directly — those stay server-side in Laravel.
class LatraApiService {
  final String baseUrl; // e.g. https://yourapp.com/api

  /// Returns the CURRENT app auth token, read fresh each call — no reliance
  /// on a preload step running before the first request goes out.
  final Future<String> Function() getAppAuthToken;

  LatraApiService({required this.baseUrl, required this.getAppAuthToken});

  Future<Map<String, String>> _headers() async {
    final token = await getAppAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> submitApplication(
      Map<String, dynamic> payload) async {
    final res = await http.post(
      Uri.parse('$baseUrl/latra/applications'),
      headers: await _headers(),
      body: jsonEncode(payload),
    );
    return _decode(res);
  }

  Future<Map<String, dynamic>> getApplications(String agentUid) async {
    final uri = Uri.parse('$baseUrl/latra/applications')
        .replace(queryParameters: {'agentUid': agentUid});
    final res = await http.get(uri, headers: await _headers());
    return _decode(res);
  }

  Future<Map<String, dynamic>> getBills(String agentUid) async {
    final uri = Uri.parse('$baseUrl/latra/bills')
        .replace(queryParameters: {'agentUid': agentUid});
    final res = await http.get(uri, headers: await _headers());
    return _decode(res);
  }

  Future<Map<String, dynamic>> getRegions() async {
    final res = await http.get(Uri.parse('$baseUrl/latra/regions'),
        headers: await _headers());
    return _decode(res);
  }

  Future<Map<String, dynamic>> getDistricts(String regionUid) async {
    final uri = Uri.parse('$baseUrl/latra/districts')
        .replace(queryParameters: {'regionUid': regionUid});
    final res = await http.get(uri, headers: await _headers());
    return _decode(res);
  }

  Future<Map<String, dynamic>> getStations(String districtUid) async {
    final res = await http.get(
      Uri.parse('$baseUrl/latra/districts/$districtUid/stations'),
      headers: await _headers(),
    );
    return _decode(res);
  }

  Future<Map<String, dynamic>> getLicenseTypes() async {
    final res = await http.get(Uri.parse('$baseUrl/latra/license-types'),
        headers: await _headers());
    return _decode(res);
  }

  Future<Map<String, dynamic>> getLicenseDurations(
      String licenseTypeUid) async {
    final res = await http.get(
      Uri.parse('$baseUrl/latra/license-types/$licenseTypeUid/durations'),
      headers: await _headers(),
    );
    return _decode(res);
  }

  Future<Map<String, dynamic>> getServiceTypes(
      String licenseType, String agentUid) async {
    final uri = Uri.parse('$baseUrl/latra/license-types/$licenseType/service-types')
        .replace(queryParameters: {'agentUid': agentUid});
    final res = await http.get(uri, headers: await _headers());
    return _decode(res);
  }

  Future<Map<String, dynamic>> getCountries() async {
    final res = await http.get(Uri.parse('$baseUrl/latra/countries'),
        headers: await _headers());
    return _decode(res);
  }

  Map<String, dynamic> _decode(http.Response res) {
    dynamic parsed;
    try {
      parsed = jsonDecode(res.body);
    } catch (_) {
      // Body wasn't JSON at all (HTML error page, empty body, etc.)
      throw Exception(
          'Unexpected response (status ${res.statusCode}): ${res.body.substring(0, res.body.length > 200 ? 200 : res.body.length)}');
    }

    if (parsed is! Map<String, dynamic>) {
      // e.g. a bare list came back where an object was expected
      return {'data': parsed};
    }

    if (res.statusCode >= 400) {
      throw Exception(parsed['message'] ?? 'Request failed (${res.statusCode})');
    }
    return parsed;
  }
}