import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/logging/logger.dart';
import '../model/benchmark_model.dart';
import '../model/calibration_model.dart';
import '../model/influence_score_model.dart';

class AssessmentService {
  final int timeoutDuration = 30;
  final http.Client _client;

  AssessmentService({http.Client? client}) : _client = client ?? http.Client();

  MediaType _getAudioMediaType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.mp3')) return MediaType('audio', 'mpeg');
    if (lower.endsWith('.mp4')) return MediaType('audio', 'mp4');
    if (lower.endsWith('.m4a')) return MediaType('audio', 'm4a');
    if (lower.endsWith('.wav')) return MediaType('audio', 'wav');
    if (lower.endsWith('.webm')) return MediaType('audio', 'webm');
    if (lower.endsWith('.ogg')) return MediaType('audio', 'ogg');
    return MediaType('audio', 'm4a');
  }

  /// Submits the 3 benchmark self-assessment answers to backend
  /// and returns the created assessment record with assessment_id.
  Future<SelfAssessmentResponse?> submitSelfAssessment(
    SelfAssessmentRequest request,
  ) async {
    final String url = ApiConstants.selfAssessment;
    final String? effectiveToken = StorageService.token;
    final String requestBody = jsonEncode(request.toJson());

    AppLoggerHelper.info(
      '==================== [SELF-ASSESSMENT API REQUEST] ====================\n'
      'URL: $url\n'
      'Body: $requestBody\n'
      'Token: ${effectiveToken != null && effectiveToken.isNotEmpty ? "Present" : "None"}',
    );

    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'accept': '*/*',
        if (effectiveToken != null && effectiveToken.isNotEmpty)
          'Authorization': effectiveToken.startsWith('Bearer ')
              ? effectiveToken
              : 'Bearer $effectiveToken',
      };

      final response = await _client
          .post(
            Uri.parse(url),
            headers: headers,
            body: requestBody,
          )
          .timeout(Duration(seconds: timeoutDuration));

      AppLoggerHelper.info(
        '==================== [SELF-ASSESSMENT API RESPONSE] ====================\n'
        'Status Code: ${response.statusCode}\n'
        'Body: ${response.body}',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return SelfAssessmentResponse.fromJson(decoded);
        } else if (decoded is Map) {
          return SelfAssessmentResponse.fromJson(
            Map<String, dynamic>.from(decoded),
          );
        }
      } else {
        String errorDetail = response.body;
        try {
          final decodedError = jsonDecode(response.body);
          if (decodedError is Map) {
            if (decodedError['message'] != null) {
              errorDetail = decodedError['message'].toString();
            } else if (decodedError['detail'] != null) {
              errorDetail = decodedError['detail'].toString();
            }
          }
        } catch (_) {}

        AppLoggerHelper.error(
          'Self-Assessment API Error [${response.statusCode}]: $errorDetail\n'
          'Full Response: ${response.body}',
        );
      }

      return null;
    } catch (e) {
      AppLoggerHelper.error(
        'Exception while submitting Self-Assessment: $e',
        e,
      );
      return null;
    }
  }

  /// Submits the calibration voice file to backend
  /// POST /api/v1/assessment/{assessment_id}/voice
  Future<CalibrationVoiceResponse?> submitVoiceFile({
    required String assessmentId,
    required String filePath,
  }) async {
    final String url = ApiConstants.assessmentVoice(assessmentId);
    final String? effectiveToken = StorageService.token;

    AppLoggerHelper.info(
      '==================== [CALIBRATION VOICE SUBMISSION REQUEST] ====================\n'
      'URL: $url\n'
      'Assessment ID: $assessmentId\n'
      'File: $filePath\n'
      'Token: ${effectiveToken != null && effectiveToken.isNotEmpty ? "Present" : "None"}',
    );

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        AppLoggerHelper.error('Audio file not found at: $filePath');
        return null;
      }

      final multipartRequest = http.MultipartRequest('POST', Uri.parse(url));

      // Add Headers
      multipartRequest.headers.addAll({
        'accept': '*/*',
        if (effectiveToken != null && effectiveToken.isNotEmpty)
          'Authorization': effectiveToken.startsWith('Bearer ')
              ? effectiveToken
              : 'Bearer $effectiveToken',
      });

      // Add voice file as multipart file with key 'voice_file'
      final mediaType = _getAudioMediaType(filePath);
      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          'voice_file',
          filePath,
          contentType: mediaType,
        ),
      );

      final http.StreamedResponse streamedResponse =
          await multipartRequest.send().timeout(Duration(seconds: timeoutDuration));
      final http.Response response =
          await http.Response.fromStream(streamedResponse);

      AppLoggerHelper.info(
        '==================== [CALIBRATION VOICE SUBMISSION RESPONSE] ====================\n'
        'Status Code: ${response.statusCode}\n'
        'Body: ${response.body}',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return CalibrationVoiceResponse.fromJson(decoded);
        } else if (decoded is Map) {
          return CalibrationVoiceResponse.fromJson(
            Map<String, dynamic>.from(decoded),
          );
        }
      } else {
        String errorDetail = response.body;
        try {
          final decodedError = jsonDecode(response.body);
          if (decodedError is Map) {
            if (decodedError['detail'] != null) {
              if (decodedError['detail'] is Map &&
                  decodedError['detail']['message'] != null) {
                errorDetail = decodedError['detail']['message'].toString();
              } else {
                errorDetail = decodedError['detail'].toString();
              }
            } else if (decodedError['message'] != null) {
              errorDetail = decodedError['message'].toString();
            }
          }
        } catch (_) {}

        AppLoggerHelper.error(
          'Calibration Voice API Error [${response.statusCode}]: $errorDetail\n'
          'Full Response: ${response.body}',
        );
      }

      return null;
    } catch (e) {
      AppLoggerHelper.error(
        'Exception while submitting calibration voice: $e',
        e,
      );
      return null;
    }
  }

  /// Fetches the completed Influence Score and result from backend
  /// GET /api/v1/assessment/{assessment_id}/result
  Future<AssessmentResultResponse?> fetchAssessmentResult(
    String assessmentId,
  ) async {
    final String url = ApiConstants.assessmentResult(assessmentId);
    final String? effectiveToken = StorageService.token;

    AppLoggerHelper.info(
      '==================== [FETCH ASSESSMENT RESULT REQUEST] ====================\n'
      'URL: $url\n'
      'Assessment ID: $assessmentId\n'
      'Token: ${effectiveToken != null && effectiveToken.isNotEmpty ? "Present" : "None"}',
    );

    try {
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          if (effectiveToken != null && effectiveToken.isNotEmpty)
            'Authorization': effectiveToken.startsWith('Bearer ')
                ? effectiveToken
                : 'Bearer $effectiveToken',
        },
      ).timeout(Duration(seconds: timeoutDuration));

      AppLoggerHelper.info(
        '==================== [FETCH ASSESSMENT RESULT RESPONSE] ====================\n'
        'Status Code: ${response.statusCode}\n'
        'Body: ${response.body}',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return AssessmentResultResponse.fromJson(decoded);
        } else if (decoded is Map) {
          return AssessmentResultResponse.fromJson(
            Map<String, dynamic>.from(decoded),
          );
        }
      } else {
        String errorDetail = response.body;
        try {
          final decodedError = jsonDecode(response.body);
          if (decodedError is Map && decodedError['detail'] != null) {
            errorDetail = decodedError['detail'].toString();
          }
        } catch (_) {}

        AppLoggerHelper.error(
          'Fetch Assessment Result API Error [${response.statusCode}]: $errorDetail\n'
          'Full Response: ${response.body}',
        );
      }
      return null;
    } catch (e) {
      AppLoggerHelper.error(
        'Exception while fetching assessment result: $e',
        e,
      );
      return null;
    }
  }
}
