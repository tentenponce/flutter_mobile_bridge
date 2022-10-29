import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webjs_communication/payment_param.dart';
import 'package:flutter_webjs_communication/payment_result.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView Communication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter WebView Communication'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebViewController? _controller;
  double _amount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
                'This is a sample implementation of mobile communicating to a webview'),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: WebView(
                  initialUrl: 'https://flutter-jsbridge.web.app/#/',
                  javascriptMode: JavascriptMode.unrestricted,
                  javascriptChannels: {
                    JavascriptChannel(
                        name: 'channelPay',
                        onMessageReceived: (JavascriptMessage message) {
                          PaymentParam paymentParam = PaymentParam.fromJson(
                              json.decode(message.message));

                          setState(() {
                            _amount = paymentParam.amount;
                          });
                        }),
                  },
                  onWebViewCreated: (WebViewController webviewController) {
                    _controller = webviewController;
                    _controller!.runJavascript(
                        'window.dispatchEvent(new CustomEvent("eventUser", {detail: "Juan Dela Cruz"}))');
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Amount submitted from mini app: $_amount',
            ),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: () {
                  PaymentResult paymentResult =
                      PaymentResult(transactionId: const Uuid().v4(), fee: 20);
                  _controller!.runJavascript(
                      "window.dispatchEvent(new CustomEvent('eventPayment', {detail: '${json.encode(paymentResult)}'}))");
                },
                child: const Text('Trigger payment success'))
          ],
        ),
      ),
    );
  }
}
