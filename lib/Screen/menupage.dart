import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrtappv2/Screen/all/allkomik.dart';
import 'package:wrtappv2/Screen/allgenres/genres.dart';
import 'package:wrtappv2/Screen/bookmark/bookmark.dart';
import 'package:wrtappv2/Screen/homepage.dart';
import 'package:wrtappv2/Screen/setting/setting.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:wrtappv2/const/tema.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // RxInt navIndex = 0.obs;
    var cons = Get.put(Tema());

    void selectNavBot(int index) {
      cons.navIndex.value = index;
    }

    final List<Widget> tab = [
      const HomePage(),
      const AllKomik(),
      const AllGenres(),
      const BookmarkPage(),
      const Setting()
    ];

    return Obx(
      () => Scaffold(
        body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
              content: Text('Tekan sekali lagi untuk keluar'),
              duration: Duration(seconds: 2),
            ),
            child: tab[cons.navIndex.value]),
        // bottom navigation bar
        bottomNavigationBar: SizedBox(
          height: 60,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cons.navIndex.value,
            onTap: selectNavBot,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.all_inbox), label: 'All'),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Genres'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark), label: 'Bookmark'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
            ],
          ),
        ),
      ),
    );
  }
}
