import 'package:flutter/material.dart';
import 'package:wrtappv2/Auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wrtappv2/Screen/bookmark/BmModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wrtappv2/Screen/menupage.dart';
import 'package:wrtappv2/const/tema.dart';
import 'package:wrtappv2/controller/auth_controller.dart';
import 'package:wrtappv2/controller/carousel_controller.dart';
import 'package:wrtappv2/controller/splash_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_database/firebase_database.dart';
import 'ErrorPage/closeapp.dart';
import 'Screen/detailpage.dart';
import 'Screen/splash/splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance;
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Get.snackbar(
      "New Update",
      message.data["dialog_title"],
      // backgroundColor: Colors.blue,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
      onTap: (GetSnackBar snackBar) {
        Get.to(
          () => DetailPage(
            slug: message.data['slug'].toString().split('-chapter-')[0],
            url: message.data['url'],
          ),
          transition: Transition.fadeIn,
        );
      },
    );
  });

  await dotenv.load(fileName: ".env");
  // FirebaseMessaging.instance.subscribeToTopic('all');
  await Hive.initFlutter();

  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      Get.snackbar(
          'No Internet Connection', 'Please check your internet connection',
          snackPosition: SnackPosition.TOP,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderWidth: 1,
          duration: const Duration(seconds: 5));
    }
  });
  DatabaseReference starCountRef =
      FirebaseDatabase.instance.ref('server/status');
  starCountRef.onValue.listen((DatabaseEvent event) {
    final status = event.snapshot.value;
    if (status == "off") {
      Get.offAll(const CloseApp(
          message: "Aplikasi Ditutup Sementara, sedang ada perbaikan server"));
    } else {
      runApp(MyApp());
    }
  });

  runApp(MyApp());
}

// stream connectivity
class MyApp extends StatelessWidget {
  final AuthC authC = Get.put(AuthC());
  final Tema _tema = Get.put(Tema());
  final BmModel bm = Get.put(BmModel());
  final carouselC = Get.put(CarouselC());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var spls = Get.put(SplashC());
    return FutureBuilder(
      future: spls.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Splash(),
          );
        } else {
          return Obx(() => GetMaterialApp(
                title: 'World Romance Translation',
                theme: (_tema.mode.value == 0)
                    ? Tema.lightTheme
                    : (_tema.mode.value == 1)
                        ? Tema.darkTheme
                        : (_tema.mode.value == 2)
                            ? Tema.pinkTheme
                            : (_tema.mode.value == 3)
                                ? Tema.pinkDarkTheme
                                : (_tema.mode.value == 4)
                                    ? Tema.greenTheme
                                    : Tema.greenDarkTheme,
                home: (_auth.currentUser == null)
                    ? const LoginPage()
                    : const MenuPage(),
              ));
        }
      },
    );
  }
}
