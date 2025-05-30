import 'package:checkout_flow_plugin/checkout_flow_plugin.dart';
import 'package:checkout_flow_plugin/model/payment_session_request.dart';
import 'package:checkout_flow_plugin/network/network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'checkout_flow_plugin_platform_interface.dart';

/// An implementation of [CheckoutFlowPluginPlatform] that uses method channels.
class MethodChannelCheckoutFlowPlugin extends CheckoutFlowPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('checkout_flow_plugin');
  late ApiClient _apiClient;
  late NetworkConfig _networkConfig;
  late FCheckoutRepo _fCheckoutRepo;

  void _initNetwork([Enviroment environment = Enviroment.SANDBOX]){
    _networkConfig = NetworkConfig(env: environment);
    _apiClient = ApiClient(config: _networkConfig);
    _fCheckoutRepo = FCheckoutRepo(apiClient: _apiClient);
  }


  @override
  Future<String?> init({
    required String publicKey,
    required String secretcKey,
    required PaymentSessionRequest paymentRequest,
    Enviroment environment = Enviroment.SANDBOX,
  }) async {
   _initNetwork(environment);
    final sessionResponse = await _fCheckoutRepo.createPaymentSession(data: paymentRequest,secretKey: secretcKey,);
    if(sessionResponse == null) {
      return 'FAILED';
    }

    final status = await methodChannel.invokeMethod<String>('checkoutComponentConfig',{
      'public_key': publicKey,
      'environment': environment.value,
      'payment_session_id' : sessionResponse.id,
      'payment_session_secret' : sessionResponse.paymentSessionSecret,
    });
    return status;
  }

  
}
