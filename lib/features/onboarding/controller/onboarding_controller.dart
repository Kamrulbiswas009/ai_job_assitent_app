import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/network_caller.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../../start/controller/start_membership_controller.dart';
import '../model/membership_plan_model.dart';

class OnboardingController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  // User auth & subscription state
  final RxBool isUserSubscribed = false.obs;
  final RxString userFullName = ''.obs;

  // Loading states
  final RxBool isRegisterLoading = false.obs;
  final RxBool isVerifyLoading = false.obs;
  final RxBool isLoginLoading = false.obs;
  final RxBool isRefreshTokenLoading = false.obs;
  final RxBool isForgotPasswordLoading = false.obs;
  final RxBool isResetPasswordLoading = false.obs;
  final RxBool isCheckoutLoading = false.obs;
  final RxBool isPaymentLaunched = false.obs;
  final RxString checkoutUrl = ''.obs;

  // Registered email holder for verification flow
  final RxString registeredEmail = ''.obs;
  // Forgot password email & OTP holder
  final RxString resetPasswordEmail = ''.obs;
  final RxString resetPasswordOtp = ''.obs;
  final RxString lastSessionId = ''.obs;

  final RxInt selectedPlanIndex = 0.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxInt resendCountdown = 30.obs;
  Timer? _timer;

  final RxList<MembershipPlanModel> plans = <MembershipPlanModel>[
    MembershipPlanModel.monthly,
    MembershipPlanModel.threeMonths,
  ].obs;

  @override
  void onInit() {
    super.onInit();
    startResendTimer();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.toggle();
  }

  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }

  void startResendTimer() {
    _timer?.cancel();
    resendCountdown.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  // ==================== 1. Register API ====================
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    isRegisterLoading.value = true;
    try {
      final body = {
        'fullName': fullName.trim(),
        'email': email.trim(),
        'password': password.trim(),
      };

      debugPrint('Calling Register API...');
      final response = await _networkCaller.postRequest(
        ApiConstants.register,
        body: body,
      );

      if (response.isSuccess) {
        registeredEmail.value = email.trim();
        userFullName.value = fullName.trim();
        await StorageService.saveEmail(email.trim());
        await StorageService.saveAuthData(
          accessToken: StorageService.accessToken ?? '',
          refreshToken: StorageService.refreshToken ?? '',
          email: email.trim(),
          fullName: fullName.trim(),
        );

        final message = (response.responseData is Map &&
                response.responseData['message'] != null)
            ? response.responseData['message']
            : 'Registration successful. Please verify your email';

        EasyLoading.showSuccess(message);
        return true;
      } else {
        EasyLoading.showError(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Something went wrong',
        );
        return false;
      }
    } catch (e) {
      debugPrint('Registration Exception: $e');
      EasyLoading.showError('An error occurred: $e');
      return false;
    } finally {
      isRegisterLoading.value = false;
    }
  }

  // ==================== 2. Verify Email API ====================
  Future<bool> verifyEmail({
    required String email,
    required String otp,
  }) async {
    isVerifyLoading.value = true;
    try {
      final body = {
        'email': email.trim(),
        'otp': otp.trim(),
      };

      debugPrint('Calling Verify Email API...');
      final response = await _networkCaller.postRequest(
        ApiConstants.verifyEmail,
        body: body,
      );

      if (response.isSuccess) {
        final message = (response.responseData is Map &&
                response.responseData['message'] != null)
            ? response.responseData['message']
            : 'Email verified successfully';

        EasyLoading.showSuccess(message);
        return true;
      } else {
        EasyLoading.showError(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Invalid verification code',
        );
        return false;
      }
    } catch (e) {
      debugPrint('Verify Email Exception: $e');
      EasyLoading.showError('An error occurred: $e');
      return false;
    } finally {
      isVerifyLoading.value = false;
    }
  }

  // ==================== 3. Login API ====================
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoginLoading.value = true;
    try {
      final body = {
        'email': email.trim(),
        'password': password.trim(),
      };

      debugPrint('Calling Login API...');
      final response = await _networkCaller.postRequest(
        ApiConstants.login,
        body: body,
      );

      if (response.isSuccess) {
        final data = response.responseData is Map
            ? response.responseData['data']
            : null;

        if (data != null && data is Map) {
          final accessToken = data['accessToken']?.toString() ?? '';
          final refreshToken = data['refreshToken']?.toString() ?? '';
          final user = data['user'] is Map ? data['user'] as Map : null;
          final userId = user?['userId']?.toString() ??
              user?['id']?.toString() ??
              data['userId']?.toString() ??
              data['id']?.toString();
          final userEmail = user?['email']?.toString() ??
              data['email']?.toString() ??
              email.trim();
          String fullName = user?['fullName']?.toString() ??
              user?['name']?.toString() ??
              user?['userName']?.toString() ??
              user?['firstName']?.toString() ??
              data['fullName']?.toString() ??
              data['name']?.toString() ??
              data['userName']?.toString() ??
              data['firstName']?.toString() ??
              '';

          // Fallback: If backend returned no name, generate readable name from email
          if (fullName.trim().isEmpty && userEmail.isNotEmpty) {
            final emailPrefix = userEmail.split('@').first;
            final clean = emailPrefix.split(RegExp(r'[._0-9-]')).first;
            if (clean.isNotEmpty) {
              fullName = '${clean[0].toUpperCase()}${clean.substring(1)}';
            }
          }

          final rawIsSubscribed =
              user?['isSubscribed'] ?? data['isSubscribed'];
          final bool isSubscribed = rawIsSubscribed == true ||
              rawIsSubscribed == 'true' ||
              rawIsSubscribed == 1;

          isUserSubscribed.value = isSubscribed;
          if (fullName.isNotEmpty) {
            userFullName.value = fullName;
          }

          await StorageService.saveAuthData(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userId: userId,
            email: userEmail,
            fullName: fullName,
            isSubscribed: isSubscribed,
          );

          if (Get.isRegistered<StartMembershipController>()) {
            if (fullName.isNotEmpty) {
              Get.find<StartMembershipController>().setUserName(fullName);
            }
          }
        }

        final message = (response.responseData is Map &&
                response.responseData['message'] != null)
            ? response.responseData['message']
            : 'Login successful';

        EasyLoading.showSuccess(message);
        return true;
      } else {
        EasyLoading.showError(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Invalid email or password',
        );
        return false;
      }
    } catch (e) {
      debugPrint('Login Exception: $e');
      EasyLoading.showError('An error occurred: $e');
      return false;
    } finally {
      isLoginLoading.value = false;
    }
  }

  // ==================== 4. Refresh Token API ====================
  Future<bool> refreshAccessToken({String? token}) async {
    isRefreshTokenLoading.value = true;
    try {
      final tokenToUse = token ?? StorageService.refreshToken ?? '';
      if (tokenToUse.isEmpty) {
        debugPrint('Refresh Token Error: No refresh token available');
        return false;
      }

      final body = {
        'refreshToken': tokenToUse.trim(),
      };

      debugPrint('Calling Refresh Token API...');
      final response = await _networkCaller.postRequest(
        ApiConstants.refreshToken,
        body: body,
      );

      if (response.isSuccess) {
        final data = response.responseData is Map
            ? response.responseData['data']
            : null;

        if (data != null && data is Map) {
          final newAccessToken = data['accessToken']?.toString() ?? '';
          final newRefreshToken = data['refreshToken']?.toString() ?? '';

          await StorageService.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );
        }
        debugPrint('Token refreshed successfully!');
        return true;
      } else {
        debugPrint('Refresh Token Failed: ${response.errorMessage}');
        return false;
      }
    } catch (e) {
      debugPrint('Refresh Token Exception: $e');
      return false;
    } finally {
      isRefreshTokenLoading.value = false;
    }
  }

  // ==================== 5. Forgot Password API ====================
  Future<bool> forgotPassword({required String email}) async {
    isForgotPasswordLoading.value = true;
    try {
      final body = {
        'email': email.trim(),
      };

      debugPrint('Calling Forgot Password API...');
      final response = await _networkCaller.postRequest(
        ApiConstants.forgotPassword,
        body: body,
      );

      if (response.isSuccess) {
        resetPasswordEmail.value = email.trim();
        startResendTimer();

        final message = (response.responseData is Map &&
                response.responseData['message'] != null)
            ? response.responseData['message']
            : 'If the email exists, a password reset OTP has been sent.';

        EasyLoading.showSuccess(message);
        return true;
      } else {
        EasyLoading.showError(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to send password reset OTP',
        );
        return false;
      }
    } catch (e) {
      debugPrint('Forgot Password Exception: $e');
      EasyLoading.showError('An error occurred: $e');
      return false;
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }

  // ==================== 6. Reset Password API ====================
  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    isResetPasswordLoading.value = true;
    try {
      final body = {
        'email': email.trim(),
        'otp': otp.trim(),
        'newPassword': newPassword.trim(),
      };

      debugPrint('Calling Reset Password API...');
      final response = await _networkCaller.postRequest(
        ApiConstants.resetPassword,
        body: body,
      );

      if (response.isSuccess) {
        final message = (response.responseData is Map &&
                response.responseData['message'] != null)
            ? response.responseData['message']
            : 'Password reset successfully';

        EasyLoading.showSuccess(message);
        return true;
      } else {
        EasyLoading.showError(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to reset password',
        );
        return false;
      }
    } catch (e) {
      debugPrint('Reset Password Exception: $e');
      EasyLoading.showError('An error occurred: $e');
      return false;
    } finally {
      isResetPasswordLoading.value = false;
    }
  }

  // ==================== 7. Create Checkout Session API ====================
  Future<String?> createCheckoutSession({required String planId}) async {
    if (isCheckoutLoading.value) return null;
    isCheckoutLoading.value = true;
    try {
      final body = {
        'planId': planId.trim(),
        'successUrl':
            'http://localhost:3000/subscription/success?session_id={CHECKOUT_SESSION_ID}',
        'cancelUrl': 'http://localhost:3000/subscription/cancelled',
      };

      debugPrint('Calling Create Checkout Session API with planId: $planId');
      final token = StorageService.token ?? '';
      final response = await _networkCaller.postRequest(
        ApiConstants.createCheckoutSession,
        body: body,
        token: token,
      );

      if (response.isSuccess) {
        final data = response.responseData is Map
            ? response.responseData['data']
            : null;
        final checkoutUrl = (data != null && data is Map)
            ? data['checkoutUrl']?.toString()
            : null;
        final sessionId = (data != null && data is Map)
            ? data['sessionId']?.toString()
            : null;
        if (sessionId != null && sessionId.isNotEmpty) {
          lastSessionId.value = sessionId;
        }

        if (checkoutUrl == null || checkoutUrl.isEmpty) {
          EasyLoading.showError('No checkout URL returned by server.');
          return null;
        }

        return checkoutUrl;
      } else {
        EasyLoading.showError(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to create checkout session',
        );
        return null;
      }
    } catch (e) {
      debugPrint('Checkout Session Exception: $e');
      EasyLoading.showError('An error occurred: $e');
      return null;
    } finally {
      isCheckoutLoading.value = false;
    }
  }

  Future<bool> launchCheckoutUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        return await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Launch URL Exception: $e');
      EasyLoading.showError('Could not open checkout page: $e');
      return false;
    }
  }

  void resetCheckoutState() {
    isPaymentLaunched.value = false;
    checkoutUrl.value = '';
  }

  Future<void> handleProceedToPayment(String planId) async {
    final url = await createCheckoutSession(planId: planId);
    if (url != null && url.isNotEmpty) {
      checkoutUrl.value = url;
      final launched = await launchCheckoutUrl(url);
      if (launched) {
        isPaymentLaunched.value = true;
      }
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
