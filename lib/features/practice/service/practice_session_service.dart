import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../core/models/response_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/logging/logger.dart';
import '../model/practice_coaching_brief_model.dart';
import '../model/practice_evaluate_answer_model.dart';
import '../model/practice_question_model.dart';
import '../model/practice_session_ready_model.dart';

class PracticeSessionService {
  final NetworkCaller _networkCaller;

  PracticeSessionService({NetworkCaller? networkCaller})
      : _networkCaller = networkCaller ?? NetworkCaller();

  /// Backend slugs use kebab-case (e.g. `job-interview`); onboarding uses snake_case.
  static String toApiScenarioSlug(String slug) =>
      slug.trim().replaceAll('_', '-');

  /// AI session-brief uses snake_case scenario ids (e.g. `job_interview`).
  static String toAiScenarioId(String slug) =>
      slug.trim().replaceAll('-', '_');

  static String toApiMode(String modeId) => modeId.trim().toUpperCase();

  Future<PracticeSessionReadyModel?> fetchSessionPrepare(
    String scenarioSlug,
  ) async {
    final apiSlug = toApiScenarioSlug(scenarioSlug);
    final url = ApiConstants.sessionPrepare(apiSlug);

    AppLoggerHelper.info(
      '==================== [SESSION PREPARE API REQUEST] ====================\n'
      'URL: $url\n'
      'Token: ${StorageService.hasToken() ? "Present" : "None"}',
    );

    final ResponseData response = await _networkCaller.getRequest(url);

    if (!response.isSuccess) {
      AppLoggerHelper.error(
        'Session prepare failed [${response.statusCode}]: ${response.errorMessage}',
      );
      return null;
    }

    final dynamic payload = response.responseData;
    if (payload is! Map) {
      AppLoggerHelper.error('Session prepare response is not a JSON object.');
      return null;
    }

    final dynamic data = payload['data'];
    if (data is! Map) {
      AppLoggerHelper.error('Session prepare response missing `data` object.');
      return null;
    }

    return PracticeSessionReadyModel.fromPrepareApi(
      Map<String, dynamic>.from(data),
      userName: _displayFirstName(StorageService.fullName),
    );
  }

  /// Starts a backend practice session. The payload is not shown in the UI.
  Future<String?> startSession({
    required String scenarioId,
    required String panelId,
    required String mode,
    required String missionId,
  }) async {
    const url = ApiConstants.sessionStart;
    final body = {
      'scenarioId': scenarioId,
      'panelId': panelId,
      'mode': mode,
      'missionId': missionId,
    };

    AppLoggerHelper.info(
      '==================== [SESSION START API REQUEST] ====================\n'
      'URL: $url\n'
      'Body: $body',
    );

    try {
      final ResponseData response = await _networkCaller.postRequest(
        url,
        body: body,
      );

      if (!response.isSuccess) {
        AppLoggerHelper.error(
          'Session start failed [${response.statusCode}]: ${response.errorMessage}',
        );
        return null;
      }

      final dynamic payload = response.responseData;
      if (payload is Map) {
        final dynamic data = payload['data'];
        if (data is Map && data['sessionId'] != null) {
          return data['sessionId'].toString();
        }
      }
      return null;
    } catch (e) {
      AppLoggerHelper.error('Session start exception: $e', e);
      return null;
    }
  }

  Future<PracticeCoachingBriefModel?> fetchAiSessionBrief({
    required String scenarioId,
    required String characterId,
    required String description,
    required String challengeMode,
  }) async {
    const url = ApiConstants.aiSessionBrief;
    final body = {
      'scenarioId': scenarioId,
      'characterId': characterId,
      'description': description,
      'challengeMode': challengeMode,
    };

    debugPrint(
      '==================== [AI SESSION BRIEF API REQUEST] ====================\n'
      'URL: $url\n'
      'Body: $body\n'
      'Authorization: omitted',
    );

    AppLoggerHelper.info(
      '==================== [AI SESSION BRIEF API REQUEST] ====================\n'
      'URL: $url\n'
      'Body: $body\n'
      'Authorization: omitted',
    );

    try {
      final ResponseData response = await _networkCaller.postRequest(
        url,
        body: body,
        timeoutSeconds: 60,
        includeAuth: false,
      );

      if (!response.isSuccess) {
        AppLoggerHelper.error(
          'AI session brief failed [${response.statusCode}]: ${response.errorMessage}',
        );
        return null;
      }

      final dynamic payload = response.responseData;
      if (payload is! Map) {
        AppLoggerHelper.error('AI session brief response is not a JSON object.');
        return null;
      }

      return PracticeCoachingBriefModel.fromAiApi(
        Map<String, dynamic>.from(payload),
      );
    } catch (e) {
      AppLoggerHelper.error('AI session brief exception: $e', e);
      return null;
    }
  }

  Future<PracticeSessionQuestionsResult?> fetchSessionQuestions(
    String sessionId,
  ) async {
    final url = ApiConstants.sessionQuestions(sessionId);

    AppLoggerHelper.info(
      '==================== [SESSION QUESTIONS API REQUEST] ====================\n'
      'URL: $url\n'
      'Session ID: $sessionId\n'
      'Token: ${StorageService.hasToken() ? "Present" : "None"}',
    );

    try {
      final ResponseData response = await _networkCaller.getRequest(url);

      if (!response.isSuccess) {
        AppLoggerHelper.error(
          'Session questions failed [${response.statusCode}]: ${response.errorMessage}',
        );
        return null;
      }

      final dynamic payload = response.responseData;
      if (payload is! Map) {
        AppLoggerHelper.error(
          'Session questions response is not a JSON object.',
        );
        return null;
      }

      final dynamic data = payload['data'];
      if (data is! Map) {
        AppLoggerHelper.error(
          'Session questions response missing `data` object.',
        );
        return null;
      }

      return PracticeSessionQuestionsResult.fromApi(
        Map<String, dynamic>.from(data),
      );
    } catch (e) {
      AppLoggerHelper.error('Session questions exception: $e', e);
      return null;
    }
  }

  Future<PracticeEvaluateAnswerResult?> evaluateAnswer(
    PracticeEvaluateAnswerRequest request, {
    bool includeAuth = false,
  }) async {
    const url = ApiConstants.evaluateAnswer;
    final file = File(request.audioPath);
    if (!await file.exists()) {
      AppLoggerHelper.error('Evaluate answer audio missing: ${request.audioPath}');
      return null;
    }

    final fields = request.toFields();
    final token = includeAuth ? StorageService.token : null;
    AppLoggerHelper.info(
      '==================== [EVALUATE ANSWER API REQUEST] ====================\n'
      'URL: $url\n'
      'File: ${request.audioPath} (${await file.length()} bytes)\n'
      'Fields: $fields\n'
      'Authorization: ${includeAuth ? (token == null || token.isEmpty ? "None" : "Present") : "Omitted"}',
    );

    try {
      Future<http.Response> send({required bool withAuth}) async {
        final multipart = http.MultipartRequest('POST', Uri.parse(url));
        multipart.headers['accept'] = '*/*';
        final authToken = withAuth ? StorageService.token : null;
        if (authToken != null && authToken.isNotEmpty) {
          multipart.headers['Authorization'] = authToken.startsWith('Bearer ')
              ? authToken
              : 'Bearer $authToken';
        }
        multipart.fields.addAll(fields);
        multipart.files.add(
          await http.MultipartFile.fromPath(
            'audio_file',
            request.audioPath,
            contentType: _audioMediaType(request.audioPath),
          ),
        );
        final streamed = await multipart.send().timeout(
          const Duration(seconds: 90),
        );
        return http.Response.fromStream(streamed);
      }

      var response = await send(withAuth: includeAuth);
      if (response.statusCode == 401 && includeAuth) {
        AppLoggerHelper.info(
          'Evaluate answer 401 with token — retrying without Authorization.',
        );
        response = await send(withAuth: false);
      }

      AppLoggerHelper.info(
        '==================== [EVALUATE ANSWER API RESPONSE] ====================\n'
        'Status Code: ${response.statusCode}\n'
        'Body: ${response.body}',
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        AppLoggerHelper.error(
          'Evaluate answer failed [${response.statusCode}]: ${response.body}',
        );
        return null;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map) {
        AppLoggerHelper.error('Evaluate answer response is not a JSON object.');
        return null;
      }
      return PracticeEvaluateAnswerResult.fromApi(
        Map<String, dynamic>.from(decoded),
      );
    } catch (e) {
      AppLoggerHelper.error('Evaluate answer exception: $e', e);
      return null;
    }
  }

  static MediaType _audioMediaType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.m4a')) return MediaType('audio', 'm4a');
    if (lower.endsWith('.mp3')) return MediaType('audio', 'mpeg');
    if (lower.endsWith('.mp4')) return MediaType('audio', 'mp4');
    if (lower.endsWith('.wav')) return MediaType('audio', 'wav');
    if (lower.endsWith('.webm')) return MediaType('audio', 'webm');
    if (lower.endsWith('.ogg')) return MediaType('audio', 'ogg');
    return MediaType('audio', 'mp4');
  }

  static String _displayFirstName(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) {
      return 'USER';
    }
    return fullName.trim().split(RegExp(r'\s+')).first.toUpperCase();
  }
}
