import 'package:flutter/material.dart';
import 'package:wrtappv2/Screen/Comment/chat.dart';
import 'package:wrtappv2/Screen/homepage/lastupdate.dart';
import 'package:wrtappv2/Screen/homepage/popular.dart';
import 'package:wrtappv2/Screen/homepage/project.dart';
import 'package:wrtappv2/Screen/search/searchpage.dart';
import 'package:wrtappv2/const/abstract.dart';
import 'package:wrtappv2/const/tema.dart';
import 'package:get/get.dart';
import 'homepage/scrapdata.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dataSrc = Get.find<ScrapHome>();
  var konst = Get.find<Konst>();
  var _tema = Get.find<Tema>();
  var isLoading = false.obs;

// pj variable

  var _titlePj = [].obs;
  var _linkPj = [].obs;
  var _imagePj = [].obs;
  var _chaptersPj = [].obs;

// popular variable
  var _title = [].obs;
  var _link = [].obs;
  var _image = [].obs;
  var _chapters = [].obs;
  var _skor = [].obs;

  // latest
  var _titleLU = [].obs;
  var _chaptersLU = [].obs;
  var _chapters_urlLU = [].obs;
  var _imageLU = [].obs;
  var _timeLU = [].obs;

  getData() async {
    // run syncrhonous
    await dataSrc.getData().then((value) async {
      _titlePj.value = dataSrc.titlePj;
      _linkPj.value = dataSrc.chaptersUrlPj;
      _imagePj.value = dataSrc.imagePj;
      _chaptersPj.value = dataSrc.chaptersPj;
      _title.value = dataSrc.title;
      _link.value = dataSrc.chaptersUrl;
      _image.value = dataSrc.image;
      _chapters.value = dataSrc.chapters;
      _skor.value = dataSrc.skor;
      _titleLU.value = dataSrc.titleLU;
      _chaptersLU.value = dataSrc.chaptersLU;
      _chapters_urlLU.value = dataSrc.chaptersUrlLU;
      _imageLU.value = dataSrc.imageLU;
      _timeLU.value = dataSrc.timeLU;
    }).then((value) {
      if (mounted) {
        setState(() {
          isLoading.value = true;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    konst.getStatusServer();
    konst.validationDeviceID();
    konst.cekUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Get.to(const SearchPage(),
                    transition: Transition.downToUp,
                    duration: const Duration(milliseconds: 300));
              },
            ),
            IconButton(
              icon: const Icon(Icons.message_rounded),
              onPressed: () {
                Get.to(Chatango(), transition: Get.defaultTransition);
              },
            ),
          ],
          toolbarHeight: 70,
          title: SizedBox(
              width: 200,
              height: 60,
              child: Image.asset(
                'assets/img/logo.png',
                fit: BoxFit.contain,
              )),
        ),
        body: (isLoading.value)
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Popular(
                      title: _title,
                      url: _link,
                      image: _image,
                      chapters: _chapters,
                      skor: _skor,
                    ),
                    Project(
                      titlePj: _titlePj,
                      linkPj: _linkPj,
                      imagePj: _imagePj,
                      chaptersPj: _chaptersPj,
                    ),
                    LastUpdate(
                      titleLU: _titleLU,
                      chaptersLU: _chaptersLU,
                      linkLU: _chapters_urlLU,
                      imageLU: _imageLU,
                      timeLU: _timeLU,
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
