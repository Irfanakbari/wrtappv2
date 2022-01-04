import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrtappv2/Screen/detailpage.dart';
import 'package:google_fonts/google_fonts.dart';

class LastUpdate extends StatelessWidget {
  final titleLU;
  final imageLU;
  final linkLU;
  final chaptersLU;
  final timeLU;
  const LastUpdate(
      {Key? key,
      this.titleLU,
      this.imageLU,
      this.linkLU,
      this.chaptersLU,
      this.timeLU})
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
            const Text("Update Terbaru",
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
            Container(
              width: Get.width,
              child: GridView.count(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: (Get.width / Get.height) * 1.14,
                children: [
                  // sizebox size relative
                  // card
                  for (int i = 0; i < titleLU.length + 0; i++)
                    GestureDetector(
                      onTap: () {
                        Get.to(DetailPage(url: linkLU[i]),
                            transition: Transition.fadeIn,
                            duration: const Duration(milliseconds: 700));
                      },
                      // sizebox size relative to parent
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
                                        width: Get.width * 0.3,
                                        height: 165,
                                        imageUrl: imageLU[i],
                                        placeholderFadeInDuration:
                                            const Duration(milliseconds: 500),
                                        fit: BoxFit.fill,
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
                                        titleLU[i].toString(),
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                      ),
                                      // small text
                                      const SizedBox(height: 2),
                                      // for each chapter

                                      Text(
                                        chaptersLU[i]
                                            .toString()
                                            .replaceAll("Ch.", "Chapter"),
                                        style: GoogleFonts.roboto(
                                          wordSpacing: 1,
                                          letterSpacing: 1,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        timeLU[i].toString(),
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
