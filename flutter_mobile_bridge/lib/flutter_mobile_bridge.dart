library flutter_mobile_bridge;

import 'dart:convert';

import 'package:flutter_mobile_bridge/models/payment_param.dart';
import 'package:flutter_mobile_bridge/models/payment_result.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FlutterMobileBridge {
  static const String _eventUser = 'eventUser';
  static const String _eventPayment = 'eventPayment';
  static const String _jsChannelPay = 'channelPay';

  static JavascriptChannel handleChannelPay({
    required Function(PaymentParam param) onPaymentEvent,
  }) {
    return JavascriptChannel(
        name: _jsChannelPay,
        onMessageReceived: (JavascriptMessage message) {
          PaymentParam paymentParam =
              PaymentParam.fromJson(json.decode(message.message));

          onPaymentEvent(paymentParam);
        });
  }

  static Future<void> dispatchUser(
      WebViewController controller, String name) async {
    await _dispatchEvent(
      controller: controller,
      eventName: _eventUser,
      detail: name,
    );
  }

  static Future<void> dispatchSuccessPayment(
      WebViewController controller, PaymentResult paymentResult) async {
    await _dispatchEvent(
      controller: controller,
      eventName: _eventPayment,
      detail: json.encode(paymentResult),
    );
  }

  static Future<void> _dispatchEvent({
    required WebViewController controller,
    required String eventName,
    required String detail,
  }) async {
    await controller.runJavascript(
        "window.dispatchEvent(new CustomEvent('$eventName', {detail: '$detail'}))");
  }
}
