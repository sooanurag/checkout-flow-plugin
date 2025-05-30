import 'package:checkout_flow_plugin/checkout_flow_plugin.dart' show Enviroment;
import 'package:checkout_flow_plugin/model/payment_session_request.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'checkout_flow_plugin_method_channel.dart';

abstract class CheckoutFlowPluginPlatform extends PlatformInterface {
  /// Constructs a CheckoutFlowPluginPlatform.
  CheckoutFlowPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static CheckoutFlowPluginPlatform _instance = MethodChannelCheckoutFlowPlugin();

  /// The default instance of [CheckoutFlowPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelCheckoutFlowPlugin].
  static CheckoutFlowPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CheckoutFlowPluginPlatform] when
  /// they register themselves.
  static set instance(CheckoutFlowPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> init(
    {
    required String publicKey,
    required String secretcKey,
    required PaymentSessionRequest paymentRequest,
    Enviroment environment = Enviroment.SANDBOX,
  }
  ) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
