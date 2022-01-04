import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrtappv2/Auth/sys/auth.dart';
import 'package:wrtappv2/ErrorPage/closeapp.dart';
import 'package:wrtappv2/ErrorPage/iderror.dart';
import 'package:wrtappv2/ErrorPage/update.dart';
import 'package:wrtappv2/Screen/detailpage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class Konst {
  Rx readQuality = "100".obs;
  RxBool isLoadingHome = false.obs;
  Rx isLoading = false.obs;
  RxBool notifStatus = false.obs;
  Rx identifier = "".obs;
  RxBool statusID = true.obs;
  var user = Auth();
  Rx versi = "".obs;

  Konst() {
    DefaultCacheManager().emptyCache();
    initUniqueIdentifierState();
    getQualityRead();
  }

  Future<String?> getUserEmail() {
    return user.getEmail();
  }

  changeStatusNotif() async {
    var prefs = await SharedPreferences.getInstance();
    OneSignal.shared.disablePush(notifStatus.value).then((value) {
      prefs.setBool("notifStatus", notifStatus.value);
    });
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId("be7dac02-14fd-470f-bf7d-5ba24e08bdd2");
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      if (result.notification.launchUrl!.contains('komik')) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          Get.to(DetailPage(url: result.notification.launchUrl.toString()));
        });
      } else {
        var url = result.notification.launchUrl.toString();
        url = url.substring(url.indexOf(".id/") + 4);
        url = "https://wrt.my.id/komik/$url";
        // get before -chapter-
        url = url.substring(0, url.indexOf("-chapter-"));
        Get.to(DetailPage(url: url));
      }
    });
  }

  Future<void> initUniqueIdentifierState() async {
    try {
      identifier.value = (await UniqueIdentifier.serial)!;
    } on PlatformException {
      identifier.value = 'Failed to get Unique Identifier';
    }
  }

  void blockOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future validationDeviceID() async {
    FirebaseFirestore server = FirebaseFirestore.instance;
    var email = await getUserEmail();
    if (await server
        .collection(email!)
        .doc('device')
        .get()
        .then((value) => value.exists)) {
      var _idAtServer = await server.collection(email).doc("device").get();
      await initUniqueIdentifierState().then((_) {
        if (_idAtServer.data()!['deviceID'] == identifier.value) {
          statusID.value = false;
        } else {
          statusID.value = true;
        }
      });
      if (statusID.value) {
        Get.off(const IdError());
      }
    } else {
      var _idAtServerSet = server.collection(email).doc("device");
      await initUniqueIdentifierState().then((_) {
        _idAtServerSet.set({
          'deviceID': identifier.value,
        });
      });
    }
  }

  Future cekUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionold = packageInfo.version;
    var url = "https://data.wrt.my.id/version.json";
    var response = await http.get(Uri.parse(url));
    var data = await json.decode(response.body);
    var version = await data['version'];
    versi.value = version;
    var message = await data['message'];
    var urlUpdate = await data['url'];
    if (version != versionold) {
      Get.off(UpdatePage(
        url: urlUpdate,
        version: version,
        message: message,
      ));
    }
  }

  Future setReadQuality(String quality) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("readQuality", quality);
    readQuality.value = quality;
  }

  Future getQualityRead() async {
    var prefs = await SharedPreferences.getInstance();
    readQuality.value = prefs.getString("readQuality") ?? "100";
  }

  Future<void> getStatusServer() async {
    var url = "https://data.wrt.my.id/status.json";
    var response = await http.get(Uri.parse(url));
    var data = await json.decode(response.body);
    var status = await data['status'];
    var message = await data['message'];
    if (status == "off") {
      Get.offAll(CloseApp(message: message));
    }
  }
}
