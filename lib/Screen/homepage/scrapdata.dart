import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parse;
import 'package:get/get.dart';

class ScrapHome {
  // popular
  final _title = [].obs;
  final _chapters = [].obs;
  final _chapters_url = [].obs;
  final _image = [].obs;
  final _skor = [].obs;

  // pj update
  final _titlePj = [].obs;
  final _chaptersPj = [].obs;
  final _chapters_urlPj = [].obs;
  final _imagePj = [].obs;

  // latest
  final _titleLU = [].obs;
  final _chaptersLU = [].obs;
  final _chapters_urlLU = [].obs;
  final _imageLU = [].obs;
  final _timeLU = [].obs;

  // all komik
  final _titleAll = [].obs;
  final _chaptersAll = [].obs;
  final _chapters_urlAll = [].obs;
  final _imageAll = [].obs;
  final _skorAll = [].obs;

  // searchdata
  final _titleS = [].obs;
  final _chaptersS = [].obs;
  final _chapters_urlS = [].obs;
  final _imageS = [].obs;
  final _skorS = [].obs;

  // genredata
  final _titleG = [].obs;
  final _chaptersG = [].obs;
  final _chapters_urlG = [].obs;
  final _imageG = [].obs;
  final _skorG = [].obs;

  // newer komik
  final _titleNK = [].obs;
  final _genreNK = [].obs;
  final _yearNK = [].obs;
  final _imageNK = [].obs;
  final _urlNK = [].obs;

  var url = 'https://wrt.my.id/';

  Future<void> delData() async {
    title.clear();

    chapters.clear();
    chaptersUrl.clear();
    image.clear();
    skor.clear();
    titlePj.clear();
    chaptersPj.clear();
    chaptersUrlPj.clear();
    imagePj.clear();
    titleLU.clear();
    chaptersLU.clear();
    chaptersUrlLU.clear();
    imageLU.clear();
    timeLU.clear();
  }

  Future<void> getData() async {
    await delData();
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
    await getDataPj();
    await getDataLastUpdate();
    await getNewerKomik();
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

  Future<void> searchKomik(String keyword, int page) async {
    var url = 'https://wrt.my.id/page/' + page.toString() + '?s=' + keyword;
    var response = await http.get(Uri.parse(url));
    var document = parse.parse(response.body);
    var core = document.getElementsByClassName('bs');
    for (var i = 0; i < core.length; i++) {
      _titleS.add(
          core[i].getElementsByClassName('tt')[0].text.toString().trimLeft());

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

  Future<void> getNewerKomik() async {
    _titleNK.clear();
    _genreNK.clear();
    _yearNK.clear();
    _imageNK.clear();
    var response = await http.get(Uri.parse(url));
    var document = parse.parse(response.body);
    var core = document.getElementsByClassName('serieslist')[3];
    var core2 = core.getElementsByClassName('leftseries');
    var core3 = core.getElementsByClassName('imgseries');

    for (var i = 0; i < core2.length; i++) {
      _titleNK.add(core2[i]
          .getElementsByClassName('series')[0]
          .text
          .toString()
          .trimLeft());
      _genreNK.add(
          core2[i].getElementsByTagName('span')[0].text.toString().trimLeft());
      _yearNK.add(
          core2[i].getElementsByTagName('span')[1].text.toString().trimLeft());
    }
    for (var i = 0; i < core3.length; i++) {
      _urlNK.add(core3[i].getElementsByTagName('a')[0].attributes['href']);
      _imageNK.add(core3[i].getElementsByTagName('img')[0].attributes['src']);
    }
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

  // getter genre result
  List get titleG => _titleG;
  List get chaptersG => _chaptersG;
  List get chaptersUrlG => _chapters_urlG;
  List get imageG => _imageG;
  List get skorG => _skorG;

  // getter newer komik
  List get titleNK => _titleNK;
  List get genreNK => _genreNK;
  List get yearNK => _yearNK;
  List get imageNK => _imageNK;
  List get urlNK => _urlNK;
}
