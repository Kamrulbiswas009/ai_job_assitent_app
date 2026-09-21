import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_routes.dart';

class StartMembershipController extends GetxController {
  final RxString userName = (StorageService.fullName?.trim().isNotEmpty == true
          ? StorageService.fullName!.trim()
          : 'Aycan Doganlar')
      .obs;
  late final RxString userFirstName = _extractFirstName(userName.value).obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onReady() {
    super.onReady();
    loadUserData();
  }

  void loadUserData() {
    final args = Get.arguments;
    String? name;
    if (args is Map &&
        args['fullName'] != null &&
        args['fullName'].toString().trim().isNotEmpty) {
      name = args['fullName'].toString().trim();
    } else if (args is String && args.trim().isNotEmpty) {
      name = args.trim();
    } else if (StorageService.fullName != null &&
        StorageService.fullName!.trim().isNotEmpty) {
      name = StorageService.fullName!.trim();
    }

    if (name != null && name.isNotEmpty) {
      setUserName(name);
    }
  }

  void setUserName(String name) {
    final trimmed = name.trim();
    if (trimmed.isNotEmpty) {
      userName.value = trimmed;
      userFirstName.value = _extractFirstName(trimmed);
    }
  }

  String _extractFirstName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '';
    final parts = trimmed.split(RegExp(r'\s+'));
    final first = parts.isNotEmpty ? parts.first : trimmed;
    if (first.isEmpty) return '';
    return '${first[0].toUpperCase()}${first.substring(1)}';
  }

  void goToStep1() {
    Get.toNamed(AppRoute.startStep1Goals);
  }
}
