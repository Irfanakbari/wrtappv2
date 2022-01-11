import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrtappv2/Screen/detailpage.dart';

class Project extends StatelessWidget {
  final titlePj;
  final imagePj;
  final linkPj;
  final chaptersPj;
  const Project(
      {Key? key, this.titlePj, this.imagePj, this.linkPj, this.chaptersPj})
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
            const Text("Project WRT",
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
                childAspectRatio: (Get.width / Get.height) * 1.13,
                children: [
                  // card
                  for (int i = 0; i < titlePj.length + 0; i++)
                    GestureDetector(
                      onTap: () async {
                        Get.to(
                          () => DetailPage(url: linkPj[i]),
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
                                          cacheKey: imagePj[i],
                                          width: Get.width * 0.3,
                                          height: 165,
                                          cacheManager: CacheManager(Config(
                                            imagePj[i],
                                            stalePeriod:
                                                const Duration(hours: 2),
                                          )),
                                          placeholderFadeInDuration:
                                              const Duration(milliseconds: 500),
                                          imageUrl: imagePj[i],
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
                                          top: 0,
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
                                        titlePj[i],
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                      ),
                                      // small text
                                      const SizedBox(height: 5),
                                      // for each chapter
                                      for (int j = 0;
                                          j < chaptersPj[i].length;
                                          j++)
                                        Text(
                                          "• " + chaptersPj[i][j].toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
