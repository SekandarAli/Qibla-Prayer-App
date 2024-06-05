import 'package:http/http.dart' as http;
import 'package:namaz_timing_app/mvvm/model/home_model.dart';

class HomeService{
  Future<HomeModel> getAllNamazData({required String date,required String lat,required String lng,}) async{
    var url = Uri.parse(
        "http://api.aladhan.com/v1/timings/$date?latitude=$lat&longitude=$lng&method=20"
    );

    var response = await http.get(url);

    if(response.statusCode == 200){
      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");
      final modelData = homeModelFromJson(response.body);
      return modelData;
    }
    else{
      throw Exception('Failed to load Data');
    }
  }
}