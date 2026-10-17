import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../models/saved_session_model.dart';
import '../utils/constants/api_constants.dart';
import '../utils/logging/logger.dart';
import 'network_caller.dart';
import 'storage_service.dart';

class LogoutResult {
  final bool localSessionCleared;
  final bool remoteLogoutSucceeded;
  final bool remoteLogoutAttempted;
  final String? message;

  const LogoutResult({
    required this.localSessionCleared,
    required this.remoteLogoutSucceeded,
    required this.remoteLogoutAttempted,
    this.message,
  });
}

/// Central auth/session actions (logout, future: session refresh helpers).
class AuthService {
  AuthService({NetworkCaller? networkCaller})
      : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;
  static bool _logoutInProgress = false;

  /// Signs the user out: invalidates refresh token on server when possible,
  /// then always clears local credentials and navigates to login.
  Future<LogoutResult> signOut({bool navigateToLogin = true}) async {
    if (_logoutInProgress) {
      return const LogoutResult(
        localSessionCleared: false,
        remoteLogoutSucceeded: false,
        remoteLogoutAttempted: false,
        message: 'Logout already in progress',
      );
    }

    _logoutInProgress = true;
    var remoteAttempted = false;
    var remoteSucceeded = false;
    String? remoteMessage;

    try {
      // 1. Snapshot active session state before clearing credentials
      final currentRoute = Get.currentRoute;
      if (SavedSessionModel.isResumableRoute(currentRoute)) {
        Map<String, dynamic>? args;
        if (Get.arguments is Map<String, dynamic>) {
          args = Get.arguments as Map<String, dynamic>;
        } else if (Get.arguments is Map) {
          args = Map<String, dynamic>.from(Get.arguments as Map);
        }

        await StorageService.saveCurrentSession(
          route: currentRoute,
          title: SavedSessionModel.resolveRouteTitle(currentRoute),
          assessmentId: StorageService.assessmentId,
          arguments: args,
        );
        AppLoggerHelper.info(
          'Cached previous session before logout: $currentRoute',
        );
      }

      final refreshToken = StorageService.refreshToken?.trim() ?? '';
      if (refreshToken.isNotEmpty) {
        remoteAttempted = true;
        AppLoggerHelper.info(
          '==================== [AUTH LOGOUT API REQUEST] ====================\n'
          'URL: ${ApiConstants.logout}',
        );

        final response = await _networkCaller.postRequest(
          ApiConstants.logout,
          body: {'refreshToken': refreshToken},
        );

        remoteSucceeded = response.isSuccess;
        if (response.responseData is Map &&
            response.responseData['message'] != null) {
          remoteMessage = response.responseData['message'].toString();
        } else if (response.errorMessage.isNotEmpty) {
          remoteMessage = response.errorMessage;
        }

        if (remoteSucceeded) {
          AppLoggerHelper.info('Remote logout succeeded.');
        } else {
          AppLoggerHelper.warning(
            'Remote logout failed [${response.statusCode}]: '
            '${remoteMessage ?? "Unknown error"}. Clearing local session anyway.',
          );
        }
      } else {
        AppLoggerHelper.warning(
          'No refresh token in storage; skipping remote logout API.',
        );
      }
    } catch (e) {
      AppLoggerHelper.error(
        'Exception during remote logout. Clearing local session anyway.',
        e,
      );
    } finally {
      await StorageService.logoutUser();

      if (navigateToLogin && Get.currentRoute != AppRoute.login) {
        Get.offAllNamed(AppRoute.login);
      }

      _logoutInProgress = false;
    }

    return LogoutResult(
      localSessionCleared: true,
      remoteLogoutSucceeded: remoteSucceeded,
      remoteLogoutAttempted: remoteAttempted,
      message: remoteMessage,
    );
  }
}
