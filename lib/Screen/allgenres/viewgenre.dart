import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrtappv2/Screen/homepage/scrapdata.dart';

import '../detailpage.dart';

class GenreResult extends StatefulWidget {
  final String url;
  const GenreResult({Key? key, required this.url}) : super(key: key);

  @override
  _GenreResultState createState() => _GenreResultState();
}

class _GenreResultState extends State<GenreResult> {
  var fungsi = Get.find<ScrapHome>();
  final _titleG = [].obs;
  final _chaptersG = [].obs;
  final _chapters_urlG = [].obs;
  final _imageG = [].obs;
  RxBool isLoading = true.obs;
  final _skorG = [].obs;

  getData() async {
    fungsi.titleG.clear();
    fungsi.chaptersG.clear();
    fungsi.chaptersUrlG.clear();
    fungsi.imageG.clear();
    fungsi.skorG.clear();

    await fungsi.genreResult(widget.url).then((value) {
      _titleG.value = fungsi.titleG;
      _chaptersG.value = fungsi.chaptersG;
      _chapters_urlG.value = fungsi.chaptersUrlG;
      _imageG.value = fungsi.imageG;
      _skorG.value = fungsi.skorG;
    }).then((value) => isLoading.value = false);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Genre Result'),
          toolbarHeight: 70,
        ),
        body: Obx(() => (isLoading.value)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: (Get.width / Get.height) * 1.05,
                    children: [
                      for (int i = 0; i < _titleG.length; i++)
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => DetailPage(url: _chapters_urlG[i]),
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
                                          Image.network(
                                            _imageG[i],
                                            fit: BoxFit.cover,
                                          ),
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
                                            _titleG[i].toString(),
                                            style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                          ),

                                          // small text
                                          const SizedBox(height: 5),
                                          Text(
                                            _chaptersG[i].toString(),
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
                                                double.parse(_skorG[i]) / 2.0,
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
                    ]))));
  }
}
