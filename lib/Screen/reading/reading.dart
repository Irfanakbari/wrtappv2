import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrtappv2/Screen/Comment/disqus.dart';
import 'package:wrtappv2/const/abstract.dart';

class ReadingPage extends StatefulWidget {
  final String postId;
  final String chLink;
  final String chName;
  final String chImg;
  final String komikTitle;
  const ReadingPage(
      {Key? key,
      required this.komikTitle,
      required this.postId,
      required this.chLink,
      required this.chName,
      required this.chImg})
      : super(key: key);

  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  // scroll controller

  List<String> imagesr = [];
  var judul = "";
  var konst = Get.put<Konst>(Konst());
  RxBool isLoading = true.obs;
  scrapingData() {
    http.get(Uri.parse(widget.chLink)).then((response) {
      var document = parser.parse(response.body);
      // print(document.getElementById('readerarea'));
      var readerarea = document.getElementById('readerarea')!.outerHtml;
      // get all image src from readerarea
      var imgSrc =
          readerarea.split('src="').map((e) => e.split('"')[0]).toList();
      //  remove div
      imgSrc.removeWhere((element) => element.contains('div'));

      imagesr = imgSrc;
      isLoading.value = false;
      return imgSrc;
    });
  }

  getTitle() async {
    var url = widget.chLink;
    var response = await http.get(Uri.parse(url));
    var document = parser.parse(response.body);
    var title = document
        .getElementsByClassName("entry-title")[0]
        .text
        .toString()
        .trim();
    judul = title;
    return title;
  }

  setHistory() async {
    // save history to shared pref
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dateNow = DateTime.now();
    var data = [
      widget.komikTitle,
      widget.chName,
      widget.chLink,
      widget.chImg,
      widget.postId,
      dateNow.toString()
    ];

    prefs.setStringList('history' + widget.postId, data);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrapingData();
    setHistory();
    getTitle();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // To exit fullscreen mode
  }

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    // text center
    return Scaffold(
        body:
            // pull to refresh
            SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: const ClassicHeader(),
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          imagesr = [];
          isLoading.value = true;
          scrapingData();
          _refreshController.refreshCompleted();
        });
      },
      controller: _refreshController,
      child: Obx(
        () => (isLoading.value)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: GestureDetector(
                  onTap: () {
                    modalBottom(widget.chImg);
                  },
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        for (var i = 0; i < imagesr.length; i++)
                          CachedNetworkImage(
                            imageUrl: imagesr[i] +
                                '?quality=' +
                                konst.readQuality.value,
                            width: Get.width,
                            placeholder: (context, url) => const SizedBox(
                              height: 300,
                              child: Center(
                                  child: CupertinoActivityIndicator(
                                radius: 15,
                              )),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                      ],
                    ),
                  ),
                )),
      ),
    ));
  }

  modalBottom(String gbr) {
    Map<String, String> header = {"referer": "https://wrt.my.id"};

    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.warning), onPressed: () {}),
                      IconButton(
                          icon: const Icon(Icons.message),
                          onPressed: () {
                            Get.to(
                                Disqus(
                                  url: widget.chLink,
                                  title: judul,
                                ),
                                transition: Transition.downToUp);
                          }),
                      IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 80,
                              child: CachedNetworkImage(
                                  imageUrl: gbr,
                                  httpHeaders: header,
                                  fit: BoxFit.fill,
                                  height: 100,
                                  width: 150),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 250,
                                child: Text(
                                  widget.komikTitle,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(widget.chName,
                                  style: const TextStyle(fontSize: 15)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (3 < 5)
                          ? IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () async {})
                          : const SizedBox(),
                      (3 != 0)
                          ? IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () async {})
                          : const SizedBox(
                              height: 0,
                            )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
