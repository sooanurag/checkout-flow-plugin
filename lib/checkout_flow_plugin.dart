// ignore_for_file: constant_identifier_names

import 'package:checkout_flow_plugin/model/payment_session_request.dart';
import 'package:checkout_flow_plugin/platform_view.dart';
import 'package:flutter/cupertino.dart';

import 'checkout_flow_plugin_platform_interface.dart';

enum Enviroment {
  PRODUCTION('PRODUCTION'),
  SANDBOX('SANDBOX');

  const Enviroment(this.value);
  final String value;

  bool get isPRODUCTION => this == PRODUCTION;
  bool get isSANDBOX => this == SANDBOX;
}

class CheckoutFlowPlugin {
  Future<Widget?> init({
    required String publicKey,
    required String secretcKey,
    required PaymentSessionRequest paymentRequest,
    Enviroment environment = Enviroment.SANDBOX,
  }) async {
    final status = await CheckoutFlowPluginPlatform.instance.init(
      publicKey: publicKey,
      secretcKey: secretcKey,
      paymentRequest: paymentRequest,
      environment: environment,
    );
    if(status==null) return null;
    
    return FPlatformView();
  }
}
