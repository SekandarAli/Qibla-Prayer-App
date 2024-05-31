import 'package:get/get.dart';

class BottomBarController extends GetxController {
  final selectedIndex = 0.obs;

  void changeBottomBarController(int index) {
    selectedIndex.value = index;
  }
}
