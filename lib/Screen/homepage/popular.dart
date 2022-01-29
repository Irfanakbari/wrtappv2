import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/route_manager.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrtappv2/Screen/detailpage.dart';

class Popular extends StatelessWidget {
  final List data;
  const Popular({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: Get.width,
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
            top: 10,
            bottom: 8,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Populer Hari Ini",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                // all button
              ],
            ),
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
                  for (int i = 0; i < data.length; i++)
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => DetailPage(
                            slug: data[i]["slug"],
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
                            Card(
                              shadowColor: Colors.black.withOpacity(0.5),
                              color: Colors.transparent,
                              elevation: 8,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Column(
                                      children: [
                                        Stack(children: [
                                          CachedNetworkImage(
                                            height: 165,
                                            fadeInCurve: Curves.easeIn,
                                            fadeInDuration: const Duration(
                                                milliseconds: 500),
                                            cacheKey: data[i]["img"],
                                            cacheManager: CacheManager(Config(
                                              data[i]["img"],
                                              stalePeriod:
                                                  const Duration(hours: 2),
                                            )),
                                            imageUrl: data[i]["img"],
                                            placeholder: (context, url) {
                                              // cupertino loader
                                              return const Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                                  radius: 10,
                                                ),
                                              );
                                            },
                                            errorWidget:
                                                (context, url, error) =>
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
                                          (data[i]['hot'])
                                              ? Positioned(
                                                  bottom: 5,
                                                  right: 5,
                                                  child: SizedBox(
                                                      width: 25,
                                                      height: 25,
                                                      child: Image.asset(
                                                          'assets/img/hot1.png')),
                                                )
                                              : Container(),
                                        ])
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                                        data[i]["title"],
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                      ),
                                      // small text
                                      const SizedBox(height: 5),
                                      Text(
                                        data[i]["last_chapter"],
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
                                            double.parse(data[i]['skor']) / 2.0,
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
                    ), // card
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
