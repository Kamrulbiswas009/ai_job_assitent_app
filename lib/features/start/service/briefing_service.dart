import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/logging/logger.dart';
import '../model/briefing_model.dart';

class BriefingService {
  final int timeoutDuration = 30;

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

  Future<PersonalBriefingModel?> getPersonalBriefing(
    PersonalBriefingRequest request,
  ) async {
    final String url = ApiConstants.personalBriefing;
    final String? effectiveToken = StorageService.token;

    final Map<String, String> fields = {
      'first_name': request.firstName,
      'scenario_id': request.scenarioId,
      'role': request.role,
      'goal': request.goal,
      'description': request.description,
    };

    AppLoggerHelper.info(
      '==================== [PERSONAL BRIEFING API REQUEST] ====================\n'
      'URL: $url\n'
      'Scenario: ${request.scenarioId}\n'
      'Fields: $fields\n'
      'Voice File: ${request.voiceFilePath ?? "None"}\n'
      'Token: ${effectiveToken != null ? "Present" : "None"}',
    );

    try {
      final multipartRequest = http.MultipartRequest('POST', Uri.parse(url));

      // Add Headers
      multipartRequest.headers.addAll({
        'accept': '*/*',
        if (effectiveToken != null && effectiveToken.isNotEmpty)
          'Authorization': effectiveToken.startsWith('Bearer ')
              ? effectiveToken
              : 'Bearer $effectiveToken',
      });

      // Add text form fields
      multipartRequest.fields.addAll(fields);

      // Add voice file if recorded and exists
      if (request.voiceFilePath != null && request.voiceFilePath!.isNotEmpty) {
        final file = File(request.voiceFilePath!);
        if (await file.exists()) {
          final mediaType = _getAudioMediaType(request.voiceFilePath!);
          multipartRequest.files.add(
            await http.MultipartFile.fromPath(
              'voice',
              request.voiceFilePath!,
              contentType: mediaType,
            ),
          );
          AppLoggerHelper.info(
            'Attached voice recording: ${request.voiceFilePath} (${mediaType.mimeType}, ${await file.length()} bytes)',
          );
        } else {
          AppLoggerHelper.warning('Voice recording file not found at: ${request.voiceFilePath}');
        }
      }

      final http.StreamedResponse streamedResponse =
          await multipartRequest.send().timeout(Duration(seconds: timeoutDuration));
      final http.Response response = await http.Response.fromStream(streamedResponse);

      AppLoggerHelper.info(
        '==================== [PERSONAL BRIEFING API RESPONSE] ====================\n'
        'Status Code: ${response.statusCode}\n'
        'Body: ${response.body}',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return PersonalBriefingModel.fromJson(decoded);
        } else if (decoded is Map) {
          return PersonalBriefingModel.fromJson(
            Map<String, dynamic>.from(decoded),
          );
        }
      } else {
        // Detailed error logging on console with AppLoggerHelper
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
          'Briefing API Error [${response.statusCode}]: $errorDetail\n'
          'Full Response: ${response.body}',
        );
      }

      return null;
    } catch (e) {
      AppLoggerHelper.error(
        'Exception while requesting Personal Briefing: $e',
        e,
      );
      return null;
    }
  }
}
