import 'package:get/get.dart';
import 'arabic.dart';
import 'english.dart';

class LocalizationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {

    /// ENGLISH
    'en_US': EnglishLanguage().english['en_US']!,


    /// ARABIC
    'ar_AR': ArabicLanguage().arabic['ar_AR']!,
  };
}
