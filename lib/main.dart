import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:studioequip_mobile_app/app.dart';
import 'package:studioequip_mobile_app/core/services/storage_service.dart';
import 'package:studioequip_mobile_app/core/utils/constants/colors.dart';

import 'package:studioequip_mobile_app/core/services/stripe_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await StripeService.init();
  _configEasyLoading();
  runApp(const Studioequip());
}

void _configEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1800)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.light
    ..toastPosition = EasyLoadingToastPosition.bottom
    ..indicatorSize = 28
    ..radius = 12
    ..progressColor = AppColors.primary
    ..backgroundColor = const Color(0xFF1C1C1E)
    ..indicatorColor = AppColors.white
    ..textColor = AppColors.white
    ..maskType = EasyLoadingMaskType.none
    ..userInteractions = true
    ..dismissOnTap = true;
}
