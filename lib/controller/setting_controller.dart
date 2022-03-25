import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingC extends GetxController {
  Rx readQuality = "100".obs;

  SettingC() {
    getQualityRead();
  }

  // Change read quality
  Future setReadQuality(String quality) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("readQuality", quality);
    readQuality.value = quality;
  }

  // Get current read quality
  Future getQualityRead() async {
    var prefs = await SharedPreferences.getInstance();
    readQuality.value = prefs.getString("readQuality") ?? "High";
  }
}
