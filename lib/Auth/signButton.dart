// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wrtappv2/ErrorPage/iderror.dart';
import 'package:wrtappv2/Screen/menupage.dart';
import 'package:wrtappv2/controller/auth_controller.dart';
import 'package:wrtappv2/controller/splash_controller.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    var authC = Get.find<AuthC>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 175, 12, 0)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                var _konst = Get.find<SplashC>();
                setState(() {
                  _isSigningIn = true;
                });

                try {
                  setState(() {
                    _isSigningIn = true;
                  });
                  UserCredential user = await authC.signInWithGoogle();

                  if (user.user != null) {
                    _konst.validationDeviceID().then((value) {
                      if (_konst.statusID.value) {
                        Get.off(const IdError(),
                            transition: Transition.fadeIn,
                            duration: const Duration(milliseconds: 600));
                      } else {
                        Get.offAll(() => const MenuPage(),
                            transition: Transition.fadeIn,
                            duration: const Duration(milliseconds: 600));
                      }
                    });
                  }
                } on FirebaseAuthException catch (e) {
                  Get.snackbar(
                    'Error',
                    e.message.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 3),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      MdiIcons.google,
                      color: Colors.white,
                      size: 24,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
