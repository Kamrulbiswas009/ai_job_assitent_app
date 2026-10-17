import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/sp_loading_overlay.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';

class PracticeMenuController extends GetxController {
  PracticeMenuController({AuthService? authService})
      : _authService = authService ?? AuthService();

  final AuthService _authService;

  final RxString fullName = 'SpeechPro Member'.obs;
  final RxString email = '—'.obs;
  final RxString userId = '—'.obs;
  final RxString bio = ''.obs;
  final RxBool isSubscribed = false.obs;
  final RxInt selectedTab = 0.obs;
  final RxBool isLoggingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshProfile();
  }

  void refreshProfile() {
    final name = StorageService.fullName?.trim();
    fullName.value =
        name != null && name.isNotEmpty ? name : 'SpeechPro Member';
    email.value = _valueOrDash(StorageService.userEmail);
    userId.value = _valueOrDash(StorageService.userId);
    isSubscribed.value = StorageService.isSubscribed;
    bio.value = _buildBio(fullName.value);
  }

  String get initials {
    final parts = fullName.value.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'SP';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }

  void selectTab(int index) {
    selectedTab.value = index;
  }

  Future<void> logout() async {
    if (isLoggingOut.value) return;

    isLoggingOut.value = true;
    SpLoadingOverlay.show(
      title: 'Signing you out',
      thoughts: const [
        'Saving your place…',
        'Clearing this session…',
      ],
    );

    late final LogoutResult result;
    try {
      result = await _authService.signOut();
    } finally {
      SpLoadingOverlay.hide();
      isLoggingOut.value = false;
    }

    if (result.remoteLogoutAttempted && !result.remoteLogoutSucceeded) {
      EasyLoading.showInfo(
        'Signed out on this device. Server logout could not be confirmed.',
      );
    }
  }

  String _valueOrDash(String? value) {
    if (value == null || value.trim().isEmpty) return '—';
    return value.trim();
  }

  String _buildBio(String name) {
    return '$name is building executive presence with SpeechPro — '
        'practising real scenarios, earning XP, and showing up with '
        'calm authority when it matters most.';
  }
}
