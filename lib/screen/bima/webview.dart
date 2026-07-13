import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebView extends StatefulWidget {
  final String url;
  InAppWebView({required this.url});

  @override
  State<InAppWebView> createState() => _InAppWebViewState();
}

class _InAppWebViewState extends State<InAppWebView> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController();
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);

    _controller.addJavaScriptChannel("web view", onMessageReceived: (
      JavaScriptMessage message,
    ) {
      // print("Received message from javascript: ${message.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.message),
        ),
      );
    });

    _controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InAppWebView'),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
