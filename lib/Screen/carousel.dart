import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_carousel_widget/flutter_carousel_options.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:wrtappv2/controller/carousel_controller.dart';

import 'detailpage.dart';

class CarouselWithIndicatorDemo extends StatelessWidget {
  const CarouselWithIndicatorDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxInt _current = 0.obs;
    double _sigmaX = 0.5; // from 0-10
    double _sigmaY = 0.5; // from 0-10
    double _opacity = 0.1; // from 0-1.0

    final CarouselController _controller = CarouselController();
    var carouselC = Get.find<CarouselC>();
    return SizedBox(
      child: Column(
        children: [
          Obx(
            () => FlutterCarousel(
              items: carouselC.imgList
                  .map((item) => GestureDetector(
                        onTap: () {
                          Get.to(
                            () => DetailPage(
                              slug: carouselC.slug[_current.value],
                              url: carouselC.link[_current.value],
                            ),
                            transition: Transition.fadeIn,
                          );
                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0)),
                                child: CachedNetworkImage(
                                  fadeInCurve: Curves.easeIn,
                                  fadeInDuration:
                                      const Duration(milliseconds: 500),
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(Icons.error),
                                  ),
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  imageUrl: item,
                                ),
                              ),
                            ),
                            BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: _sigmaX, sigmaY: _sigmaY),
                              child: Container(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(_opacity),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(200, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 20.0,
                                ),
                                child: Text(
                                  carouselC.title[_current.value],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              carouselController: _controller,
              options: CarouselOptions(
                  height: 150,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  viewportFraction: 1.0,
                  showIndicator: false,
                  // slideIndicator: const CircularSlideIndicator(
                  //   currentIndicatorColor: Colors.pinkAccent,
                  // ),
                  onPageChanged: (index, reason) {
                    _current.value = index;
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
