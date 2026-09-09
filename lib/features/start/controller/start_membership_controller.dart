import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class StartMembershipController extends GetxController {
  final RxString userName = 'Aycan Doganlar'.obs;
  final RxString userFirstName = 'Aycan'.obs;
  final RxBool isLoading = false.obs;

  void goToStep1() {
    Get.toNamed(AppRoute.startStep1Goals);
  }
}
