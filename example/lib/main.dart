import 'package:checkout_flow_plugin/model/payment_session_request.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:checkout_flow_plugin/checkout_flow_plugin.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _formView = SizedBox.shrink();
  final _checkoutFlowPlugin = CheckoutFlowPlugin();

  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  final psr = PaymentSessionRequest(
      amount: 40,
      currency: "GBP",
      billing: Billing(address: Address(country: 'GB')),
      processingChannelId: 'pc_os6tpqzcz3vepnfyxdkdfxv22u',
    );

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      _formView =
         ( await _checkoutFlowPlugin.init(
            paymentRequest: psr,
            publicKey: const String.fromEnvironment('CHECKOUT_PUBLIC_KEY', defaultValue: ''),
            secretcKey: const String.fromEnvironment('CHECKOUT_SECRET_KEY', defaultValue: ''),
            environment: Enviroment.SANDBOX
          )) ?? SizedBox.shrink();
    } catch (e) {
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Plugin example appL')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () => initPlatformState(),
              child: Text('uytvgbhjn'),
            ),
            SizedBox(height: 20,),
            SizedBox(
              height: 400,
              child: _formView),
          ],
        ),
      ),
    );
  }
} 