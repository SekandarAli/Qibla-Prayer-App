import 'package:flutter/animation.dart';
import 'package:get/get.dart';

// class NavigationTransition {
//   static void navigate(Widget Function() pageBuilder) {
//     Get.to(()=>
//       pageBuilder(),
//       transition: Transition.fadeIn,
//       duration: const Duration(milliseconds: 300),
//       // curve: Curves.linearToEaseOut,
//     );
//   }
// }

extension NavigateTransition on GetInterface {
  navigate<T>(T page) async{
    Get.to<T>(
      page,
      transition: Transition.fadeIn,
      // duration: const Duration(milliseconds: 400),
      curve: Curves.linear,
    );
  }
}
