import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Chatango extends StatefulWidget {
  @override
  _ChatangoState createState() => _ChatangoState();
}

class _ChatangoState extends State<Chatango> {
  String urll = "";
  double _height = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey webViewKey = GlobalKey();
    InAppWebViewController? webViewController;
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
    final urlController = TextEditingController();
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
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
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
            onLoadResource: (controller, url) {
              print("onLoadResource: $url");
            },
          ),
        ));
  }
}
