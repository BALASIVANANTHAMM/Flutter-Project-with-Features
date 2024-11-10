import 'package:flutter/material.dart';
import 'package:get/get.dart';
class LangController extends GetxController {
  ///
  changeLocale(String langCode, String countryCode) {
    var locale =Locale(langCode, countryCode);
    Get.updateLocale(locale);
  }
}