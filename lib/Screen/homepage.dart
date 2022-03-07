import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wrtappv2/ErrorPage/closeapp.dart';
import 'package:wrtappv2/Screen/Comment/chat.dart';
import 'package:wrtappv2/Screen/carousel.dart';
import 'package:wrtappv2/Screen/homepage/lastupdate.dart';
import 'package:wrtappv2/Screen/homepage/popular.dart';
import 'package:wrtappv2/Screen/homepage/project.dart';
import 'package:wrtappv2/Screen/search/searchpage.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrtappv2/controller/splash_controller.dart';
import 'detailpage.dart';
import 'homepage/scrapdata.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dataSrc = Get.find<ScrapHome>();
  var isLoading = false.obs;
  var splashC = Get.find<SplashC>();

// pj variable
  final project = [].obs;

// popular variable
  final popular = [].obs;

  // latest
  final latest = [].obs;

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    Get.to(
      () => DetailPage(
        slug: message.data['slug'].toString().split('-chapter-')[0],
        url: message.data['url'],
      ),
      transition: Transition.fadeIn,
    );
  }

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
    setupInteractedMessage();

    getData();
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
                      const SizedBox(
                        height: 12,
                      ),
                      const CarouselWithIndicatorDemo(),
                      (splashC.linkGambar2.value == "")
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(5),
                              child: CachedNetworkImage(
                                cacheManager: CacheManager(Config(
                                  splashC.linkGambar.value,
                                  stalePeriod: const Duration(days: 7),
                                )),
                                imageUrl: splashC.linkGambar.value,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.fill,
                                width: Get.width,
                              ),
                            ),
                      Popular(
                        data: popular,
                      ),
                      (splashC.linkGambar.value == "")
                          ? Container()
                          : GestureDetector(
                              onTap: () async {
                                launch(
                                    "https://trakteer.id/WorldRomanceTranslation");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: CachedNetworkImage(
                                  cacheManager: CacheManager(Config(
                                    splashC.linkGambar.value,
                                    stalePeriod: const Duration(days: 7),
                                  )),
                                  imageUrl: splashC.linkGambar.value,
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
