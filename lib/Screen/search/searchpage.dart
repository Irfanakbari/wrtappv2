import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:wrtappv2/Screen/detailpage.dart';

import '../homepage/scrapdata.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var dataSrc = Get.find<ScrapHome>();
  var isLoading = false.obs;
  var index = 1;
  RxInt max = 1.obs;
  RxList data = [].obs;

  getData(String keyword) async {
    await dataSrc.searchKomik(keyword, index).then((value) {
      data.value = value[0];
      max.value = value[1];
    }).then((value) {
      isLoading.value = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = 1;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dataSrc;
  }

  @override
  Widget build(BuildContext context) {
    // text controller
    TextEditingController controller = TextEditingController();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          // search field
          title: TextField(
              textInputAction: TextInputAction.search,
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Cari apa ya?",
                border: InputBorder.none,
              ),
              onSubmitted: (context) {
                index = 1;
                max.value = 1;
                // clear variable
                data.clear();

                getData(controller.text);
              }),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                index = 1;
                max.value = 1;
                // clear variable
                data.clear();

                getData(controller.text);
              },
            ),
          ],
        ),
        body: (data.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: LazyLoadScrollView(
                  isLoading: false,
                  scrollOffset: 200,
                  onEndOfPage: () {
                    index++;
                    if (index <= max.value) {
                      dataSrc.searchKomik(controller.text, index).then((value) {
                        data.addAll(value[0]);
                      });
                    }
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
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 600));
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
                                            data[i]['last_chapter'].toString(),
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
                                                double.parse(data[i]['skor']) /
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
      ),
    );
  }
}
