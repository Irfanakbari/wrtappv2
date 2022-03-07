import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrtappv2/Screen/detailpage.dart';
import 'package:is_first_run/is_first_run.dart';

class NotifC extends GetxController {
  RxBool notifStatus = false.obs;

  void changeStatusNotif() async {
    var prefs = await SharedPreferences.getInstance();
    // onesignal subscription
    OneSignal.shared.disablePush(notifStatus.value).then((value) {
      prefs.setBool("notifStatus", notifStatus.value);
    });
    // FCM subscription
    if (notifStatus.value) {
      await FirebaseMessaging.instance.unsubscribeFromTopic('all');
    } else {
      await FirebaseMessaging.instance.subscribeToTopic('all');
    }
  }

  Future<void> notifHandler() async {
    // Onesignal init
    OneSignal.shared.setAppId("be7dac02-14fd-470f-bf7d-5ba24e08bdd2");
    // Onesignal notification handler
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

  Future notifCek() async {
    bool firstRun = await IsFirstRun.isFirstRun();
    var prefs = await SharedPreferences.getInstance();
    var notif = prefs.getBool('notifStatus');
    // if notif is null, subscribe Onesignal
    if (firstRun) {
      notifStatus.value = false;
      prefs.setBool('notifStatus', false);
      FirebaseMessaging.instance.subscribeToTopic('all');
    } else {
      notifStatus.value = notif!;
    }
  }
}
