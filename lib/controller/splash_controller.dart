import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wrtappv2/ErrorPage/closeapp.dart';
import 'package:wrtappv2/ErrorPage/iderror.dart';
import 'package:wrtappv2/Screen/homepage/scrapdata.dart';
import 'package:wrtappv2/const/tema.dart';
import 'package:wrtappv2/controller/notif_controller.dart';
import 'package:wrtappv2/controller/setting_controller.dart';
import 'auth_controller.dart';

class SplashC extends GetxController {
  RxBool isSplash = true.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Rx isConfig = "Loading Config".obs;
  FirebaseFirestore server = FirebaseFirestore.instance;
  Rx identifier = "".obs;
  Rx merk = "".obs;
  Rx model = "".obs;
  Rx hardware = "".obs;
  Rx osVersion = "".obs;
  Rx apiVersion = "".obs;
  Rx versi = "".obs;
  RxBool statusID = true.obs;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  var notifC = Get.put(NotifC());
  var authC = Get.put(AuthC());
  var settingC = Get.put(SettingC());
  var linkGambar = "".obs;
  var linkGambar2 = "".obs;
  var linkGambardetail = "".obs;
  var bolehAmbilLama = 0.obs;

  Future initialize() async {
    var email = await authC.getUserEmail();

    notifC.notifHandler();
    blockOrientation();
    var status = Tema().getDark();
    if (status == 0) {
      Tema().mode.value = 0;
    } else if (status == 1) {
      Tema().mode.value = 1;
    } else if (status == 2) {
      Tema().mode.value = 2;
    } else if (status == 3) {
      Tema().mode.value = 3;
    }
    final ref = FirebaseDatabase.instance.ref();
    final statusserver = await ref.child('server/status').get();
    if (statusserver.value == "off") {
      Get.offAll(() => const CloseApp(
          message: "Aplikasi Ditutup Sementara, sedang ada perbaikan server"));
    }
    final topBanner = await ref.child('topBanner').get();
    final snapshot = await ref.child('imagehome').get();
    final detail = await ref.child('imageDetail').get();
    linkGambar.value = snapshot.value.toString();
    linkGambar2.value = topBanner.value.toString();
    linkGambardetail.value = detail.value.toString();
    var home = Get.put(ScrapHome());

    isConfig.value = "Loading Config";
    await home.getData();

    validationDeviceID();
    await cekUpdate();

    var datas = await firestore.collection(email!).doc('limitB').get();
    var data = await datas.data()!['limit'];
    bolehAmbilLama.value = data;

    await home.getAllKomik(1);
    isConfig.value = "Loading Data";

    await notifC.notifCek();
    isConfig.value = "Finish";
  }

  void blockOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future cekUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionold = packageInfo.version;
    versi.value = versionold;
  }

  Future validationDeviceID() async {
    var email = await authC.getUserEmail();
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
}
