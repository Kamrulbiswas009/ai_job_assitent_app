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
    ..displayDuration = const Duration(milliseconds: 2500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 44.0
    ..radius = 12.0
    ..progressColor = AppColors.primary
    ..backgroundColor = const Color(0xFF1E1E1E)
    ..indicatorColor = AppColors.primary
    ..textColor = Colors.white
    ..maskColor = Colors.black.withValues(alpha: 0.35)
    ..userInteractions = true
    ..dismissOnTap = true;
}
