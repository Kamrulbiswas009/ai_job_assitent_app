import '../../../core/models/response_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/logging/logger.dart';
import '../model/practice_session_ready_model.dart';

class PracticeSessionService {
  final NetworkCaller _networkCaller;

  PracticeSessionService({NetworkCaller? networkCaller})
      : _networkCaller = networkCaller ?? NetworkCaller();

  /// Backend slugs use kebab-case (e.g. `job-interview`); onboarding uses snake_case.
  static String toApiScenarioSlug(String slug) =>
      slug.trim().replaceAll('_', '-');

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

  static String _displayFirstName(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) {
      return 'USER';
    }
    return fullName.trim().split(RegExp(r'\s+')).first.toUpperCase();
  }
}
