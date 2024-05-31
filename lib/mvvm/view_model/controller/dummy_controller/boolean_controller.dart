import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BooleanController extends GetxController {
  RxBool boolean = true.obs;

  Future<void> changeTipPagesController(bool newBoolean) async {
    boolean.value = newBoolean;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setBool("boolean", newBoolean);
    } catch (e) {
      print("Error saving data to shared preferences: $e");
    }
  }

  Future<void> retrieveTipPageStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? retrievedValue = prefs.getBool("boolean");
    if (retrievedValue != null) {
      boolean.value = retrievedValue;
    }
  }
}
