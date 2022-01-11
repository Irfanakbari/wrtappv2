import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class Chatango extends StatefulWidget {
  const Chatango({Key? key}) : super(key: key);

  @override
  _ChatangoState createState() => _ChatangoState();
}

class _ChatangoState extends State<Chatango> {
  String urll = "";

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey webViewKey = GlobalKey();
    InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
        ),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
        ),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
        ));

    String urls = 'https://chatwrt.chatango.com/';
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chatango'),
        ),
        body: SizedBox(
          height: Get.height,
          width: double.infinity,
          child: InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: Uri.parse(urls)),
            initialOptions: options,
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
            onLoadResource: (controller, url) {},
          ),
        ));
  }
}
