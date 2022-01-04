import 'package:flutter/material.dart';

class CloseApp extends StatelessWidget {
  final String message;
  const CloseApp({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            message,
            style: const TextStyle(fontSize: 20, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
