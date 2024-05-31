import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class InternetController extends GetxController {
  RxBool internetValue = true.obs;
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    final ConnectivityResult result = await _connectivity.checkConnectivity();
    internetValue.value = result != ConnectivityResult.none;

    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      internetValue.value = result != ConnectivityResult.none;
    });
  }
}


                                ///Usage
// final InternetController internetController = Get.put(InternetController());
// if(internetController.internetValue.value){}
// else{}