import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrtappv2/Auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wrtappv2/Screen/bookmark/BmModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wrtappv2/Screen/homepage/scrapdata.dart';
import 'package:wrtappv2/Screen/menupage.dart';
import 'package:wrtappv2/const/function.dart';
import 'package:wrtappv2/const/tema.dart';
import 'Auth/sys/auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
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

  runApp(MyApp());
}

// stream connectivity
class MyApp extends StatelessWidget {
  final Auth put = Get.put(Auth());
  final Tema _tema = Get.put(Tema());
  final BmModel bm = Get.put(BmModel());
  final Konst konst = Get.put(Konst());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Auth at = Auth();

  MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var spls = Get.put(Init());
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
                            : Tema.pinkDarkTheme,
                home: (_auth.currentUser == null)
                    ? const LoginPage()
                    : const MenuPage(),
              ));
        }
      },
    );
  }
}

notifCek() async {
  var prefs = await SharedPreferences.getInstance();
  var konst = Get.put(Konst());
  var notif = prefs.getBool('notifStatus');
  if (notif == null) {
    konst.notifStatus.value = false;
    prefs.setBool('notifStatus', false);
  } else {
    konst.notifStatus.value = notif;
  }
}

class Init {
  RxBool isSplash = true.obs;
  Rx isConfig = "Loading Config".obs;

  Future initialize() async {
    var _konst = Get.find<Konst>();

    _konst.initPlatformState();
    _konst.blockOrientation();
    var status = Tema().getDark();
    if (status == 0) {
      Tema().mode.value = 0;
    } else if (status == 1) {
      Tema().mode.value = 1;
    } else if (status == 2) {
      Tema().mode.value = 2;
    } else if (status == 3) {
      Tema().mode.value = 3;
    }
    var home = Get.put(ScrapHome());

    isConfig.value = "Loading Config";
    await home.getData();

    _konst.validationDeviceID();
    _konst.cekUpdate();

    await home.getAllKomik(1);
    isConfig.value = "Loading Data";

    await notifCek();
    isConfig.value = "Finish";
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    var spls = Get.find<Init>();
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
