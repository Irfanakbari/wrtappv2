// ignore_for_file: unnecessary_const

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrtappv2/Screen/bookmark/BmModel.dart';
import 'package:wrtappv2/Screen/detailpage.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  var bm = Get.find<BmModel>();
  RxList dataList = [].obs;
  Map<String, String> header = {"referer": "https://wrt.my.id"};
  Rx legt = 0.obs;
  RxBool isLoading = true.obs;

  getBookmark() async {
    var data = await bm.getAllBookmark();
    if (data != null) {
      dataList.value = data;
      legt.value = data.length;
      isLoading.value = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBookmark();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: const Text("Bookmark"),
        ),
        body: (!isLoading.value)
            ? (legt.value != 0)
                ? Center(
                    child: Container(
                        height: Get.height,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Wrap(
                                  children: [
                                    Container(
                                      width: Get.width,
                                      margin: const EdgeInsets.all(10),
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(4),
                                            bottomRight: Radius.circular(4),
                                            topLeft: Radius.circular(4),
                                            topRight: Radius.circular(4)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 4,
                                            blurRadius: 5,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Bookmark Disimpan di Perangkat Anda, Jangan Hapus Data Aplikasi, Untuk Menghapus Bookmark Tekan Dan Tahan Komik",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // gridview
                                    Container(
                                      width: Get.width,
                                      margin: const EdgeInsets.all(10),
                                      height: Get.height / 1.5,
                                      child: GridView.count(
                                        physics: BouncingScrollPhysics(),
                                        crossAxisCount: 3,
                                        childAspectRatio:
                                            (Get.width / Get.height) / 0.8,
                                        children: <Widget>[
                                          for (int i = 0; i < legt.value; i++)
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(DetailPage(
                                                    url: dataList[i]['url']));
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Card(
                                                    color: Colors.transparent,
                                                    elevation: 5,
                                                    child: Column(
                                                      children: [
                                                        CachedNetworkImage(
                                                          width:
                                                              Get.width * 0.3,
                                                          height: 175,
                                                          placeholderFadeInDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500),
                                                          imageUrl: dataList[i]
                                                              ['image'],
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            color: Colors.grey,
                                                            child: const Center(
                                                              child: CupertinoActivityIndicator
                                                                  .partiallyRevealed(),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    dataList[i]['title'],
                                                    style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                  // small text
                                                  const SizedBox(height: 5),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )))
                : Center(
                    child: Text("No Bookmark",
                        style: GoogleFonts.chakraPetch(
                            textStyle: const TextStyle(fontSize: 20))),
                  )
            : const Center(
                child: const Text('Loading...'),
              ),
      ),
    );
  }
}
