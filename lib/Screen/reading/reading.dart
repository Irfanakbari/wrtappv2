import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrtappv2/Screen/Comment/disqus.dart';
import 'package:wrtappv2/Screen/homepage/scrapdata.dart';
import 'package:wrtappv2/const/function.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ReadingPage extends StatefulWidget {
  final String postId;
  final String slug;
  final String chName;
  final List chlist;
  final String link;
  final int indx;
  final String chImg;
  final String komikTitle;
  const ReadingPage({
    Key? key,
    required this.komikTitle,
    required this.postId,
    required this.chName,
    required this.chImg,
    required this.indx,
    required this.slug,
    required this.chlist,
    required this.link,
  }) : super(key: key);

  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  var imagesr = [];
  final _transformationController = TransformationController();
  final ScrollController _scrollController = ScrollController();
  late TapDownDetails _doubleTapDetails;
  var chapSlug = [];
  var judul = "no";
  var konst = Get.put<Konst>(Konst());
  var scrapData = Get.find<ScrapHome>();
  RxBool isLoading = true.obs;
  scrapingData() async {
    await scrapData.getReadKomik(widget.slug).then((value) {
      setState(() {
        if (value['data-min'] != null) {
          imagesr = value['data-high'];
        }
        isLoading.value = false;
      });
    });
  }

  setHistory() async {
    // save history to shared pref
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dateNow = DateTime.now();
    var data = [
      widget.komikTitle,
      widget.chName,
      widget.slug,
      widget.chImg,
      widget.postId,
      dateNow.toString()
    ];

    prefs.setStringList('history' + widget.postId, data);
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        // ..translate(-position.dx * 2, -position.dy * 2)
        // ..scale(3.0);
        // Fox a 2x zoom
        ..translate(-position.dx, -position.dy)
        ..scale(2.0);
    }
  }

  @override
  void initState() {
    super.initState();
    scrapingData();
    setHistory();
  }

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    // text center
    return Scaffold(
      body:
          // pull to refresh
          Obx(
        () => (isLoading.value)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : InteractiveViewer(
                transformationController: _transformationController,
                maxScale: 2.5,
                scaleEnabled: true,
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: const ClassicHeader(),
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 1));
                    setState(() {
                      imagesr = [];
                      isLoading.value = true;
                      scrapingData();
                      _refreshController.refreshCompleted();
                    });
                  },
                  controller: _refreshController,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: imagesr.length,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          // image
                          GestureDetector(
                            onDoubleTap: _handleDoubleTap,
                            onDoubleTapDown: _handleDoubleTapDown,
                            onTap: () => modalBottom(widget.chImg),
                            child: CachedNetworkImage(
                              cacheKey: imagesr[index],
                              httpHeaders: const {
                                'Referer': 'https://wrt.my.id',
                              },
                              imageUrl: imagesr[index] +
                                  '?quality=' +
                                  konst.readQuality.value,
                              cacheManager: CacheManager(Config(
                                imagesr[index],
                                stalePeriod: const Duration(hours: 1),
                              )),
                              width: Get.width,
                              useOldImageOnUrlChange: true,
                              fadeOutDuration:
                                  const Duration(milliseconds: 500),
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => SizedBox(
                                height: 300,
                                width: Get.width,
                                child: const Center(
                                  child: Icon(
                                    Icons.error,
                                    size: 50,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  height: 300,
                                  width: Get.width,
                                  child: Center(
                                      child:
                                          LoadingAnimationWidget.discreteCircle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 30)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }

  modalBottom(String gbr) {
    Map<String, String> header = {"referer": "https://wrt.my.id"};

    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.warning),
                        onPressed: () {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Warning'),
                              content: const Text('Lapor Gambar Rusak?'),
                              actions: [
                                FlatButton(
                                  child: const Text('Tidak'),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                FlatButton(
                                  child: const Text('Ya'),
                                  onPressed: () {
                                    konst.sendChapterReport(widget.link);
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                    IconButton(
                        icon: const Icon(Icons.message),
                        onPressed: () {
                          Get.to(
                              () => Disqus(
                                    url: widget.link,
                                    title: judul,
                                  ),
                              transition: Transition.downToUp);
                        }),
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 80,
                            child: CachedNetworkImage(
                                imageUrl: gbr + '?resize=100,145',
                                httpHeaders: header,
                                fit: BoxFit.fill,
                                height: 100,
                                width: 150),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 250,
                              child: Text(
                                widget.komikTitle,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(widget.chName,
                                style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (widget.indx != widget.chlist.length - 1)
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () async {
                              Get.back();
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => ReadingPage(
                                            komikTitle: widget.komikTitle,
                                            postId: widget.postId,
                                            chName:
                                                widget.chlist[widget.indx + 1]
                                                    ['chapter'],
                                            chImg: widget.chImg,
                                            indx: widget.indx + 1,
                                            chlist: widget.chlist,
                                            link: widget.chlist[widget.indx + 1]
                                                ['link'],
                                            slug: widget.chlist[widget.indx + 1]
                                                ['slug'],
                                          )));
                            })
                        : const SizedBox(),
                    (widget.indx != 0)
                        ? IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () async {
                              Get.back();
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => ReadingPage(
                                            komikTitle: widget.komikTitle,
                                            postId: widget.postId,
                                            chName:
                                                widget.chlist[widget.indx - 1]
                                                    ['chapter'],
                                            chImg: widget.chImg,
                                            indx: widget.indx - 1,
                                            chlist: widget.chlist,
                                            link: widget.chlist[widget.indx - 1]
                                                ['link'],
                                            slug: widget.chlist[widget.indx - 1]
                                                ['slug'],
                                          )));
                            })
                        : const SizedBox(
                            height: 0,
                          )
                  ],
                )
              ],
            ),
          );
        });
  }
}
