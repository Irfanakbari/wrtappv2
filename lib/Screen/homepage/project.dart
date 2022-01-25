import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrtappv2/Screen/all/project.dart';
import 'package:wrtappv2/Screen/detailpage.dart';

class Project extends StatelessWidget {
  final List data;
  const Project({Key? key, required this.data}) : super(key: key);

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
            top: 4,
            bottom: 20,
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Project Update",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                // all button
                Row(
                  children: [
                    FlatButton(
                      onPressed: () {
                        Get.to(() => const ProjectList(),
                            transition: Transition.downToUp);
                      },
                      child: const Text(
                        "Lihat Semua",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 13,
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              height: 5,
              color: Colors.grey,
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
                  for (int i = 0; i < data.length + 0; i++)
                    GestureDetector(
                      onTap: () async {
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
                                            cacheKey: data[i]["img"],
                                            height: 165,
                                            fadeInCurve: Curves.easeIn,
                                            fadeInDuration: const Duration(
                                                milliseconds: 500),
                                            cacheManager: CacheManager(Config(
                                              data[i]["img"],
                                              stalePeriod:
                                                  const Duration(hours: 2),
                                            )),
                                            placeholderFadeInDuration:
                                                const Duration(
                                                    milliseconds: 500),
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
                                            top: 0,
                                            left: 5,
                                            child: SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: Image.asset(
                                                    'assets/img/manga.png')),
                                          ),
                                          (data[i]['hot'])
                                              ? Positioned(
                                                  bottom: 6,
                                                  right: 5,
                                                  child: SizedBox(
                                                      width: 25,
                                                      height: 30,
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
                                      // for each chapter

                                      Text(
                                        data[i]["last_chapter"],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        data[i]["last_update"],
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 192, 191, 191),
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic),
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
