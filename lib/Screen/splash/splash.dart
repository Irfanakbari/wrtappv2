import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wrtappv2/controller/splash_controller.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    var spls = Get.find<SplashC>();
    return Scaffold(
      body: AnimatedContainer(
        width: Get.width,
        height: Get.height,
        color: const Color.fromRGBO(22, 21, 29, 1),
        duration: const Duration(milliseconds: 1000),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/img/logo.png',
                width: Get.width / 2,
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Center(
                child: Text(
                  spls.isConfig.value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white, size: 40)
          ],
        ),
      ),
    );
  }
}
