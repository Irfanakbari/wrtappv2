import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:wrtappv2/Screen/homepage/scrapdata.dart';

import '../detailpage.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  var dataSrc = Get.find<ScrapHome>();
  var isLoading = true.obs;
  var index = 1;
  RxInt max = 1.obs;
  RxList data = [].obs;

  getData() async {
    dataSrc.getProject(index).then((value) {
      if (value.isNotEmpty) {
        data.addAll(value[0]);
        max.value = value[1];
        isLoading.value = false;
      }
    });
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
            title: const Text('Project List'),
          ),
          body: (!isLoading.value)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LazyLoadScrollView(
                    isLoading: false,
                    scrollOffset: 200,
                    onEndOfPage: () {
                      index++;
                      if (index <= max.value) {
                        dataSrc.getProject(index).then((value) {
                          if (value.isNotEmpty) {
                            data.addAll(value[0]);
                            max.value = value[1];
                          }
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
                                              fadeInCurve: Curves.easeIn,
                                              fadeInDuration: const Duration(
                                                  milliseconds: 500),
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
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            const SizedBox(height: 5),
                                            GFRating(
                                              color: Colors.red,
                                              borderColor: Colors.red,
                                              size: 18,
                                              allowHalfRating: true,
                                              value: 8 / 2.0,
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
              : Center(
                  child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                )),
        ));
  }
}
