import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parse;
import 'package:get/get.dart';
import 'package:wrtappv2/Screen/homepage/newkomik.dart';

class ScrapHome {
  // popular
  final popular = [].obs;

  // pj update
  final pjUpdate = [].obs;

  // latest
  final latest = [].obs;

  // Detail
  final detail = [].obs;

  // image read
  final imageRead = {}.obs;

  // all komik
  final dataAll = [].obs;

  // searchdata
  final resultSearch = [].obs;

  // projectdata
  final projectData = [].obs;

  // newer data
  final newerData = [].obs;

  // genredata
  final _titleG = [].obs;
  final _chaptersG = [].obs;
  final _chapters_urlG = [].obs;
  final _imageG = [].obs;
  final _skorG = [].obs;

  // newer komik
  final newerKomik = [].obs;

  var url = 'https://api.wrt.my.id/api/';

  Future<void> delData() async {
    popular.value = [];
    pjUpdate.value = [];
    latest.value = [];
    dataAll.value = [];
    resultSearch.value = [];
    _titleG.value = [];
    _chaptersG.value = [];
    _chapters_urlG.value = [];
    _imageG.value = [];
    _skorG.value = [];
    newerKomik.value = [];
  }

  Future<void> getData() async {
    await delData();
    var response = await http.get(Uri.parse(url + 'home'));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      var data = res['data'];

      // Popular
      for (var i = 0; i < data['populer'].length - 1; i++) {
        popular.add(data['populer'][i]);
      }

      // Pj Update
      for (var i = 0; i < data['project'].length; i++) {
        pjUpdate.add(data['project'][i]);
      }

      // Latest Update
      for (var i = 0; i < data['rilis'].length; i++) {
        latest.add(data['rilis'][i]);
      }
    } else {
      Get.snackbar('Error', 'Terjadi kesalahan pada server',
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ),
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(10));
    }
  }

  Future<List> getNewList(int page) async {
    var response = await http
        .get(Uri.parse('https://api.wrt.my.id/api/new/' + page.toString()));
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      var data = res['data'];
      newerData.value = data;
    } else {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan pada server',
        snackPosition: SnackPosition.TOP,
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
        duration: const Duration(seconds: 5),
      );
    }
    return newerData;
  }

  Future<List> getDetail(String slug) async {
    detail.value = [];
    var response = await http.get(Uri.parse(url + 'detail/' + slug));
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      var data = res['data'];

      // Detail
      detail.add(data[0]);
    } else {
      Get.snackbar(
        'Error',
        'Kesalahan saat mengambil data',
        icon: const Icon(
          Icons.error,
        ),
        borderRadius: 10,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
    return detail;
  }

  Future<Map> getReadKomik(String slug) async {
    var response = await http.get(Uri.parse(url + 'read/' + slug));
    var res = json.decode(response.body);
    if (response.statusCode == 200) {
      var dataH = res['data-high'];
      var dataM = res['data-med'];
      var dataL = res['data-min'];
      var listData = {'data-high': dataH, 'data-med': dataM, 'data-min': dataL};
      imageRead.value = listData;
      return imageRead;
    } else {
      return {};
    }
  }

  Future<List> getAllKomik(int page) async {
    // dataAll.value = [];
    var response =
        await http.get(Uri.parse(url + 'mangalist/' + page.toString()));
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      var data = res['data'];
      dataAll.addAll(data);
    } else {
      Get.snackbar(
        'Error',
        'Kesalahan saat mengambil data',
        icon: const Icon(
          Icons.error,
        ),
        borderRadius: 10,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
    return dataAll;
  }

  Future<List> getProject(int page) async {
    var response = await http
        .get(Uri.parse('https://api.wrt.my.id/project/' + page.toString()));
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      var data = res['data'];
      var total = int.parse(res['total_page']);
      projectData.value = [data, total];
    } else {
      Get.snackbar(
        'Error',
        'Kesalahan saat mengambil data',
        icon: const Icon(
          Icons.error,
        ),
        borderRadius: 10,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
    return projectData;
  }

  Future<void> genreResult(String url) async {
    var response = await http.get(Uri.parse(url));
    var document = parse.parse(response.body);
    var core = document.getElementsByClassName('bs');
    for (var i = 0; i < core.length; i++) {
      _titleG.add(
          core[i].getElementsByClassName('tt')[0].text.toString().trimLeft());

      _chaptersG.add(core[i]
          .getElementsByClassName('adds')[0]
          .getElementsByClassName('epxs')[0]
          .text);

      _chapters_urlG.add(core[i]
          .getElementsByClassName('bsx')[0]
          .getElementsByTagName('a')[0]
          .attributes['href']);

      _imageG.add(core[i].getElementsByTagName('img')[0].attributes['src']);
      _skorG.add(core[i].getElementsByClassName('numscore')[0].text);
    }
  }

  Future<List> searchKomik(String keyword, int page) async {
    var response = await http
        .get(Uri.parse(url + 'search/' + keyword + '/' + page.toString()));
    var res = json.decode(response.body);
    page = res['page_length'];
    var data = res['data'];
    var result = [data, page];
    resultSearch.value = result;
    return resultSearch;
  }

  // Getter popular
  get popularKomik => popular;

  // Getter pj update
  get pjUpdateKomik => pjUpdate;

  // Getter latest update
  get latestKomik => latest;

  // Getter all komik
  List get dataAllKomik => dataAll;

  // getter genre result
  List get titleG => _titleG;
  List get chaptersG => _chaptersG;
  List get chaptersUrlG => _chapters_urlG;
  List get imageG => _imageG;
  List get skorG => _skorG;

  // getter newer komik
  get titleN => newerKomik;
}
