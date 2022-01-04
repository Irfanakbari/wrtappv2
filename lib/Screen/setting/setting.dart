// ignore_for_file: unnecessary_const
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrtappv2/Auth/sys/auth.dart';
import 'package:wrtappv2/Screen/bookmark/BmModel.dart';
import 'package:wrtappv2/Screen/reading/sys/ModelRestore.dart';
import 'package:wrtappv2/const/abstract.dart';
import 'package:flutter/cupertino.dart';
import '../../Auth/login.dart';
import '../../const/tema.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth _auth = Get.find<Auth>();
    var _tema = Get.find<Tema>();
    var _konst = Get.find<Konst>();
    var dark = false.obs;
    var cons = Get.find<Tema>();
    Map<String, String> header = {"referer": "https://wrt.my.id"};
    final FirebaseAuth _user = FirebaseAuth.instance;

    // scroll controller

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text("Pengaturan"),
          toolbarHeight: 70,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Akun",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const Divider(
                  color: Colors.grey,
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 5),
                  child: Container(
                    width: Get.width,
                    decoration: const BoxDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          (_user.currentUser!.photoURL != null)
                              ? Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(_user
                                          .currentUser!.photoURL
                                          .toString()),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          'https://cdn3.wrt.my.id/wrt.my.id/08/12/PinClipart.com_male-clipart_1332472.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    color: Colors.grey,
                                  ),
                                ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // google font
                              Text(
                                // first word capital
                                _user.currentUser!.displayName
                                    .toString()
                                    .split(" ")
                                    .map((e) =>
                                        e[0].toUpperCase() + e.substring(1))
                                    .join(" "),

                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                _user.currentUser!.email.toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Text(
                  "Pengaturan",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: InkWell(
                      onTap: () {
                        //  cupertino modal bottom sheet
                        Get.bottomSheet(
                          CupertinoActionSheet(
                            title: const Text(
                              "Notifikasi Push",
                              style: TextStyle(fontSize: 20),
                            ),
                            actions: [
                              CupertinoActionSheetAction(
                                child: const Text("Hidup"),
                                onPressed: () async {
                                  _konst.notifStatus.value = false;
                                  _konst.changeStatusNotif();
                                  Get.back();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text("Mati"),
                                onPressed: () async {
                                  _konst.notifStatus.value = true;
                                  _konst.changeStatusNotif();
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                            border: const Border(
                                bottom: BorderSide(
                                    color: Colors.grey, width: 0.3))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(MdiIcons.alarm),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Notifikasi",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: (!_konst.notifStatus.value)
                                            ? const Text(
                                                "Hidup",
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                              )
                                            : const Text(
                                                "Mati",
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                              )),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),

                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          CupertinoActionSheet(
                            title: const Text(
                              "Pilih Kualitas",
                              style: TextStyle(fontSize: 20),
                            ),
                            message: const Text(
                                "Pilih Kualitas Gambar yang akan ditampilkan"),
                            actions: [
                              CupertinoActionSheetAction(
                                child: const Text("5%"),
                                onPressed: () async {
                                  _konst.setReadQuality("5");
                                  Get.back();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text("10%"),
                                onPressed: () async {
                                  _konst.setReadQuality("10");
                                  Get.back();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text("15%"),
                                onPressed: () async {
                                  _konst.setReadQuality("15");
                                  Get.back();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text("20%"),
                                onPressed: () async {
                                  _konst.setReadQuality("20");
                                  Get.back();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text("25"),
                                onPressed: () async {
                                  _konst.readQuality.value = "25";
                                  Get.back();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text("50"),
                                onPressed: () async {
                                  _konst.readQuality.value = "50";

                                  Get.back();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text("70"),
                                onPressed: () async {
                                  _konst.readQuality.value = "70";

                                  Get.back();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text("80"),
                                onPressed: () async {
                                  _konst.readQuality.value = "80";

                                  Get.back();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text("100"),
                                onPressed: () async {
                                  _konst.readQuality.value = "100";

                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                            border: const Border(
                                bottom: BorderSide(
                                    color: Colors.grey, width: 0.3))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(MdiIcons.qualityHigh),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Kualitas Gambar",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        _konst.readQuality.value + "%",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: InkWell(
                      onTap: () {
                        //  cupertino modal bottom sheet
                        Get.bottomSheet(
                          CupertinoActionSheet(
                            title: const Text(
                              "Pilih Tema",
                              style: TextStyle(fontSize: 20),
                            ),
                            message: const Text(
                                "Pilih Tema yang ingin Anda gunakan"),
                            actions: [
                              CupertinoActionSheetAction(
                                child: const Text("Classic Light"),
                                onPressed: () async {
                                  var prefs =
                                      await SharedPreferences.getInstance();
                                  _tema.mode.value = 0;
                                  prefs
                                      .setInt('tema', _tema.mode.value)
                                      .then((value) {
                                    cons.navIndex.value = 4;
                                  });
                                  Get.back();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text("Classic Dark"),
                                onPressed: () async {
                                  var prefs =
                                      await SharedPreferences.getInstance();
                                  _tema.mode.value = 1;
                                  prefs
                                      .setInt('tema', _tema.mode.value)
                                      .then((value) {
                                    cons.navIndex.value = 4;
                                  });
                                  Get.back();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text("Pink Light"),
                                onPressed: () async {
                                  var prefs =
                                      await SharedPreferences.getInstance();
                                  _tema.mode.value = 2;
                                  prefs
                                      .setInt('tema', _tema.mode.value)
                                      .then((value) {
                                    cons.navIndex.value = 4;
                                  });
                                  Get.back();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text("Pink Dark"),
                                onPressed: () async {
                                  var prefs =
                                      await SharedPreferences.getInstance();
                                  _tema.mode.value = 3;
                                  prefs
                                      .setInt('tema', _tema.mode.value)
                                      .then((value) {
                                    cons.navIndex.value = 4;
                                  });
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                            border: const Border(
                                bottom: BorderSide(
                                    color: Colors.grey, width: 0.3))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(MdiIcons.themeLightDark),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Tema",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: (_tema.mode.value == 0)
                                          ? const Text(
                                              "Classic Light",
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14),
                                            )
                                          : (_tema.mode.value == 1)
                                              ? const Text(
                                                  "Classic Dark",
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14),
                                                )
                                              : (_tema.mode.value == 2)
                                                  ? const Text(
                                                      "Pink Light",
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14),
                                                    )
                                                  : const Text(
                                                      "Pink Dark",
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14),
                                                    ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),

                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: InkWell(
                      onTap: () async {
                        //  cupertino confirm dialog;
                        Get.dialog(
                          AlertDialog(
                            title: const Text("Konfirmasi"),
                            content: const Text(
                                "Apakah Anda yakin ingin mengupload data bookmark ke server?"),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text("Tidak"),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                              CupertinoDialogAction(
                                child: const Text("Ya"),
                                onPressed: () async {
                                  var backup = BmModel();
                                  backup.saveToServer().then((value) {
                                    Get.snackbar("Berhasil",
                                        "Data bookmark berhasil diupload ke server",
                                        snackPosition: SnackPosition.TOP,
                                        duration: Duration(seconds: 2));
                                  });
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                            border: const Border(
                                bottom: const BorderSide(
                                    color: Colors.grey, width: 0.3))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.sync),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Backup Data",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: InkWell(
                      onTap: () {
                        //  confirm dialog
                        Get.dialog(
                          AlertDialog(
                            title: const Text("Konfirmasi"),
                            content: const Text(
                                "Apakah Anda yakin ingin mengembalikan data dari backup?"),
                            actions: [
                              FlatButton(
                                child: const Text("Tidak"),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                              FlatButton(
                                child: const Text("Ya"),
                                onPressed: () async {
                                  var restoe = RestoreBookmark();
                                  restoe.getData().then((value) {
                                    Get.snackbar(
                                      'Berhasil',
                                      'Data berhasil dikembalikan',
                                      snackPosition: SnackPosition.TOP,
                                      duration: const Duration(seconds: 2),
                                      margin: const EdgeInsets.all(8),
                                      animationDuration:
                                          const Duration(seconds: 1),
                                    );
                                  });
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                            border: const Border(
                                bottom: const BorderSide(
                                    color: Colors.grey, width: 0.3))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.download),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Restore Data",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: InkWell(
                      onTap: () async {
                        var bm = Get.find<BmModel>();
                        // show confirm dialog cupertino
                        Get.dialog(
                          AlertDialog(
                            title: const Text("Konfirmasi"),
                            content: const Text(
                                "Apakah Anda yakin ingin menghapus semua Cache?"),
                            actions: [
                              FlatButton(
                                child: const Text("Tidak"),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                              FlatButton(
                                child: const Text("Ya"),
                                onPressed: () async {
                                  await DefaultCacheManager()
                                      .emptyCache()
                                      .then((value) {
                                    Get.snackbar(
                                      'Berhasil',
                                      'Data Cache dihapus',
                                      snackPosition: SnackPosition.TOP,
                                      duration: const Duration(seconds: 2),
                                      margin: const EdgeInsets.all(8),
                                      animationDuration:
                                          const Duration(seconds: 1),
                                    );
                                  });
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey, width: 0.3))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.delete),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Clear Cache",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                // if (auth.currentUser != null)
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: InkWell(
                      onTap: () {
                        // confirm cupertino dialog
                        Get.dialog(
                          CupertinoAlertDialog(
                            title: const Text("Konfirmasi"),
                            content: const Text(
                                "Apakah Anda yakin ingin keluar dari aplikasi?"),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text("Tidak"),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                              CupertinoDialogAction(
                                child: const Text("Ya"),
                                onPressed: () {
                                  _auth.signOut().then((value) {
                                    Get.offAll(const LoginPage());
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                            border: const Border(
                                bottom: BorderSide(
                                    color: Colors.grey, width: 0.3))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.logout),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Logout",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Info",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                for (var i = 0; i < 0; i++)
                  Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: InkWell(
                        onTap: () async {},
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: const BorderSide(
                                      color: Colors.grey, width: 0.3))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Hei",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      )),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: const BoxDecoration(
                        border: const Border(
                            bottom: const BorderSide(
                                color: Colors.grey, width: 0.3))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Versi",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(
                            _konst.versi.value,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
