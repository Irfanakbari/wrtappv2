import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:google_fonts/google_fonts.dart';
import '../detailpage.dart';
import '../homepage/scrapdata.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class AllKomik extends StatefulWidget {
  const AllKomik({Key? key}) : super(key: key);

  @override
  _AllKomikState createState() => _AllKomikState();
}

class _AllKomikState extends State<AllKomik> {
  var isLoading = false.obs;
  var dataSrc = Get.find<ScrapHome>();
  var _titleAll = [].obs;
  var index = 1;
  var _chaptersAll = [].obs;
  var _chaptersUrlAll = [].obs;
  var _imageAll = [].obs;
  var _skorAll = [].obs;

  getData() async {
    await dataSrc.getAllKomik(1).then((value) {
      _titleAll.value = dataSrc.titleAll;
      _chaptersAll.value = dataSrc.chaptersAll;
      _imageAll.value = dataSrc.imageAll;
      _skorAll.value = dataSrc.skorAll;
      _chaptersUrlAll.value = dataSrc.chaptersUrlAll;
    }).then((value) {
      isLoading.value = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dataSrc;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: const Text("Daftar Komik"),
        ),
        body: (isLoading.value)
            ? LazyLoadScrollView(
                isLoading: false,
                scrollOffset: 200,
                onEndOfPage: () {
                  index++;
                  dataSrc.getAllKomik(index).then((value) {
                    _titleAll.value = dataSrc.titleAll;
                    // _chaptersAll.value = dataSrc.chaptersAll;
                    _imageAll.value = dataSrc.imageAll;
                    _skorAll.value = dataSrc.skorAll;
                    _chaptersUrlAll.value = dataSrc.chaptersUrlAll;
                  });
                },
                child:
                    //  grid view
                    GridView.count(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 3,
                  childAspectRatio: (Get.width / Get.height) * 1.1,
                  children: [
                    // card
                    for (int i = 0; i < _titleAll.length; i++)
                      GestureDetector(
                        onTap: () {
                          Get.to(DetailPage(url: _chaptersUrlAll[i]),
                              transition: Transition.fadeIn,
                              duration: const Duration(milliseconds: 700));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Column(
                                      children: [
                                        CachedNetworkImage(
                                          // width: 225,
                                          height: 175,
                                          imageUrl: _imageAll[i],
                                          placeholder: (context, url) {
                                            // cupertino loader
                                            return Container(
                                              child:
                                                  const CupertinoActivityIndicator(
                                                radius: 10,
                                              ),
                                            );
                                          },
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 2),
                                        Text(
                                          _titleAll[i].toString(),
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                        ),

                                        // small text
                                        const SizedBox(height: 5),
                                        Text(
                                          _chaptersAll[i].toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        GFRating(
                                          color: Colors.red,
                                          borderColor: Colors.red,
                                          size: 18,
                                          allowHalfRating: true,
                                          value:
                                              double.parse(_skorAll[i]) / 2.0,
                                          onChanged: (value) {},
                                        ),
                                        const SizedBox(height: 7),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    // card
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
