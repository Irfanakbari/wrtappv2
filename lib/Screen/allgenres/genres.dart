import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:wrtappv2/Screen/allgenres/viewgenre.dart';

class AllGenres extends StatefulWidget {
  const AllGenres({Key? key}) : super(key: key);

  @override
  State<AllGenres> createState() => _AllGenresState();
}

class _AllGenresState extends State<AllGenres> {
  RxList<String> genres = <String>[].obs;
  RxList<String> urlGenre = <String>[].obs;
  RxBool isLoading = true.obs;

  Future<void> scrapGenre() async {
    var url = 'https://wrt.my.id';
    var response = await http.get(Uri.parse(url));
    var document = parser.parse(response.body);
    var genres =
        document.getElementsByClassName('genre')[0].getElementsByTagName('li');
    for (var i = 0; i < genres.length; i++) {
      var genre = genres[i].getElementsByTagName('a')[0].text;
      var genreUrl = genres[i].getElementsByTagName('a')[0].attributes['href'];
      this.genres.add(genre);
      urlGenre.add(genreUrl!);
    }
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
        body: Obx(
          () => (isLoading.value)
              ? const Center(child: CircularProgressIndicator())
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
        ));
  }
}
