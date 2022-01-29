import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wrtappv2/Screen/allgenres/viewgenre.dart';

class AllGenres extends StatefulWidget {
  const AllGenres({Key? key}) : super(key: key);

  @override
  State<AllGenres> createState() => _AllGenresState();
}

class _AllGenresState extends State<AllGenres> {
  RxList genres = [].obs;
  RxList urlGenre = [].obs;
  RxBool isLoading = true.obs;

  Future<void> scrapGenre() async {
    var url = 'https://api.wrt.my.id/api/genre';
    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    var genres = data['data'];
    var urlGenre = genres.map((e) => e['link']).toList();
    this.genres.value = genres.map((e) => e['genre']).toList();
    this.urlGenre.value = urlGenre;
  }

  @override
  void initState() {
    super.initState();
    scrapGenre().then((value) {
      isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Genre'),
          toolbarHeight: 70,
        ),
        body: FadeIn(
          duration: const Duration(milliseconds: 600),
          child: Obx(
            () => (isLoading.value)
                ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Theme.of(context).primaryColor, size: 60))
                : ListView.builder(
                    itemCount: genres.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Get.to(GenreResult(url: urlGenre[index]));
                          },
                          child: SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(genres[index],
                                    style: const TextStyle(fontSize: 20)),
                              )));
                    },
                  ),
          ),
        ));
  }
}
