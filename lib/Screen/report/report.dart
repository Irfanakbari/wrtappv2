import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:wrtappv2/const/function.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var konst = Get.find<Konst>();
    TextEditingController _controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lapor Bug / Masalah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  minLines: null,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: 'Jelaskan Detail Masalah',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RaisedButton(
                child: const Text('Kirim'),
                onPressed: () async {
                  konst.sendReport(_controller.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
