import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController{

  RxDouble selectedLatitude = 30.3753.obs;
  RxDouble selectedLongitude = 69.3451.obs;
  RxString selectedAddress = ''.obs;

  changeHomeController(double newSelectedLatitude, double newSelectedLongitude, String newSelectedAddress) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    selectedLatitude.value = newSelectedLatitude;
    selectedLongitude.value = newSelectedLongitude;
    selectedAddress.value = newSelectedAddress;

    await sharedPreferences.setDouble("selectedLatitude", newSelectedLatitude);
    await sharedPreferences.setDouble("selectedLongitude", newSelectedLongitude);
    await sharedPreferences.setString("selectedAddress", newSelectedAddress);
  }


  retrieveHomeController() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    double? retrieveSelectedLatitude = sharedPreferences.getDouble("selectedLatitude");
    double? retrieveSelectedLongitude = sharedPreferences.getDouble("selectedLongitude");
    String? retrieveSelectedAddress = sharedPreferences.getString("selectedAddress");

    if(retrieveSelectedLatitude != null){
      selectedLatitude.value = retrieveSelectedLatitude;
    }
    if(retrieveSelectedLongitude != null){
      selectedLongitude.value = retrieveSelectedLongitude;
    }
    if(retrieveSelectedAddress != null){
      selectedAddress.value = retrieveSelectedAddress;
    }
  }
}
