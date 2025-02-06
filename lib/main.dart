import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'in_app_webview.dart';

final localhostServer = InAppLocalhostServer(documentRoot: 'assets/viewer/', port: 4444);
WebViewEnvironment? webViewEnvironment;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    final availableVersion = await WebViewEnvironment.getAvailableVersion();
    assert(availableVersion != null,
        'Failed to find an installed WebView2 runtime or non-stable Microsoft Edge installation.');

    webViewEnvironment = await WebViewEnvironment.create(
        settings: WebViewEnvironmentSettings(userDataFolder: 'custom_path'));
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => InAppWebViewScreen(),
        },
      );
    }
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => InAppWebViewScreen(),
          // '/InAppBrowser': (context) => InAppBrowserExampleScreen(),
          // '/HeadlessInAppWebView': (context) => HeadlessInAppWebViewScreen(),
          // '/WebAuthenticationSession': (context) =>
          //     WebAuthenticationSessionExampleScreen(),
        },
      );
    } else if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => InAppWebViewScreen(),
          // '/InAppBrowser': (context) => InAppBrowserExampleScreen(),
          // '/HeadlessInAppWebView': (context) => HeadlessInAppWebViewScreen(),
        },
      );
    }
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => InAppWebViewScreen(),
        // '/InAppBrowser': (context) => InAppBrowserExampleScreen(),
        // '/ChromeSafariBrowser': (context) => ChromeSafariBrowserExampleScreen(),
        // '/HeadlessInAppWebView': (context) => HeadlessInAppWebViewScreen(),
        // '/WebAuthenticationSession': (context) =>
        //     WebAuthenticationSessionExampleScreen(),
      },
    );
  }
}
