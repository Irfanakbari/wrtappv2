import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parse;
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrtappv2/Screen/Comment/disqus.dart';
import 'package:wrtappv2/Screen/bookmark/BmModel.dart';
import 'package:wrtappv2/Screen/reading/reading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  final String url;
  const DetailPage({Key? key, required this.url}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // ignore: prefer_final_fields
  RxBool _isLoading = false.obs;
  var url = 'https://wrt.my.id/komik/onee-san-is-invading/';
  var title = "";
  var sinopsis = [];
  var altTitle = "";
  var releaseDate = "";
  var status = "";
  var type = "";
  var author = "";
  var lastUpdated = "";
  var postedBy = "";
  var views = "";
  var genres = [];
  var chapterName = [];
  var chapterDate = [];
  var chapterLink = [];
  var rating = 0.0;
  var postId = "";
  bool historyStatus = true;
  var cover = "";
  List historyData = [];
  Rx<MaterialColor> warna = Colors.green.obs;
  var bm = Get.find<BmModel>();
  Rx isBookmark = false.obs;
  Rx<String> bookm = 'Bookmark'.obs;

  getHistory() async {
    // get history data from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var history = prefs.getStringList('history' + postId);
    if (history != null) {
      historyStatus = false;
      historyData = history;
      // convert to datetime and get day ago
      var date = DateTime.parse(historyData[5]);
      var difference = DateTime.now().difference(date);
      if (difference.inSeconds < 60) {
        historyData[5] = 'Baru Saja';
      } else if (difference.inMinutes < 60) {
        historyData[5] = difference.inMinutes.toString() + " minutes ago";
      } else if (difference.inHours < 24) {
        historyData[5] = difference.inHours.toString() + " hours ago";
      } else if (difference.inDays < 30) {
        historyData[5] = difference.inDays.toString() + " days ago";
      } else if (difference.inDays < 365) {
        historyData[5] = difference.inDays.toString() + " months ago";
      } else if (difference.inDays < 365 * 2) {
        historyData[5] = difference.inDays.toString() + " years ago";
      }
    } else {
      historyStatus = true;
    }
  }

  scrapData() async {
    if (widget.url != null) {
      url = widget.url;
    }
    var resp = await http.Client().get(Uri.parse(url));
    var document = parse.parse(resp.body);
    title = document.querySelector('h1.entry-title')!.text;
    releaseDate = document
        .getElementsByClassName('infotable')[0]
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr')[2]
        .getElementsByTagName('td')[1]
        .text;
    postId = document.getElementsByTagName('article')[0].attributes['id']!;
    status = document
        .getElementsByClassName('infotable')[0]
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr')[0]
        .getElementsByTagName('td')[1]
        .text;
    type = document
        .getElementsByClassName('infotable')[0]
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr')[1]
        .getElementsByTagName('td')[1]
        .text;
    author = document
        .getElementsByClassName('infotable')[0]
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr')[3]
        .getElementsByTagName('td')[1]
        .text;
    lastUpdated = document
        .getElementsByClassName('infotable')[0]
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr')[8]
        .getElementsByTagName('td')[1]
        .text;
    postedBy = document
        .getElementsByClassName('infotable')[0]
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr')[6]
        .getElementsByTagName('td')[1]
        .text;
    cover = document
        .getElementsByClassName("seriestucontl")[0]
        .getElementsByClassName("thumb")[0]
        .getElementsByTagName("img")[0]
        .attributes["src"]
        .toString();
    views = document
        .getElementsByClassName('infotable')[0]
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr')[9]
        .getElementsByTagName('td')[1]
        .text;
    // get all tag p
    sinopsis = document
        .getElementsByClassName('entry-content')[0]
        .getElementsByTagName('p')
        .map((e) => e.text)
        .toList();
    // get all genre
    genres = document
        .getElementsByClassName('seriestugenre')[0]
        .getElementsByTagName('a')
        .map((e) => e.text)
        .toList();
    chapterName = document
        .getElementsByClassName('chapternum')
        .map((e) => e.text)
        .toList();
    chapterDate = document
        .getElementsByClassName('chapterdate')
        .map((e) => e.text)
        .toList();

    for (var i = 0; i < chapterName.length; i++) {
      chapterLink.add(
        document
            .getElementsByClassName('eph-num')
            .elementAt(i)
            .getElementsByTagName('a')
            .elementAt(0)
            .attributes["href"],
      );
    }
    rating = double.parse(
      document.querySelector('div.num')!.text,
    );
    altTitle = document.querySelector('div.seriestualt')!.text;

    getHistory();
    bm.checkBookmark(postId).then((value) {
      if (value) {
        warna = Colors.red.obs;
        bookm.value = 'Bookmarked';
        isBookmark.value = true;
      } else {
        warna = Colors.green.obs;
        isBookmark.value = false;
        bookm.value = 'Bookmark';
      }
    });
    _isLoading.value = true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrapData();
  }

  @override
  Widget build(BuildContext context) {
    Rx warnaApp = const Color.fromRGBO(86, 84, 158, 1).obs;
    // save warna to local storage

    double _sigmaX = 10; // from 0-10
    double _sigmaY = 10; // from 0-10
    double _opacity = 0.5; // from 0-1.0

    return Obx(() => Scaffold(
          // transparent appbar when top
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 70,
            title: Text(
              'Detail Manga',
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {
                  bookm.value = 'Bookmarked';
                },
              ),
            ],
          ),
          body: _isLoading.value
              ? SizedBox(
                  width: double.infinity,
                  height: Get.height,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        imageUrl: cover.toString(),
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Container(
                          width: 130,
                          height: 160,
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.deepPurple),
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      BackdropFilter(
                        filter:
                            ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                        child: Container(
                          color: const Color.fromRGBO(86, 84, 158, 1)
                              .withOpacity(_opacity),
                        ),
                      ),
                      SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 100,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          32 /
                                          100,
                                      height: 200,
                                      child: CachedNetworkImage(
                                        imageUrl: cover.toString(),
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              32 /
                                              100,
                                          height: 200,
                                          child: const Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Colors.deepPurple),
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          60 /
                                          100,
                                      height: 200,
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  title,
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    GFRating(
                                                      color: Colors.red,
                                                      borderColor: Colors.red,
                                                      size: 25,
                                                      allowHalfRating: true,
                                                      value: rating / 2.0,
                                                      onChanged: (value) {},
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      rating.toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Obx(() => GestureDetector(
                                                child: AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    color: warna.value,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons.favorite,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                          Text(
                                                            bookm.value,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                                onTap: () {
                                                  if (isBookmark.value) {
                                                    try {
                                                      bm
                                                          .deleteBookmark(
                                                              postId)
                                                          .then((value) {
                                                        isBookmark.value =
                                                            false;
                                                        warna.value =
                                                            Colors.green;
                                                        bookm.value =
                                                            'Bookmark';
                                                      });
                                                    } catch (e) {
                                                      Get.snackbar('Error',
                                                          e.toString());
                                                    }
                                                  } else {
                                                    try {
                                                      bm
                                                          .saveBookmark(
                                                              title,
                                                              url,
                                                              cover,
                                                              postId)
                                                          .then((value) {
                                                        isBookmark.value = true;
                                                        warna.value =
                                                            Colors.red;
                                                        bookm.value =
                                                            'Bookmarked';
                                                      });
                                                    } catch (e) {
                                                      Get.snackbar('Error',
                                                          e.toString());
                                                    }
                                                  }
                                                })),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(34, 34, 34, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          altTitle.trimLeft().toString(),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4, bottom: 4),
                                          child: Text(
                                            "Tahun Rilis : " +
                                                releaseDate.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4, bottom: 4),
                                          child: Text(
                                            "Status : " +
                                                status.toString().trimLeft(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4, bottom: 4),
                                          child: Text(
                                            "Author : " +
                                                author.toString().trimLeft(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4, bottom: 4),
                                          child: Text(
                                            "Last Update : " +
                                                lastUpdated
                                                    .toString()
                                                    .trimLeft(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4, bottom: 4),
                                          child: Text(
                                            "Posted By : " +
                                                postedBy
                                                    .toString()
                                                    .trimLeft()
                                                    .trimRight(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4, bottom: 4),
                                            child: Text(
                                              "Views : " +
                                                  views.toString().trimLeft(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(34, 34, 34, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "SINOPSIS",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                          ),
                                          for (var i = 0;
                                              i < sinopsis.length;
                                              i++)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4, bottom: 4),
                                              child: Text(
                                                sinopsis[i].toString(),
                                                style:
                                                    GoogleFonts.archivoNarrow(
                                                        textStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 15)),
                                              ),
                                            ),
                                        ],
                                      )),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(34, 34, 34, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "GENRE",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Wrap(children: [
                                              for (var i = 0;
                                                  i < genres.length;
                                                  i++)
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0,
                                                            right: 5,
                                                            bottom: 6),
                                                    child: GestureDetector(
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          4)),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0.5)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: Text(
                                                              genres[i]
                                                                  .toString()
                                                                  .trimLeft(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )),
                                                      onTap: () {},
                                                    )),
                                            ])
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(34, 34, 34, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "RECENT READ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        Container(
                                            width: double.infinity,
                                            height: 45,
                                            child: GestureDetector(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0,
                                                    right: 5,
                                                    bottom: 15),
                                                child: Container(
                                                    height: 25,
                                                    width: Get.width,
                                                    decoration: const BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1))),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      child: (historyStatus)
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "You have not read any book yet",
                                                                  style: GoogleFonts.archivoNarrow(
                                                                      textStyle: const TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          fontSize:
                                                                              14)),
                                                                )
                                                              ],
                                                            )
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  historyData[1]
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                                Text(
                                                                  historyData[5]
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            ),
                                                    )),
                                              ),
                                              onTap: () async {},
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: Get.width,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(34, 34, 34, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "LIST CHAPTER",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                            // set max height
                                            height: Get.height *
                                                0.3, // set your listview height
                                            width: Get.width,
                                            child: SingleChildScrollView(
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Wrap(children: [
                                                    for (var i = 1;
                                                        i < chapterName.length;
                                                        i++)
                                                      GestureDetector(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0,
                                                                  right: 5,
                                                                  bottom: 15),
                                                          child: Container(
                                                              height: 25,
                                                              width: double
                                                                  .infinity,
                                                              decoration: const BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          color: Colors
                                                                              .grey,
                                                                          width:
                                                                              1))),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      chapterName[
                                                                              i]
                                                                          .toString()
                                                                          .trimLeft(),
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                    Text(
                                                                      chapterDate[
                                                                              i]
                                                                          .toString()
                                                                          .trimLeft(),
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                        ),
                                                        onTap: () async {
                                                          Get.to(
                                                              ReadingPage(
                                                                postId: postId,
                                                                chName: chapterName[
                                                                        i]
                                                                    .toString()
                                                                    .trimLeft(),
                                                                chLink: chapterLink[
                                                                        i]
                                                                    .toString()
                                                                    .trimLeft(),
                                                                chImg: cover
                                                                    .toString(),
                                                                komikTitle: title
                                                                    .toString()
                                                                    .trimLeft(),
                                                              ),
                                                              transition:
                                                                  Transition
                                                                      .fadeIn,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          700));
                                                        },
                                                      )
                                                  ])
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(34, 34, 34, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "KOMENTAR",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: FlatButton(
                                              onPressed: () {
                                                Get.to(
                                                    Disqus(
                                                      url: url,
                                                      title: title,
                                                    ),
                                                    transition:
                                                        Transition.downToUp);
                                              },
                                              color: Colors.red,
                                              child: const Text(
                                                "Komentar",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
