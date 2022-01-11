import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:wrtappv2/Screen/reading/sys/ModelRestore.dart';

class BmModel {
  RxList bmList = [].obs;
  Future<void> initHive() async {
    await Hive.initFlutter();
  }

  BmModel() {
    initHive();
    getAllBookmark();
  }

  // save bookmark to hive
  Future saveBookmark(String title, String url, String image, String id) async {
    //  check if bookmark exists
    var exists = await Hive.openBox('bookmarks');
    var existsBookmark = exists.get(id);
    if (existsBookmark == null) {
      exists.put(id, {
        'title': title,
        'url': url,
        'image': image,
        'id': id,
      });
    }
    Get.snackbar('Bookmark Tersimpan', title,
        snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
  }

  // cekbookmark
  checkBookmark(String id) async {
    var exists = await Hive.openBox('bookmarks');
    var existsBookmark = exists.get(id);
    if (existsBookmark == null) {
      return false;
    } else {
      return true;
    }
  }

  // delete bookmark
  Future deleteBookmark(String id) async {
    var exists = await Hive.openBox('bookmarks');
    exists.delete(id);
    Get.snackbar('Bookmark Dihapus', '',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
  }

  // delete all bookmark
  deleteAllBookmark() async {
    var box = await Hive.openBox('bookmarks');
    box.clear();
    Get.snackbar('Semua Bookmark Dihapus', '',
        snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
  }

  Future getAllBookmark() async {
    var box = await Hive.openBox('bookmarks');
    // print(box.values.toList());
    bmList.value = box.values.toList();
    return box.values.toList();
  }

  Future saveToServer() async {
    var box = await Hive.openBox('bookmarks');
    var data = box.values.toList();
    var server = RestoreBookmark();
    await server.backupBookmark(data);
    return Get.snackbar("Berhasil", "Data bookmark berhasil diupload ke server",
        snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
  }
}
