import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/route_manager.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrtappv2/Screen/detailpage.dart';

class Popular extends StatelessWidget {
  final title;
  final url;
  final image;
  final skor;
  final chapters;
  final hot;
  const Popular(
      {Key? key,
      this.title,
      this.url,
      this.image,
      this.skor,
      this.chapters,
      this.hot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: Get.width,
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Popular Hari Ini",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            const Divider(
              height: 5,
            ),
            const SizedBox(height: 10),
            // gridview
            SizedBox(
              width: Get.width,
              child: GridView.count(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: (Get.width / Get.height) * 1.05,
                children: [
                  // card
                  for (int i = 0; i < 6; i++)
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => DetailPage(url: url[i]),
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
                                      Stack(children: [
                                        CachedNetworkImage(
                                          cacheKey: image[i],
                                          cacheManager: CacheManager(Config(
                                            image[i],
                                            stalePeriod:
                                                const Duration(hours: 2),
                                          )),
                                          height: 175,
                                          imageUrl: image[i],
                                          placeholder: (context, url) {
                                            // cupertino loader
                                            return const CupertinoActivityIndicator(
                                              radius: 10,
                                            );
                                          },
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        Positioned(
                                          top: 5,
                                          left: 5,
                                          child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: Image.asset(
                                                  'assets/img/manga.png')),
                                        ),
                                      ])
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
                                        title[i],
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                      ),
                                      // small text
                                      const SizedBox(height: 5),
                                      Text(
                                        chapters[i].toString(),
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
                                        value: double.parse(skor[i]) / 2.0,
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
          ]),
        ),
      ),
    );
  }
}
