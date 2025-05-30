import 'dart:convert';
import 'package:checkout_flow_plugin/network/network_config.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String _baseUrl;
  final NetworkConfig config;
  final http.Client _client;
  final Map<String, String> _headers;

  ApiClient({
    required this.config,
    http.Client? client,
    Map<String, String>? headers,
  })  : _baseUrl = config.baseUrl,
        _client = client ?? http.Client(),
        _headers = headers ?? config.defaultHeaders;

  Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: queryParams);
      final response = await _client.get(uri, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      debugPrint('GET request failed: $e');
      return null;
    }
  }

  Future<dynamic> post(String endpoint, {dynamic body,Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await _client.post(
        uri,
        headers: {
          ..._headers,
          ...?headers
        },
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      debugPrint('POST request failed: $e');
      return null;
    }
  }

  Future<dynamic> put(String endpoint, {dynamic body}) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await _client.put(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      debugPrint('PUT request failed: $e');
      return null;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await _client.delete(uri, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      debugPrint('DELETE request failed: $e');
      return null;
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      debugPrint('Request failed with status: ${response.statusCode}');
      return null;
      // throw ApiException(
      //   'Request failed with status: ${response.statusCode}',
      //   statusCode: response.statusCode,
      //   response: response.body,
      // );
    }
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? response;

  ApiException(this.message, {this.statusCode, this.response});

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
} 