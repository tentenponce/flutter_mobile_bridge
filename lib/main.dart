import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobile_bridge/flutter_mobile_bridge.dart';
import 'package:flutter_mobile_bridge/models/payment_result.dart';
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
                    FlutterMobileBridge.handleChannelPay(
                      onPaymentEvent: (param) {
                        setState(() {
                          _amount = param.amount;
                        });
                      },
                    )
                  },
                  onWebViewCreated: (WebViewController webviewController) {
                    _controller = webviewController;
                  },
                  onPageFinished: (url) {
                    FlutterMobileBridge.dispatchUser(
                        _controller!, 'Juan Dela Cruz');
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
                  FlutterMobileBridge.dispatchSuccessPayment(
                    _controller!,
                    paymentResult,
                  );
                },
                child: const Text('Trigger payment success'))
          ],
        ),
      ),
    );
  }
}
