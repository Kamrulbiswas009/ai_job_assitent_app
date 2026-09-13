import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/response_data.dart';

class NetworkCaller {
  final int timeoutDuration = 20;

  // GET method
  Future<ResponseData> getRequest(String url, {String? token}) async {
    debugPrint('==================== [GET REQUEST] ====================');
    debugPrint('URL: $url');
    if (token != null) debugPrint('Token: $token');
    log('GET Request: $url');

    try {
      final Response response = await get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          if (token != null && token.isNotEmpty)
            'Authorization': token.startsWith('Bearer ') ? token : 'Bearer $token',
        },
      ).timeout(
        Duration(seconds: timeoutDuration),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // POST method
  Future<ResponseData> postRequest(
    String url, {
    dynamic body,
    String? token,
  }) async {
    final bodyString = body != null ? jsonEncode(body) : '';
    final logBody = _formatSanitizedBody(body);
    debugPrint('==================== [POST REQUEST] ====================');
    debugPrint('URL: $url');
    debugPrint('Body: $logBody');
    if (token != null) debugPrint('Token: $token');
    log('POST Request: $url, Body: $logBody');

    try {
      final Response response = await post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          if (token != null && token.isNotEmpty)
            'Authorization': token.startsWith('Bearer ') ? token : 'Bearer $token',
        },
        body: bodyString.isNotEmpty ? bodyString : null,
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Handle response
  ResponseData _handleResponse(Response response) {
    final logResponseBody = _formatSanitizedBody(response.body);
    debugPrint('==================== [API RESPONSE] ====================');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: $logResponseBody');
    log('Response Code: ${response.statusCode}, Body: $logResponseBody');

    dynamic decodedResponse;
    try {
      decodedResponse = jsonDecode(response.body);
    } catch (e) {
      decodedResponse = response.body;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ResponseData(
        isSuccess: true,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage: '',
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      String errorMessage = 'Validation error';
      if (decodedResponse is Map) {
        if (decodedResponse['errorSources'] != null) {
          errorMessage = _extractErrorMessages(decodedResponse['errorSources']);
        } else if (decodedResponse['message'] != null) {
          errorMessage = decodedResponse['message'].toString();
        }
      }
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage: errorMessage,
      );
    } else if (response.statusCode == 401) {
      String errorMessage = 'Unauthorized';
      if (decodedResponse is Map && decodedResponse['message'] != null) {
        errorMessage = decodedResponse['message'].toString();
      }
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage: errorMessage,
      );
    } else {
      String errorMessage = 'An unexpected error occurred!';
      if (decodedResponse is Map && decodedResponse['message'] != null) {
        errorMessage = decodedResponse['message'].toString();
      }
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage: errorMessage,
      );
    }
  }

  // Extract error messages for status 400
  String _extractErrorMessages(dynamic errorSources) {
    if (errorSources is List) {
      return errorSources
          .map((error) => error['message'] ?? 'Unknown error')
          .join(', ');
    }
    return 'Validation error';
  }

  // Handle errors
  ResponseData _handleError(dynamic error) {
    debugPrint('==================== [REQUEST ERROR] ====================');
    debugPrint('Error: $error');
    log('Request Error: $error');

    if (error is SocketException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: '',
        errorMessage: 'Network error: Unable to reach server. Please check your internet connection.',
      );
    } else if (error is ClientException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: '',
        errorMessage: 'Network error occurred. Please check your connection.',
      );
    } else if (error is TimeoutException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        responseData: '',
        errorMessage: 'Request timeout. Please try again later.',
      );
    } else {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: '',
        errorMessage: 'Unexpected error occurred: $error',
      );
    }
  }

  // Format and sanitize body to mask passwords and sensitive values
  String _formatSanitizedBody(dynamic body) {
    if (body == null) return '';
    try {
      if (body is String) {
        final trimmed = body.trim();
        if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
          final decoded = jsonDecode(trimmed);
          return jsonEncode(_sanitizeData(decoded));
        }
        return body;
      }
      return jsonEncode(_sanitizeData(body));
    } catch (_) {
      return body.toString();
    }
  }

  // Sanitizes sensitive fields like passwords from logging
  dynamic _sanitizeData(dynamic data) {
    if (data is Map) {
      final sanitized = <String, dynamic>{};
      data.forEach((key, value) {
        final keyLower =
            key.toString().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
        if (keyLower.contains('password')) {
          sanitized[key.toString()] = '******';
        } else if (value is Map || value is List) {
          sanitized[key.toString()] = _sanitizeData(value);
        } else {
          sanitized[key.toString()] = value;
        }
      });
      return sanitized;
    } else if (data is List) {
      return data.map((item) => _sanitizeData(item)).toList();
    }
    return data;
  }
}