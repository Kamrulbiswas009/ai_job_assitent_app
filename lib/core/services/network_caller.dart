import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';

import '../../routes/app_routes.dart';
import '../models/response_data.dart';
import 'storage_service.dart';

class NetworkCaller {
  final int timeoutDuration = 20;
  static bool _isHandlingUnauthorized = false;

  // GET method
  Future<ResponseData> getRequest(String url, {String? token}) async {
    final effectiveToken = (token != null && token.isNotEmpty)
        ? token
        : StorageService.token;
    debugPrint('==================== [GET REQUEST] ====================');
    debugPrint('URL: $url');
    if (effectiveToken != null) debugPrint('Token: $effectiveToken');
    log('GET Request: $url');

    try {
      final Response response = await get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          if (effectiveToken != null && effectiveToken.isNotEmpty)
            'Authorization': effectiveToken.startsWith('Bearer ')
                ? effectiveToken
                : 'Bearer $effectiveToken',
        },
      ).timeout(
        Duration(seconds: timeoutDuration),
      );

      return _handleResponse(response, requestUrl: url);
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
    final effectiveToken = (token != null && token.isNotEmpty)
        ? token
        : StorageService.token;
    final bodyString = body != null ? jsonEncode(body) : '';
    final logBody = _formatSanitizedBody(body);
    debugPrint('==================== [POST REQUEST] ====================');
    debugPrint('URL: $url');
    debugPrint('Body: $logBody');
    if (effectiveToken != null) debugPrint('Token: $effectiveToken');
    log('POST Request: $url, Body: $logBody');

    try {
      final Response response = await post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          if (effectiveToken != null && effectiveToken.isNotEmpty)
            'Authorization': effectiveToken.startsWith('Bearer ')
                ? effectiveToken
                : 'Bearer $effectiveToken',
        },
        body: bodyString.isNotEmpty ? bodyString : null,
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response, requestUrl: url);
    } catch (e) {
      return _handleError(e);
    }
  }

  // PUT method
  Future<ResponseData> putRequest(
    String url, {
    dynamic body,
    String? token,
  }) async {
    final effectiveToken = (token != null && token.isNotEmpty)
        ? token
        : StorageService.token;
    final bodyString = body != null ? jsonEncode(body) : '';
    final logBody = _formatSanitizedBody(body);
    debugPrint('==================== [PUT REQUEST] ====================');
    debugPrint('URL: $url');
    debugPrint('Body: $logBody');
    if (effectiveToken != null) debugPrint('Token: $effectiveToken');
    log('PUT Request: $url, Body: $logBody');

    try {
      final Response response = await put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          if (effectiveToken != null && effectiveToken.isNotEmpty)
            'Authorization': effectiveToken.startsWith('Bearer ')
                ? effectiveToken
                : 'Bearer $effectiveToken',
        },
        body: bodyString.isNotEmpty ? bodyString : null,
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response, requestUrl: url);
    } catch (e) {
      return _handleError(e);
    }
  }

  // PATCH method
  Future<ResponseData> patchRequest(
    String url, {
    dynamic body,
    String? token,
  }) async {
    final effectiveToken = (token != null && token.isNotEmpty)
        ? token
        : StorageService.token;
    final bodyString = body != null ? jsonEncode(body) : '';
    final logBody = _formatSanitizedBody(body);
    debugPrint('==================== [PATCH REQUEST] ====================');
    debugPrint('URL: $url');
    debugPrint('Body: $logBody');
    if (effectiveToken != null) debugPrint('Token: $effectiveToken');
    log('PATCH Request: $url, Body: $logBody');

    try {
      final Response response = await patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          if (effectiveToken != null && effectiveToken.isNotEmpty)
            'Authorization': effectiveToken.startsWith('Bearer ')
                ? effectiveToken
                : 'Bearer $effectiveToken',
        },
        body: bodyString.isNotEmpty ? bodyString : null,
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response, requestUrl: url);
    } catch (e) {
      return _handleError(e);
    }
  }

  // DELETE method
  Future<ResponseData> deleteRequest(String url, {String? token}) async {
    final effectiveToken = (token != null && token.isNotEmpty)
        ? token
        : StorageService.token;
    debugPrint('==================== [DELETE REQUEST] ====================');
    debugPrint('URL: $url');
    if (effectiveToken != null) debugPrint('Token: $effectiveToken');
    log('DELETE Request: $url');

    try {
      final Response response = await delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          if (effectiveToken != null && effectiveToken.isNotEmpty)
            'Authorization': effectiveToken.startsWith('Bearer ')
                ? effectiveToken
                : 'Bearer $effectiveToken',
        },
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response, requestUrl: url);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Handle response
  ResponseData _handleResponse(Response response, {String? requestUrl}) {
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
      _handleUnauthorized(requestUrl: requestUrl);
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

  // Handle 401 Unauthorized: clear session and redirect to login screen
  static void _handleUnauthorized({String? requestUrl}) {
    if (_isHandlingUnauthorized) return;

    // Do not redirect if 401 occurred on auth screens/endpoints (e.g. invalid credentials on login)
    if (requestUrl != null) {
      final uri = Uri.tryParse(requestUrl);
      final path = uri?.path ?? requestUrl;
      if (path.contains('/auth/login') ||
          path.contains('/auth/register') ||
          path.contains('/auth/verify-email') ||
          path.contains('/auth/forgot-password') ||
          path.contains('/auth/reset-password')) {
        return;
      }
    }

    // Do not redirect if already on login screen
    if (Get.currentRoute == AppRoute.login) {
      return;
    }

    _isHandlingUnauthorized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await StorageService.logoutUser();
        if (Get.currentRoute != AppRoute.login) {
          Get.offAllNamed(AppRoute.login);
          Get.snackbar(
            'Session Expired',
            'Your session has expired. Please log in again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade600,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
          );
        }
      } catch (e) {
        debugPrint('Error handling unauthorized redirect: $e');
      } finally {
        Future.delayed(const Duration(seconds: 2), () {
          _isHandlingUnauthorized = false;
        });
      }
    });
  }

  // Public helper to trigger unauthorized/logout externally if needed
  static void handleUnauthorized({String? requestUrl}) {
    _handleUnauthorized(requestUrl: requestUrl);
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