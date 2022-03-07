import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:wrtappv2/controller/auth_controller.dart';

class RestoreBookmark {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var authC = Get.find<AuthC>();
  var statusUp = "".obs;
  var statusDown = "".obs;
  var baseUrl = dotenv.env['URL_API_BOOKMARK'];

  // backup bookmark
  Future backupBookmark(List datas) async {
    var email = await authC.getUserEmail();
    var urlAPI = baseUrl! + "backup";
    // delete old bookmark
    statusUp.value = "Uploading...";
    var dataF = [];

    for (var i = 0; i < datas.length; i++) {
      dataF.add({
        "uid": email,
        "post_id": datas[i]['id'].toString().replaceAll("post-", ""),
        "slug": datas[i]['url']
            .toString()
            .replaceAll("https://wrt.my.id/", "")
            .replaceAll("manga/", "")
            .replaceAll("/", ""),
        "title": datas[i]['title'].toString(),
        "image": datas[i]['image'].toString(),
      });
    }

    await http.post(Uri.parse(urlAPI), body: json.encode(dataF)).catchError(
      (e) {
        Get.snackbar(
          "Error",
          "Failed to backup bookmark",
          icon: const Icon(Icons.error),
        );
      },
    );

    statusUp.value = "";
    return Get.snackbar(
      "Success",
      "Bookmark has been backup",
      icon: const Icon(Icons.check),
    );
  }

  Future getDataLama() async {
    statusDown.value = "Downloading...";

    var email = await authC.getUserEmail();
    var datas = await firestore.collection(email!).doc('limitB').get();
    if (!datas.exists) {
      await firestore.collection(email).doc('limitB').set({
        'limit': 0,
      });
    }
    if (await datas.data()!['limit'] == 0) {
      var datas = await firestore.collection(email).doc('bookmark').get();
      var src = datas.data();
      // delete all bookmark in hive
      var box = await Hive.openBox('bookmarks');
      await box.clear();
      // restore bookmark
      for (var i = 0; i < src!.length; i++) {
        // data.add(src[i.toString()]);
        await box.put(src[i.toString()]['id'], src[i.toString()]);
      }
      await firestore.collection(email).doc('limitB').set({
        'limit': 1,
      });
    }
    statusDown.value = "";
    return Get.snackbar(
      'Berhasil',
      'Data berhasil dikembalikan',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(seconds: 1),
    );
  }

// get data from firestore
  Future getData() async {
    statusDown.value = "Downloading...";
    var email = await authC.getUserEmail();
    await http
        .get(Uri.parse(baseUrl! + "bookmarks?uid=" + email!))
        .then((response) async {
      var src = json.decode(response.body)['data'];
      // delete all bookmark in hive
      var box = await Hive.openBox('bookmarks');
      await box.clear();
      // restore bookmark
      for (var i = 0; i < src.length; i++) {
        // data.add(src[i.toString()]);
        await box.put("post-" + src[i]['post_id'], {
          'id': "post-" + src[i]['post_id'].toString(),
          'image': src[i]['image'],
          'title': src[i]['title'],
          'url': src[i]['slug'],
        });
      }
    });

    statusDown.value = "";
    return Get.snackbar(
      'Berhasil',
      'Data berhasil dikembalikan',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(seconds: 1),
    );
  }
}
