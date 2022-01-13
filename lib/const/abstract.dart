import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
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
  MidtransSDK? midtrans;
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
  RxBool premiumStatus = false.obs;
  Rx<DateTime> expPremium = DateTime.now().obs;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  FirebaseFirestore server = FirebaseFirestore.instance;

  Konst() {
    initSDK();
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
        Future.delayed(const Duration(milliseconds: 1000), () {
          Get.to(DetailPage(url: result.notification.launchUrl.toString()));
        });
      } else {
        var url = result.notification.launchUrl.toString();
        url = url.substring(url.indexOf(".id/") + 4);
        url = "https://wrt.my.id/manga/$url";
        url = url.substring(0, url.indexOf("-chapter-"));
        Get.to(DetailPage(url: url));
      }
    });
  }

  void initSDK() async {
    midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: "SB-Mid-client-lbd0oNugCP2QSV1P",
        merchantBaseUrl: "https://api.sandbox.midtrans.com",
        language: 'id',
      ),
    );
    midtrans?.setUIKitCustomSetting(
      skipCustomerDetailsPages: true,
    );
    midtrans!.setTransactionFinishedCallback((result) async {
      if (!result.isTransactionCanceled) {
        await topUpAccount();
      } else {
        Get.snackbar(
          "Pembayaran Gagal",
          "Pembayaran dibatalkan",
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ),
          duration: const Duration(seconds: 3),
        );
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

  Future getSNAPKey() async {
    var url = "https://app.sandbox.midtrans.com/snap/v1/transactions";
    var randomInt = Random().nextInt(1000);
    var response = await http.post(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization":
              "Basic U0ItTWlkLXNlcnZlci1MSkJfbTR6N3NDRGU5b3lxaHE0VXo5eF86"
        },
        body: jsonEncode({
          "transaction_details": {
            "order_id": "Prem-$randomInt",
            "gross_amount": 10000
          },
          "enabled_payments": [
            "echannel",
            "bca_va",
            "bni_va",
            "bri_va",
            "gopay",
            "shopeepay"
          ],
          "customer_details": {
            "first_name": "TEST",
            "last_name": "MIDTRANSER",
            "email": "test@midtrans.com",
            "phone": "+628123456",
            "billing_address": {
              "first_name": "TEST",
              "last_name": "MIDTRANSER",
              "email": "test@midtrans.com",
              "phone": "081 2233 44-55",
              "address": "Sudirman",
              "city": "Jakarta",
              "postal_code": "12190",
              "country_code": "IDN"
            },
            "shipping_address": {
              "first_name": "TEST",
              "last_name": "MIDTRANSER",
              "email": "test@midtrans.com",
              "phone": "0 8128-75 7-9338",
              "address": "Sudirman",
              "city": "Jakarta",
              "postal_code": "12190",
              "country_code": "IDN"
            }
          },
          "item_details": [
            {
              "id": "WRT Premium 1 Bulan",
              "price": 10000,
              "quantity": 1,
              "name": "Midtrans Bear",
              "brand": "Midtrans",
              "category": "Toys",
              "merchant_name": "World Romance Translation"
            }
          ],
        }));
    var res = jsonDecode(response.body);
    var snapToken = res['token'];
    return snapToken;
  }

  Future topUpAccount() async {
    var email = await getUserEmail();
    var data = await server.collection(email!).doc("premium").get();

    if ((await data.data()!["expired"] as Timestamp)
        .toDate()
        .difference(DateTime.now())
        .inSeconds
        .isNegative) {
      (await data.data()!["status"] == true)
          ? await server.collection(email).doc("premium").update({
              "expired": (await data.data()!["expired"] as Timestamp)
                  .toDate()
                  .add(const Duration(days: 7)),
              "status": true,
            })
          : await server.collection(email).doc("premium").update({
              "expired": DateTime.now().add(const Duration(days: 7)),
              "status": false,
            });
      premiumStatus.value = true;
      expPremium.value = (await data.data()!["expired"] as Timestamp).toDate();
    } else {
      premiumStatus.value = false;
      expPremium.value = (await data.data()!["expired"] as Timestamp).toDate();
    }
    Get.snackbar(
      "Pembayaran Berhasil",
      "Pembayaran berhasil",
      icon: const Icon(
        Icons.check,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 3),
    );
  }

  Future setStatusAccount() async {
    var email = await getUserEmail();
    if (!await server
        .collection(email!)
        .doc("premium")
        .get()
        .then((value) => value.exists)) {
      await server.collection(email).doc("premium").set({
        "status": false,
        "expired": DateTime.now(),
      });
    }
    var data = await server.collection(email).doc("premium").get();
    if ((await data.data()!["expired"] as Timestamp)
            .toDate()
            .difference(DateTime.now())
            .inSeconds >
        0) {
      await server.collection(email).doc("premium").update({"status": true});
      premiumStatus.value = true;
      expPremium.value = (data.data()!["expired"] as Timestamp).toDate();
    } else {
      await server.collection(email).doc("premium").update({"status": false});
      premiumStatus.value = false;
      expPremium.value = DateTime.now();
    }
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

  Future<void> sendReport(String message) async {
    var url =
        "https://discord.com/api/webhooks/930338967822422016/MOXMqhVzDlXFIj1Kz4W8RK_Tr02M9_g_MLZZxxGWMBYIhEwcih13jZfpBp3Ne0xJs9tO";
    var response = await http.post(Uri.parse(url),
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

    var url =
        "https://discord.com/api/webhooks/930339315609911337/7ttcd5pdJyc4AwUNFSFdzKERBOL9sDDsAG1HSYJbSiAE36UHjisaFgDT8873rdZQe7pB";
    var response = await http.post(Uri.parse(url),
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

class CacheImg extends ImageCache {
  @override
  void clear() {
    super.clear();
  }
}
