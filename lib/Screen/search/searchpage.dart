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
  var _titleS = [].obs;
  var index = 1;
  var _chaptersS = [].obs;
  var _chaptersUrlS = [].obs;
  var _imageS = [].obs;
  var _skorS = [].obs;

  getData(String keyword) async {
    await dataSrc.searchKomik(keyword, index).then((value) {
      _titleS.value = dataSrc.titleS;
      _chaptersS.value = dataSrc.chaptersS;
      _chaptersUrlS.value = dataSrc.chaptersUrlS;
      _imageS.value = dataSrc.imageS;
      _skorS.value = dataSrc.skorS;
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
                // clear variable
                _titleS.value = [];
                _chaptersS.value = [];
                _chaptersUrlS.value = [];
                _imageS.value = [];
                _skorS.value = [];
                dataSrc.setTitleS = [];
                dataSrc.setChaptersS = [];
                dataSrc.setChaptersUrlS = [];
                dataSrc.setImageS = [];
                dataSrc.setSkorS = [];

                getData(controller.text);
              }),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                index = 1;
                // clear variable
                _titleS.value = [];
                _chaptersS.value = [];
                _chaptersUrlS.value = [];
                _imageS.value = [];
                _skorS.value = [];
                dataSrc.setTitleS = [];
                dataSrc.setChaptersS = [];
                dataSrc.setChaptersUrlS = [];
                dataSrc.setImageS = [];
                dataSrc.setSkorS = [];

                getData(controller.text);
              },
            ),
          ],
        ),
        body: (_titleS.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: LazyLoadScrollView(
                  isLoading: false,
                  scrollOffset: 200,
                  onEndOfPage: () {
                    index++;
                    dataSrc.searchKomik(controller.text, index).then((value) {
                      _titleS.value = dataSrc.titleS;
                      _chaptersS.value = dataSrc.chaptersS;
                      _chaptersUrlS.value = dataSrc.chaptersUrlS;
                      _imageS.value = dataSrc.imageS;
                      _skorS.value = dataSrc.skorS;
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
                      for (int i = 0; i < _titleS.length; i++)
                        GestureDetector(
                          onTap: () {
                            Get.to(() => DetailPage(url: _chaptersUrlS[i]),
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
                                            imageUrl: _imageS[i],
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
                                            _titleS[i].toString(),
                                            style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                          ),

                                          // small text
                                          const SizedBox(height: 5),
                                          Text(
                                            _chaptersS[i].toString(),
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
                                                double.parse(_skorS[i]) / 2.0,
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
