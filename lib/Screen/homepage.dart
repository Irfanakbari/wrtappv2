import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wrtappv2/Screen/Comment/chat.dart';
import 'package:wrtappv2/Screen/homepage/lastupdate.dart';
import 'package:wrtappv2/Screen/homepage/newkomik.dart';
import 'package:wrtappv2/Screen/homepage/popular.dart';
import 'package:wrtappv2/Screen/homepage/project.dart';
import 'package:wrtappv2/Screen/search/searchpage.dart';
import 'package:wrtappv2/const/function.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'homepage/scrapdata.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dataSrc = Get.find<ScrapHome>();
  var konst = Get.find<Konst>();
  var isLoading = false.obs;

// pj variable
  final project = [].obs;

// popular variable
  final popular = [].obs;

  // latest
  final latest = [].obs;

  getData() async {
    project.value = await dataSrc.pjUpdateKomik;
    popular.value = await dataSrc.popularKomik;
    latest.value = await dataSrc.latestKomik;
    isLoading.value = true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
    konst.getStatusServer();
    // konst.cekUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Get.to(() => const SearchPage(),
                    transition: Transition.downToUp,
                    duration: const Duration(milliseconds: 300));
              },
            ),
            IconButton(
              icon: const Icon(Icons.message_rounded),
              onPressed: () {
                Get.to(() => const Chatango(),
                    transition: Get.defaultTransition);
              },
            ),
          ],
          toolbarHeight: 70,
          title: SizedBox(
              width: 200,
              height: 60,
              child: Image.asset(
                'assets/img/logo.png',
                fit: BoxFit.contain,
              )),
        ),
        body: (isLoading.value)
            ? FadeIn(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeIn,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Popular(
                        data: popular,
                      ),
                      GestureDetector(
                        onTap: () async {
                          launch("https://trakteer.id/WorldRomanceTranslation");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: CachedNetworkImage(
                            cacheManager: CacheManager(Config(
                              "trakteer",
                              stalePeriod: const Duration(days: 7),
                            )),
                            imageUrl:
                                "https://cdn3.wrt.my.id/wrt.my.id/07/30/navbar-logo-lite-beta.png",
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.fill,
                            width: Get.width,
                          ),
                        ),
                      ),
                      Project(
                        data: project,
                      ),
                      LastUpdate(
                        data: latest,
                      ),
                      // NewerKomik(
                      //   title: _titleNK,
                      //   genre: _genreNK,
                      //   year: _yearNK,
                      //   image: _imageNK,
                      //   url: _urlNK,
                      // ),
                    ],
                  ),
                ),
              )
            : Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Theme.of(context).primaryColor, size: 60)),
      ),
    );
  }
}
