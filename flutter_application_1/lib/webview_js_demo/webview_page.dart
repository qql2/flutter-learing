import 'dart:io';
import 'package:flutter/material.dart';
import 'platform/webview_windows.dart';
import 'platform/webview_mobile.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView Demo'),
      ),
      body: Platform.isWindows ? const WindowsWebView() : const MobileWebView(),
    );
  }
}
