import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shirikisho/global/appConstants.dart';

// import 'package:flutter_project_template/constants/app_constants.dart';

class ApiClientDio {
  String baseUrl = AppConstants.apiBaseUrl;

  final Dio dio;

  ApiClientDio() : dio = Dio(BaseOptions());

  Future<dynamic> getRequest(String endpoint) async {
    try {
      final response = await dio.get(endpoint);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform GET request: $e');
    }
  }

  // Future<dynamic> postRequest(String endpoint, dynamic data) async {
  //   try {
  //     FormData formData = FormData.fromMap(data);
  //     final response = await dio.post(baseUrl + endpoint, data: formData);
  //     return _handleResponse(response);
  //   } catch (e) {
  //     throw Exception('Failed to perform POST request: $e');
  //   }
  // }
  Future<dynamic> postRequest(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    try {
      if (headers != null) {
        dio.options.headers
            .addAll(headers); // Add headers dynamically if provided
      }
      FormData formData = FormData.fromMap(data);
      final response = await dio.post(baseUrl + endpoint, data: formData);

      // print("end poinsss ${baseUrl + endpoint}");
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform POST request: $e');
    }
  }

  Future<dynamic> putRequest(String endpoint, dynamic data) async {
    try {
      final response = await dio.put(endpoint, data: data);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform PUT request: $e');
    }
  }

  Future<dynamic> deleteRequest(String endpoint) async {
    try {
      final response = await dio.delete(endpoint);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform DELETE request: $e');
    }
  }

  Future<dynamic> postWithFile(
      String endpoint, Map<String, dynamic> data, File file) async {
    try {
      final formData = FormData.fromMap(
          {...data, 'file': await MultipartFile.fromFile(file.path)});
      final response = await dio.post(endpoint, data: formData);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform POST request with file: $e');
    }
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception(
          'Failed with status code ${response.statusCode}: ${response.data}');
    }
  }
}
