// import 'package:flutter_test/flutter_test.dart';
// import 'package:checkout_flow_plugin/checkout_flow_plugin.dart';
// import 'package:checkout_flow_plugin/checkout_flow_plugin_platform_interface.dart';
// import 'package:checkout_flow_plugin/checkout_flow_plugin_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockCheckoutFlowPluginPlatform
//     with MockPlatformInterfaceMixin
//     implements CheckoutFlowPluginPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final CheckoutFlowPluginPlatform initialPlatform = CheckoutFlowPluginPlatform.instance;

//   test('$MethodChannelCheckoutFlowPlugin is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelCheckoutFlowPlugin>());
//   });

//   test('getPlatformVersion', () async {
//     CheckoutFlowPlugin checkoutFlowPlugin = CheckoutFlowPlugin();
//     MockCheckoutFlowPluginPlatform fakePlatform = MockCheckoutFlowPluginPlatform();
//     CheckoutFlowPluginPlatform.instance = fakePlatform;

//     expect(await checkoutFlowPlugin.getPlatformVersion(), '42');
//   });
// }
