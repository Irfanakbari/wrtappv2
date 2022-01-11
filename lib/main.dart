import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrtappv2/Auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wrtappv2/Screen/bookmark/BmModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wrtappv2/Screen/homepage/scrapdata.dart';
import 'package:wrtappv2/Screen/menupage.dart';
import 'package:wrtappv2/const/abstract.dart';
import 'package:wrtappv2/const/tema.dart';
import 'Auth/sys/auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity/connectivity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  var _konst = Get.put(Konst());
  _konst.initPlatformState();
  _konst.blockOrientation();
  var status = await Tema().getDark();
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
  await home.getData();
  await home.getAllKomik(1);
  notifCek();

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
  final Konst konst = Get.find<Konst>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Auth at = Auth();

  MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'World Romance Translation',
        theme: (_tema.mode.value == 0)
            ? Tema.lightTheme
            : (_tema.mode.value == 1)
                ? Tema.darkTheme
                : (_tema.mode.value == 2)
                    ? Tema.pinkTheme
                    : Tema.pinkDarkTheme,
        home:
            (_auth.currentUser == null) ? const LoginPage() : const MenuPage(),
      ),
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
