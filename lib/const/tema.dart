import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tema {
  var mode = 0.obs;
  Rx navIndex = 0.obs;
  Tema() {
    getDark();
  }

  getDark() async {
    var prefs = await SharedPreferences.getInstance();
    var darkModeOn = prefs.getInt('tema') ?? 0;
    if (darkModeOn == 0) {
      mode.value = 0;
    } else if (darkModeOn == 1) {
      mode.value = 1;
    } else if (darkModeOn == 2) {
      mode.value = 2;
    } else if (darkModeOn == 3) {
      mode.value = 3;
    } else if (darkModeOn == 4) {
      mode.value = 4;
    } else if (darkModeOn == 5) {
      mode.value = 5;
    }
    return mode.value;
  }

  static ThemeData darkTheme = ThemeData(
    dividerColor: Colors.white,
    // brightness: Brightness.dark,
    // primarySwatch: const Color.fromRGBO(86, 84, 158, 1),
    backgroundColor: const Color.fromRGBO(34, 34, 34, 1),
    appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromRGBO(86, 84, 158, 1), elevation: 0),
    primaryColor: const Color.fromRGBO(86, 84, 158, 1),
    scaffoldBackgroundColor: const Color.fromRGBO(22, 21, 29, 1),
    textTheme: const TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromRGBO(22, 21, 29, 1),
      elevation: 0,
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      barBackgroundColor: Colors.black,
      textTheme: CupertinoTextThemeData(
        primaryColor: Colors.white,
        textStyle: TextStyle(color: Colors.white),
      ),
      primaryColor: Colors.black,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromRGBO(86, 84, 158, 1),
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.white,
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: Color.fromRGBO(86, 84, 158, 1)),
  );

  static ThemeData lightTheme = ThemeData(
    dividerColor: Colors.black,
    backgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromRGBO(86, 84, 158, 1), elevation: 0),
    primaryColor: const Color.fromRGBO(86, 84, 158, 1),
    scaffoldBackgroundColor: const Color.fromRGBO(238, 240, 242, 1),
    textTheme: const TextTheme(
      bodyText1: TextStyle(color: Colors.black),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromRGBO(86, 84, 158, 1),
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.white,
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: Color.fromRGBO(86, 84, 158, 1)),
  );

  static ThemeData pinkTheme = ThemeData(
    dividerColor: Colors.black,
    backgroundColor: Colors.white,
    appBarTheme:
        const AppBarTheme(backgroundColor: Color.fromARGB(255, 255, 3, 129)),
    primaryColor: const Color.fromARGB(255, 255, 3, 129),
    scaffoldBackgroundColor: const Color.fromRGBO(238, 240, 242, 1),
    textTheme: const TextTheme(
      bodyText1: TextStyle(color: Colors.black),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 255, 3, 129),
      selectedItemColor: Colors.yellowAccent,
      unselectedItemColor: Colors.white,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color.fromARGB(255, 255, 3, 129)),
  );

  static ThemeData pinkDarkTheme = ThemeData(
    dividerColor: Colors.white,
    // brightness: Brightness.dark,
    // primarySwatch: const Color.fromRGBO(86, 84, 158, 1),
    backgroundColor: const Color.fromRGBO(34, 34, 34, 1),
    appBarTheme:
        const AppBarTheme(backgroundColor: Color.fromARGB(255, 255, 3, 129)),
    primaryColor: const Color.fromARGB(255, 255, 3, 129),
    scaffoldBackgroundColor: const Color.fromRGBO(22, 21, 29, 1),
    textTheme: const TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromRGBO(22, 21, 29, 1),
      elevation: 0,
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      barBackgroundColor: Colors.black,
      textTheme: CupertinoTextThemeData(
        primaryColor: Colors.white,
        textStyle: TextStyle(color: Colors.white),
      ),
      primaryColor: Colors.black,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 255, 3, 129),
      selectedItemColor: Colors.yellowAccent,
      unselectedItemColor: Colors.white,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color.fromARGB(255, 255, 3, 129)),
  );
  static ThemeData greenTheme = ThemeData(
    dividerColor: Colors.black,
    backgroundColor: Colors.white,
    appBarTheme:
        const AppBarTheme(backgroundColor: Color.fromARGB(255, 3, 119, 8)),
    primaryColor: const Color.fromARGB(255, 3, 119, 8),
    scaffoldBackgroundColor: const Color.fromRGBO(238, 240, 242, 1),
    textTheme: const TextTheme(
      bodyText1: TextStyle(color: Colors.black),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 3, 119, 8),
      selectedItemColor: Color.fromARGB(255, 255, 71, 71),
      unselectedItemColor: Colors.white,
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: Color.fromARGB(255, 3, 119, 8)),
  );

  static ThemeData greenDarkTheme = ThemeData(
    dividerColor: Colors.white,
    // brightness: Brightness.dark,
    // primarySwatch: const Color.fromRGBO(86, 84, 158, 1),
    backgroundColor: const Color.fromRGBO(34, 34, 34, 1),
    appBarTheme:
        const AppBarTheme(backgroundColor: Color.fromARGB(255, 3, 119, 8)),
    primaryColor: const Color.fromARGB(255, 3, 119, 8),
    scaffoldBackgroundColor: const Color.fromRGBO(22, 21, 29, 1),
    textTheme: const TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromRGBO(22, 21, 29, 1),
      elevation: 0,
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      barBackgroundColor: Colors.black,
      textTheme: CupertinoTextThemeData(
        primaryColor: Colors.white,
        textStyle: TextStyle(color: Colors.white),
      ),
      primaryColor: Colors.black,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 3, 119, 8),
      selectedItemColor: Color.fromARGB(255, 255, 71, 71),
      unselectedItemColor: Colors.white,
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: Color.fromARGB(255, 3, 119, 8)),
  );
}
