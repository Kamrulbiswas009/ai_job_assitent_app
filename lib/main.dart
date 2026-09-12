import 'package:flutter/material.dart';
import 'package:studioequip_mobile_app/app.dart';
import 'package:studioequip_mobile_app/core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const Studioequip());
}
