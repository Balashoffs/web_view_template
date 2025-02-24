import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'main.dart';

class HeadlessInAppWebViewScreen extends StatefulWidget {
  const HeadlessInAppWebViewScreen({super.key});

  @override
  _HeadlessInAppWebViewScreenState createState() =>
      _HeadlessInAppWebViewScreenState();
}

class _HeadlessInAppWebViewScreenState
    extends State<HeadlessInAppWebViewScreen> {
  HeadlessInAppWebView? headlessWebView;
  String url = "";

  @override
  void initState() {
    super.initState();

    var url = !kIsWeb
        ? WebUri("https://flutter.dev")
        : WebUri("http://localhost:${Uri.base.port}/page.html");

    headlessWebView = HeadlessInAppWebView(
      webViewEnvironment: webViewEnvironment,
      initialUrlRequest: URLRequest(url: url),
      initialSettings: InAppWebViewSettings(
        isInspectable: kDebugMode,
      ),
      onWebViewCreated: (controller) {
        print('HeadlessInAppWebView created!');
      },
      onConsoleMessage: (controller, consoleMessage) {
        print("CONSOLE MESSAGE: " + consoleMessage.message);
      },
      onLoadStart: (controller, url) async {
        setState(() {
          this.url = url.toString();
        });
      },
      onLoadStop: (controller, url) async {
        setState(() {
          this.url = url.toString();
        });
      },
      onUpdateVisitedHistory: (controller, url, isReload) {
        setState(() {
          this.url = url.toString();
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "HeadlessInAppWebView",
            )),
        body: SafeArea(
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: Text(
                    "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await headlessWebView?.dispose();
                      await headlessWebView?.run();
                    },
                    child: Text("Run HeadlessInAppWebView")),
              ),
              Container(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      if (headlessWebView?.isRunning() ?? false) {
                        await headlessWebView?.webViewController
                            ?.evaluateJavascript(
                            source: """console.log('Here is the message!');""");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'HeadlessInAppWebView is not running. Click on "Run HeadlessInAppWebView"!'),
                        ));
                      }
                    },
                    child: Text("Send console.log message")),
              ),
              Container(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      headlessWebView?.dispose();
                      setState(() {
                        this.url = "";
                      });
                    },
                    child: Text("Dispose HeadlessInAppWebView")),
              )
            ])));
  }
}