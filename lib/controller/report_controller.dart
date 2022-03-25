import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wrtappv2/controller/splash_controller.dart';

class ReportC {
  var splashC = Get.find<SplashC>();

  // Send report to Discord Webhook
  Future sendReport(String message) async {
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
                  splashC.merk.value +
                  "\n" +
                  "Model : " +
                  splashC.model.value +
                  "\n" +
                  "Chipset : " +
                  splashC.hardware.value +
                  "\n" +
                  "OS Version : Android " +
                  splashC.osVersion.value +
                  "\n" +
                  "API Version : " +
                  splashC.apiVersion.value +
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
      return Get.snackbar(
        "Report",
        "Report has been sent",
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        snackPosition: SnackPosition.TOP,
      );
    } else {
      return Get.snackbar(
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

  // Send chapter report to Discord Webhook
  Future sendChapterReport(String urll) async {
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
      return Get.snackbar(
        "Report",
        "Report has been sent",
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        snackPosition: SnackPosition.TOP,
      );
    } else {
      return Get.snackbar(
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
