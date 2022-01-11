import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Disqus extends StatefulWidget {
  final String url;
  final String title;
  const Disqus({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  _DisqusState createState() => _DisqusState();
}

class _DisqusState extends State<Disqus> {
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

    String urls = 'https://disqus.wrt.my.id/disqus.php/?shortname=wrt1&url=' +
        widget.url +
        '&title=' +
        widget.title;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Disqus'),
        ),
        body: InAppWebView(
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
          // on finish loading
          onLoadStop: (controller, url) {
            if (url.toString().contains('disqus.com/next/login-success')) {
              webViewController?.loadUrl(
                  urlRequest: URLRequest(url: Uri.parse(urls)));
            }
          },
          onLoadResource: (controller, url) {},
        ));
  }
}
