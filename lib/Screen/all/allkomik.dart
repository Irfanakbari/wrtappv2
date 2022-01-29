import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  RxList datas = [].obs;
  var index = 1;
  var loaderB = true.obs;

  getData() async {
    datas.value = dataSrc.dataAllKomik;
    isLoading.value = true;
  }

  @override
  void initState() {
    super.initState();
    getData();
    index = 1;
  }

  @override
  void dispose() {
    super.dispose();
    // dataSrc;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: const Text("Daftar Komik"),
          actions: [
            // InkWell(
            //   onTap: () {},
            //   child: Padding(
            //       padding: const EdgeInsets.only(right: 10),
            //       child: Center(
            //         child: Text(
            //           "Text Mode",
            //           style: GoogleFonts.roboto(
            //             textStyle: const TextStyle(
            //               fontSize: 14,
            //               color: Colors.red,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //       )),
            // )
          ],
        ),
        body: (datas.isNotEmpty)
            ? LazyLoadScrollView(
                // scrollOffset: 200,
                onEndOfPage: () {
                  // show loader bottom
                  index++;
                  dataSrc.getAllKomik(index).then((value) {
                    datas.value = value;
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
                    for (int i = 0; i < datas.length; i++)
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            DetailPage(
                              slug: datas[i]['slug'],
                              url: datas[i]['link'],
                            ),
                          );
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
                                          imageUrl: datas[i]['cover'],
                                          placeholder: (context, url) {
                                            // cupertino loader
                                            return const CupertinoActivityIndicator(
                                              radius: 10,
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
                                          datas[i]['title'].toString(),
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                        ),

                                        // small text
                                        const SizedBox(height: 5),
                                        Text(
                                          datas[i]['last_chapter'].toString(),
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
                                              double.parse(datas[i]['skor']) /
                                                  2.0,
                                          onChanged: (value) {},
                                        ),
                                        const SizedBox(height: 7),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // loader bottom
                            ],
                          ),
                        ),
                      ),

                    // card
                  ],
                ),
              )
            : Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Theme.of(context).primaryColor, size: 60),
              ),
      ),
    );
  }
}
