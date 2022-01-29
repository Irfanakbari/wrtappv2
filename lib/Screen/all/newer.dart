import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:wrtappv2/Screen/homepage/scrapdata.dart';

import '../detailpage.dart';

class NewerList extends StatefulWidget {
  const NewerList({Key? key}) : super(key: key);

  @override
  _NewerListState createState() => _NewerListState();
}

class _NewerListState extends State<NewerList> {
  var dataSrc = Get.find<ScrapHome>();
  var isLoading = false.obs;
  var index = 1;
  RxList data = [].obs;

  getData() async {
    await dataSrc
        .getNewList(index)
        .then((value) => data.addAll(value))
        .then((value) => isLoading.value = false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: const Text('Update Terbaru'),
          ),
          body: (data.isNotEmpty)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LazyLoadScrollView(
                    isLoading: false,
                    scrollOffset: 200,
                    onEndOfPage: () {
                      index++;
                      dataSrc.getNewList(index).then((value) {
                        data.addAll(value);
                      });
                    },
                    child:
                        //  grid view
                        GridView.count(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: (Get.width / Get.height) * 1.05,
                      children: [
                        // card
                        for (int i = 0; i < data.length; i++)
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                  () => DetailPage(
                                        slug: data[i]['slug'],
                                        url: data[i]['link'],
                                      ),
                                  transition: Transition.fadeIn);
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
                                              imageUrl: data[i]['cover'],
                                              placeholder: (context, url) {
                                                // cupertino loader
                                                return const CupertinoActivityIndicator(
                                                  radius: 10,
                                                );
                                              },
                                              errorWidget:
                                                  (context, url, error) =>
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
                                              data[i]['title'].toString(),
                                              style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                            ),

                                            // small text
                                            const SizedBox(height: 5),
                                            Text(
                                              data[i]['last_chapter']
                                                  .toString(),
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
                                              value: double.parse(
                                                      data[i]['skor']) /
                                                  2.0,
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
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
