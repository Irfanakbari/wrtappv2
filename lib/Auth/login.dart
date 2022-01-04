// ignore_for_file: deprecated_member_use
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrtappv2/Auth/signButton.dart';
import 'package:wrtappv2/const/abstract.dart';
import 'sys/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _konst = Get.find<Konst>();
    final Auth _auth = Auth();
    final FirebaseAuth _fire = FirebaseAuth.instance;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(86, 84, 158, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/img/logo.png',
                        height: 160,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: Auth.initializeFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton();
                  }
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.deepPurple,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
