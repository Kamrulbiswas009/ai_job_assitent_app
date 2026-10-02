import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppHelperFunctions {
  AppHelperFunctions._();

  static void showSnackBar(String message) {
    showToast(message);
  }

  static void showSuccess(String message) {
    try {
      EasyLoading.showSuccess(message).catchError((_) {});
    } catch (_) {}
  }

  static void showError(String message) {
    try {
      EasyLoading.showError(message).catchError((_) {});
    } catch (_) {}
  }

  static void showInfo(String message) {
    try {
      EasyLoading.showInfo(message).catchError((_) {});
    } catch (_) {}
  }

  static void showToast(String message) {
    try {
      EasyLoading.showToast(message).catchError((_) {});
    } catch (_) {}
  }

  static void showLoading([String? status]) {
    try {
      EasyLoading.show(status: status ?? 'Loading...').catchError((_) {});
    } catch (_) {}
  }

  static void hideLoading() {
    try {
      EasyLoading.dismiss().catchError((_) {});
    } catch (_) {}
  }

 static void showAlert(String title, String message) {
  showDialog(
   context: Get.context!,
   builder: (BuildContext context) {
    return AlertDialog(
     title: Text(title),
     content: Text(message),
     actions: [
      TextButton(
       onPressed: () => Navigator.of(context).pop(),
       child: const Text('OK'),
      ),
     ],
    );
   },
  );
 }

 static void navigateToScreen(BuildContext context, Widget screen) {
  Navigator.push(
   context,
   MaterialPageRoute(builder: (_) => screen),
  );
 }

 static String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
   return text;
  } else {
   return '${text.substring(0, maxLength)}...';
  }
 }

 static bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
 }
 static Size screenSize() {
  return MediaQuery.of(Get.context!).size;
 }

 static double screenHeight() {
  return MediaQuery.of(Get.context!).size.height;
 }
 static double screenWidth() {
  return MediaQuery.of(Get.context!).size.width;
 }

 static String getFormattedDate(DateTime date, {String format = 'dd MMM yyyy'}) {
  return DateFormat(format).format(date);
 }

 static List<T> removeDuplicates<T>(List<T> list) {
  return list.toSet().toList();
 }

 static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
  final wrappedList = <Widget>[];
  for (var i = 0; i < widgets.length; i += rowSize) {
   final rowChildren = widgets.sublist(
    i,
    i + rowSize > widgets.length ? widgets.length : i + rowSize,
   );
   wrappedList.add(Row(children: rowChildren));
  }
  return wrappedList;
 }

}