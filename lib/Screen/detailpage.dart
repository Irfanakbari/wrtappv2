import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrtappv2/Screen/Comment/disqus.dart';
import 'package:wrtappv2/Screen/bookmark/BmModel.dart';
import 'package:wrtappv2/Screen/homepage/scrapdata.dart';
import 'package:wrtappv2/Screen/reading/reading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrtappv2/const/abstract.dart';

class DetailPage extends StatefulWidget {
  final String slug;
  final String url;
  const DetailPage({Key? key, required this.slug, required this.url})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  RxBool isLoading = false.obs;
  RxList data = [].obs;
  RxString postID = "".obs;
  var scrapdata = Get.find<ScrapHome>();
  var prefs;
  RxBool historyStatus = true.obs;
  // var cover = "";
  var historyData = [].obs;
  Rx<MaterialColor> warna = Colors.green.obs;
  var bm = Get.find<BmModel>();
  Rx isBookmark = false.obs;
  Rx<String> bookm = 'Bookmark'.obs;
  final _konst = Get.find<Konst>();

  Stream getHistory() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      var history = prefs.getStringList('history' + postID.value);
      if (history != null) {
        historyStatus.value = false;
        historyData.value = history;
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
        historyStatus.value = true;
      }
      yield historyData;
    }
  }

  scrapData() async {
    prefs = await SharedPreferences.getInstance();
    await scrapdata.getDetail(widget.slug).then((value) {
      data.value = value;
      postID.value = data[0]['post_id'] ?? "";
    });

    getHistory();
    bm.checkBookmark(data[0]['post_id']).then((value) {
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
    isLoading.value = true;
  }

  @override
  void initState() {
    super.initState();

    scrapData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          ),
          body: isLoading.value
              ? SizedBox(
                  width: double.infinity,
                  height: Get.height,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        cacheManager: CacheManager(Config(
                          data[0]['cover'].toString(),
                          stalePeriod: const Duration(hours: 2),
                        )),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        imageUrl:
                            data[0]['cover'].toString() + '?resize=200,325',
                        fit: BoxFit.fill,
                        placeholder: (context, url) => const SizedBox(
                          width: 130,
                          height: 160,
                          child: Center(
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
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          32 /
                                          100,
                                      height: 200,
                                      child: CachedNetworkImage(
                                        cacheManager: CacheManager(Config(
                                          data[0]['cover'].toString(),
                                          stalePeriod: const Duration(hours: 2),
                                        )),
                                        imageUrl: data[0]['cover'].toString() +
                                            '?resize=200,325',
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) => SizedBox(
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
                                                  data[0]['title'].toString(),
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
                                                      value: double.parse(
                                                              data[0]
                                                                  ['rating']) /
                                                          2,
                                                      onChanged: (value) {},
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      data[0]['rating']
                                                          .toString(),
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
                                                              data[0]
                                                                  ['post_id'])
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
                                                        data[0]['title'],
                                                        widget.slug,
                                                        data[0]['cover'],
                                                        data[0]['post_id'],
                                                      )
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
                                          data[0]["alternative"]
                                              .trimLeft()
                                              .toString(),
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
                                                data[0]['info'][2]["Rilis"]
                                                    .toString(),
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
                                                data[0]['info'][0]["Status"]
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
                                            "Author : " +
                                                data[0]['info'][3]["Author"]
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
                                            "Last Update : " +
                                                data[0]['info'][8]
                                                        ["Last Update"]
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
                                                data[0]['info'][6]["Uploader"]
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
                                                  data[0]['info'][9]["Viewers"]
                                                      .toString()
                                                      .trimLeft(),
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4, bottom: 4),
                                            child: Text(
                                              data[0]['sinopsis'].toString(),
                                              style: GoogleFonts.archivoNarrow(
                                                  textStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.normal,
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
                                                  i < data[0]['genre'].length;
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
                                                              data[0]['genre']
                                                                      [i]
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
                                        SizedBox(
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
                                                            const EdgeInsets
                                                                .all(0),
                                                        child: StreamBuilder<
                                                            dynamic>(
                                                          stream: getHistory(),
                                                          builder: (context,
                                                              snapshot) {
                                                            return (historyStatus
                                                                    .value)
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        "You have not read any book yet",
                                                                        style: GoogleFonts.archivoNarrow(
                                                                            textStyle: const TextStyle(
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.normal,
                                                                                fontSize: 14)),
                                                                      )
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        snapshot
                                                                            .data[1]
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.normal),
                                                                      ),
                                                                      Text(
                                                                        snapshot
                                                                            .data[5]
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .grey,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.normal),
                                                                      ),
                                                                    ],
                                                                  );
                                                          },
                                                        ))),
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
                                                    for (var i = 0;
                                                        i <
                                                            data[0]['list_chapter']
                                                                .length;
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
                                                                      data[0]['list_chapter'][i]
                                                                              [
                                                                              "chapter"]
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
                                                                      data[0]['list_chapter'][i]
                                                                              [
                                                                              "update"]
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
                                                              () => ReadingPage(
                                                                  chlist: data[0][
                                                                      'list_chapter'],
                                                                  indx: i,
                                                                  slug: data[0]['list_chapter'][i]["slug"]
                                                                      .toString(),
                                                                  postId: data[0][
                                                                      'post_id'],
                                                                  chName: data[0]['list_chapter'][i]["chapter"]
                                                                      .toString()
                                                                      .trimLeft(),
                                                                  chImg: data[0]['cover']
                                                                      .toString(),
                                                                  komikTitle: data[0]['title']
                                                                      .toString()
                                                                      .trimLeft(),
                                                                  link: data[0]['list_chapter'][i]
                                                                      ["link"]),
                                                              transition:
                                                                  Transition.fadeIn,
                                                              duration: const Duration(milliseconds: 700));
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
                                        SizedBox(
                                          width: double.infinity,
                                          child: FlatButton(
                                              onPressed: () {
                                                Get.to(
                                                    () => Disqus(
                                                          url: widget.url,
                                                          title: data[0]
                                                                  ['title']
                                                              .toString()
                                                              .trimLeft(),
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
              : Center(
                  child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                )),
        ));
  }
}
