import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  final LanguageService _languageService = LanguageService();
  RxString selectedLocale = 'en_US'.obs;

  @override
  void onInit() {
    super.onInit();
    initializeLocale();
  }

  void initializeLocale() async {
    final String? savedLocale = await _languageService.getSelectedLanguage();
    selectedLocale.value = savedLocale ?? Get.deviceLocale?.toString() ?? 'en_US';
  }

  void changeLocale(String locale) async {
    selectedLocale.value = locale;
    await _languageService.setSelectedLanguage(locale);
  }
}

class LanguageService {
  static const String _kLanguageKey = 'en_US';

  Future<String?> getSelectedLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kLanguageKey);
  }

  Future<void> setSelectedLanguage(String languageCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLanguageKey, languageCode);
  }
}
