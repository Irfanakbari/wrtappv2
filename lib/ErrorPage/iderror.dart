import 'package:flutter/material.dart';

class IdError extends StatelessWidget {
  const IdError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Blocked By System, Please Contact Administrator @Jenskins',
            style: TextStyle(fontSize: 20, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
