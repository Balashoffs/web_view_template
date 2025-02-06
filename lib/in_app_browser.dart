import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'main.dart';

class MyInAppBrowser extends InAppBrowser {
  MyInAppBrowser({
    super.windowId,
    super.initialUserScripts,
    super.pullToRefreshController,
  }) : super(
          webViewEnvironment: webViewEnvironment,
        );

  @override
  Future onBrowserCreated() async {}

  @override
  Future onLoadStart(url) async {}

  @override
  Future onLoadStop(url) async {}

  @override
  Future<PermissionResponse> onPermissionRequest(request) async {
    return PermissionResponse(
        resources: request.resources, action: PermissionResponseAction.GRANT);
  }

  @override
  void onLoadError(url, code, message) {}

  @override
  void onProgressChanged(progress) {}

  @override
  void onExit() {}

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onMainWindowWillClose() {
    close();
  }
}

class InAppBrowserExampleScreen extends StatefulWidget {
  const InAppBrowserExampleScreen({super.key});

  @override
  _InAppBrowserExampleScreenState createState() =>
      _InAppBrowserExampleScreenState();
}

class _InAppBrowserExampleScreenState extends State<InAppBrowserExampleScreen> {
  @override
  void initState() {
    super.initState();
    MyInAppBrowser? browser;
    PullToRefreshController? pullToRefreshController = kIsWeb ||
            ![TargetPlatform.iOS, TargetPlatform.android]
                .contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.black,
            ),
            onRefresh: () async {
              if (Platform.isAndroid) {
                browser?.webViewController?.reload();
              } else if (Platform.isIOS) {
                browser?.webViewController?.loadUrl(
                    urlRequest: URLRequest(
                        url: await browser.webViewController?.getUrl()));
              }
            },
          );

    browser = MyInAppBrowser(pullToRefreshController: pullToRefreshController);
    loadBrowser(browser);
  }

  void loadBrowser(MyInAppBrowser browser) async {
    await browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri("index.html")),
      settings: InAppBrowserClassSettings(
        browserSettings: InAppBrowserSettings(
            toolbarTopBackgroundColor: Colors.blue,
            presentationStyle: ModalPresentationStyle.POPOVER),
        webViewSettings: InAppWebViewSettings(
          isInspectable: kDebugMode,
          useShouldOverrideUrlLoading: true,
          useOnLoadResource: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center());
  }
}
