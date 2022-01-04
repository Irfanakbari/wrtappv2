import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parse;
import 'package:get/get.dart';

class ScrapHome {
  // popular
  var _title = [].obs;
  var _chapters = [].obs;
  var _chapters_url = [].obs;
  var _image = [].obs;
  var _skor = [].obs;

  // pj update
  var _titlePj = [].obs;
  var _chaptersPj = [].obs;
  var _chapters_urlPj = [].obs;
  var _imagePj = [].obs;

  // latest
  var _titleLU = [].obs;
  var _chaptersLU = [].obs;
  var _chapters_urlLU = [].obs;
  var _imageLU = [].obs;
  var _timeLU = [].obs;

  // all komik
  var _titleAll = [].obs;
  var _chaptersAll = [].obs;
  var _chapters_urlAll = [].obs;
  var _imageAll = [].obs;
  var _skorAll = [].obs;

  // searchdata
  var _titleS = [].obs;
  var _chaptersS = [].obs;
  var _chapters_urlS = [].obs;
  var _imageS = [].obs;
  var _skorS = [].obs;

  var url = 'https://wrt.my.id/';

  ScrapHome() {
    getData();
    getDataPj();
    getDataLastUpdate();
  }

  Future<void> getData() async {
    var response = await http.get(Uri.parse(url));
    var document = parse.parse(response.body);
    var core = document.getElementsByClassName('hothome')[0];
    var title = core.getElementsByClassName('tt');
    var chapters = core.getElementsByClassName('epxs');
    var chaptersUrl = core.getElementsByTagName('a');
    var image = core.getElementsByTagName('img');
    var skor = core.getElementsByClassName('numscore');
    for (var i = 0; i < title.length - 1; i++) {
      _title.add(title[i].text.trimLeft().toString());
      _chapters.add(chapters[i].text);
      _chapters_url.add(chaptersUrl[i].attributes['href']);
      _image.add(image[i].attributes['src']);
      _skor.add(skor[i].text);
    }
  }

  Future<void> getDataPj() async {
    var url = 'https://wrt.my.id/';
    var response = await http.get(Uri.parse(url));
    var document = parse.parse(response.body);
    var core = document.getElementsByClassName('stylefiv');
    for (var i = 0; i < core.length - 3; i++) {
      _titlePj.add(core[i]
          .getElementsByClassName('tt')[0]
          .getElementsByTagName('a')[0]
          .text);

      var chapters =
          core[i].getElementsByClassName('chfiv')[0].getElementsByTagName('li');
      var chaptersText = [];
      for (var j = 0; j < chapters.length; j++) {
        chaptersText.add(chapters[j].getElementsByTagName('a')[0].text);
      }
      _chaptersPj.add(chaptersText);

      _chapters_urlPj.add(core[i]
          .getElementsByClassName('bsx')[0]
          .getElementsByTagName('a')[0]
          .attributes['href']);

      _imagePj.add(core[i].getElementsByTagName('img')[0].attributes['src']);
    }
  }

  Future<void> getDataLastUpdate() async {
    var response = await http.get(Uri.parse(url));
    var document = parse.parse(response.body);
    var core = document.getElementsByClassName('utao');
    for (var i = 0; i < core.length; i++) {
      _titleLU.add(core[i]
          .getElementsByClassName('luf')[0]
          .getElementsByTagName('a')[0]
          .text);

      var chapters =
          core[i].getElementsByClassName('Manga')[0].getElementsByTagName('li');
      _chaptersLU.add(chapters[0].getElementsByTagName('a')[0].text);

      _chapters_urlLU.add(core[i]
          .getElementsByClassName('imgu')[0]
          .getElementsByTagName('a')[0]
          .attributes['href']);

      _imageLU.add(core[i]
          .getElementsByClassName('uta')[0]
          .getElementsByTagName('img')[0]
          .attributes['src']);

      _timeLU.add(chapters[0].getElementsByTagName('span')[0].text);
    }
  }

  Future<void> getAllKomik(int id) async {
    var urlAll = 'https://wrt.my.id/manga/?page=' + id.toString();
    var response = await http.get(Uri.parse(urlAll));
    var document = parse.parse(response.body);
    var core = document.getElementsByClassName('bs');
    for (var i = 0; i < core.length; i++) {
      _titleAll.add(
          core[i].getElementsByClassName('tt')[0].text.toString().trimLeft());

      _chaptersAll.add(core[i]
          .getElementsByClassName('adds')[0]
          .getElementsByClassName('epxs')[0]
          .text);

      _chapters_urlAll.add(core[i]
          .getElementsByClassName('bsx')[0]
          .getElementsByTagName('a')[0]
          .attributes['href']);

      _imageAll.add(core[i].getElementsByTagName('img')[0].attributes['src']);
      _skorAll.add(core[i].getElementsByClassName('numscore')[0].text);
    }
  }

  Future<void> searchKomik(String keyword, int page) async {
    var url = 'https://wrt.my.id/page/' + page.toString() + '?s=' + keyword;
    var response = await http.get(Uri.parse(url));
    var document = parse.parse(response.body);
    var core = document.getElementsByClassName('bs');
    for (var i = 0; i < core.length; i++) {
      _titleS.add(
          core[i].getElementsByClassName('tt')[0].text.toString().trimLeft());
      print(core);

      _chaptersS.add(core[i]
          .getElementsByClassName('adds')[0]
          .getElementsByClassName('epxs')[0]
          .text);

      _chapters_urlS.add(core[i]
          .getElementsByClassName('bsx')[0]
          .getElementsByTagName('a')[0]
          .attributes['href']);

      _imageS.add(core[i].getElementsByTagName('img')[0].attributes['src']);
      _skorS.add(core[i].getElementsByClassName('numscore')[0].text);
    }
    // print(_titleS);
  }

  // Getter popular
  List get title => _title;
  List get chapters => _chapters;
  List get chaptersUrl => _chapters_url;
  List get image => _image;
  List get skor => _skor;

  // Getter pj update
  List get titlePj => _titlePj;
  List get chaptersPj => _chaptersPj;
  List get chaptersUrlPj => _chapters_urlPj;
  List get imagePj => _imagePj;

  // Getter latest update
  List get titleLU => _titleLU;
  List get chaptersLU => _chaptersLU;
  List get chaptersUrlLU => _chapters_urlLU;
  List get imageLU => _imageLU;
  List get timeLU => _timeLU;

  // Getter all Komik
  List get titleAll => _titleAll;
  List get chaptersAll => _chaptersAll;
  List get chaptersUrlAll => _chapters_urlAll;
  List get imageAll => _imageAll;
  List get skorAll => _skorAll;

  // Search Komik
  List get titleS => _titleS;
  List get chaptersS => _chaptersS;
  List get chaptersUrlS => _chapters_urlS;
  List get imageS => _imageS;
  List get skorS => _skorS;

  // setter search komik
  set setTitleS(List title) => _titleS.value = title;
  set setChaptersS(List chapters) => _chaptersS.value = chapters;
  set setChaptersUrlS(List chaptersUrl) => _chapters_urlS.value = chaptersUrl;
  set setImageS(List image) => _imageS.value = image;
  set setSkorS(List skor) => _skorS.value = skor;
}
