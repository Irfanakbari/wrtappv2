import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

class Konst {
  Rx readQuality = "100".obs;
  RxBool isLoadingHome = false.obs;
  Rx isLoading = false.obs;
  RxBool notifStatus = false.obs;
  Rx identifier = "".obs;
  Rx merk = "".obs;
  Rx model = "".obs;
  Rx hardware = "".obs;
  Rx osVersion = "".obs;
  Rx apiVersion = "".obs;
  RxBool statusID = true.obs;
  var user = Auth();
  Rx versi = "".obs;
  var topUpAmount = 0.obs;
  RxBool premiumStatus = false.obs;
  var expPremium = DateTime.now().obs;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  FirebaseFirestore server = FirebaseFirestore.instance;

  Konst() {
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
      if (result.notification.launchUrl!.contains('manga')) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          var slug = result.notification.launchUrl
              .toString()
              .split('https://wrt.my.id/manga/')[1]
              .split('/')[0];
          Get.to(DetailPage(
            url: result.notification.launchUrl.toString(),
            slug: slug,
          ));
        });
      } else {
        var url = result.notification.launchUrl.toString();
        url = url.substring(url.indexOf(".id/") + 4);
        url = "https://wrt.my.id/manga/$url";
        url = url.substring(0, url.indexOf("-chapter-"));
        var slug = url.split('https://wrt.my.id/manga/')[1].split('/')[0];
        Get.to(DetailPage(
          url: url,
          slug: slug,
        ));
      }
    });
  }

  Future<void> initUniqueIdentifierState() async {
    try {
      await deviceInfoPlugin.androidInfo.then((value) {
        identifier.value = value.androidId;
        merk.value = value.manufacturer;
        model.value = value.model;
        hardware.value = value.hardware;
        osVersion.value = value.version.release;
        apiVersion.value = value.version.sdkInt.toString();
      });
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
    var email = await getUserEmail();
    var _idAtServer = await server.collection(email!).doc("device").get();
    await server.collection(email).doc("type").set({
      "deviceType": "Android",
      "merk": merk.value,
      "model": model.value,
      "hardware": hardware.value,
      "osVersion": osVersion.value,
    });
    if (await server
        .collection(email)
        .doc('device')
        .get()
        .then((value) => value.exists)) {
      await initUniqueIdentifierState().then((_) {
        if (_idAtServer.data()!['deviceID'] == identifier.value) {
          statusID.value = false;
        } else {
          statusID.value = true;
          Get.off(const IdError());
        }
      });
    } else {
      var _idAtServerSet = server.collection(email).doc("device");
      await initUniqueIdentifierState().then((_) {
        _idAtServerSet.set({
          'deviceID': identifier.value,
        }).then((value) {
          if (_idAtServer.data()!['deviceID'] == identifier.value) {
            statusID.value = false;
          } else {
            statusID.value = true;
            Get.off(const IdError());
          }
        });
      });
    }
  }

  Future cekUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionold = packageInfo.version;
    versi.value = versionold;
  }

  Future setReadQuality(String quality) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("readQuality", quality);
    readQuality.value = quality;
  }

  Future getQualityRead() async {
    var prefs = await SharedPreferences.getInstance();
    readQuality.value = prefs.getString("readQuality") ?? "High";
  }

  Future<void> getStatusServer() async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    var status = remoteConfig.getBool('status');

    if (!status) {
      Get.offAll(const CloseApp(
          message:
              "Aplikasi Ditutup Sementara, sedang ada perbaikan di sisi server"));
    }
  }

  Future<void> sendReport(String message) async {
    var url = dotenv.env['WEBHOOK_REPORT'];
    var response = await http.post(Uri.parse(url!),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "username": "Yui-Chan",
          "avatar_url":
              "https://i.pinimg.com/originals/75/69/61/756961cc572e9143995190252e851124.jpg",
          "content": message,
          "embeds": [
            {
              "title": "Device Detail",
              "description": "Brand : " +
                  merk.value +
                  "\n" +
                  "Model : " +
                  model.value +
                  "\n" +
                  "Chipset : " +
                  hardware.value +
                  "\n" +
                  "OS Version : Android " +
                  osVersion.value +
                  "\n" +
                  "API Version : " +
                  apiVersion.value +
                  "\n",
              "color": 0xFF00FF,
              "footer": {
                "text": "With Love Yui-Chan",
                "icon_url":
                    "https://i.pinimg.com/originals/75/69/61/756961cc572e9143995190252e851124.jpg"
              }
            }
          ]
        }));
    if (response.statusCode == 200 || response.statusCode == 204) {
      Get.snackbar(
        "Report",
        "Report has been sent",
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.snackbar(
        "Report",
        "Report failed to send",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> sendChapterReport(String urll) async {
    // get ip address
    var ip = await http.get(Uri.parse("https://api.ipify.org"));
    var ipAddress = ip.body;
    var url2 = "http://ip-api.com/json/" + ipAddress;
    var response2 = await http.get(Uri.parse(url2));
    var data2 = await json.decode(response2.body);
    var isp = data2['isp'].toString();

    var url = dotenv.env['WEBHOOK_CHAPTER_REPORT'];
    var response = await http.post(Uri.parse(url!),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "username": "Yui-Chan",
          "avatar_url":
              "https://i.pinimg.com/originals/75/69/61/756961cc572e9143995190252e851124.jpg",
          "content": "",
          "embeds": [
            {
              "title": "Chapter Report",
              "description": "URL : " + urll + "\n" + "ISP : " + isp + "\n",
              "color": 0xFF00FF,
              "footer": {
                "text": "With Love Yui-Chan",
                "icon_url":
                    "https://i.pinimg.com/originals/75/69/61/756961cc572e9143995190252e851124.jpg"
              }
            }
          ]
        }));
    if (response.statusCode == 200 || response.statusCode == 204) {
      Get.snackbar(
        "Report",
        "Report has been sent",
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.snackbar(
        "Report",
        "Report failed to send",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}

class CacheImg extends ImageCache {}
