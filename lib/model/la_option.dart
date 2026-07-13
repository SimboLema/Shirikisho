/// Generic {uid, name} pair used for every dropdown (regions, districts,
/// stations, license types, durations, service types, countries).
///
/// NOTE: the docs don't show sample response bodies for the lookup
/// endpoints. Once you've hit them in Postman, check the real field names
/// (might be "uid"/"name", or "id"/"description", etc.) and adjust
/// [LAOption.fromJson] below accordingly — this is the ONE place to fix it.
class LAOption {
  final String uid;
  final String name;

  LAOption({required this.uid, required this.name});

  factory LAOption.fromJson(Map<String, dynamic> json) {
    // Confirmed real field names from live LATRA responses (2026-07-02):
    // regions/districts/license-types/durations/service-types all use
    // {"name": ..., "id": ..., "uid": ...}; /country matches too.
    final uid = json['uid'] ?? json['id'] ?? '';
    final name = json['name'] ?? uid;
    return LAOption(uid: uid.toString(), name: name.toString());
  }

  /// Response wrappers vary ({"data": [...]}, {"result": [...]}, a bare
  /// list, OR a single bare object like /country -> {"name":"Tanzania","uid":"..."}).
  static List<LAOption> parseList(dynamic body) {
    List<dynamic> raw;
    if (body is List) {
      raw = body;
    } else if (body is Map<String, dynamic>) {
      if (body['data'] is List) {
        raw = body['data'] as List;
      } else if (body['result'] is List) {
        raw = body['result'] as List;
      } else if (body['items'] is List) {
        raw = body['items'] as List;
      } else if (body.containsKey('uid') || body.containsKey('id')) {
        // Single bare object response (e.g. /country) — treat as a 1-item list.
        raw = [body];
      } else {
        raw = [];
      }
    } else {
      raw = [];
    }
    return raw
        .whereType<Map<String, dynamic>>()
        .map((e) => LAOption.fromJson(e))
        .toList();
  }
}