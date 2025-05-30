import 'package:checkout_flow_plugin/checkout_flow_plugin.dart' show Enviroment;

class NetworkConfig {
  NetworkConfig({this.env = Enviroment.SANDBOX}){
    baseUrl = 'https://${env.isSANDBOX? _sandbox : _prod}';
  }

  final Enviroment env;
  String baseUrl = 'https://$_sandbox';

  static const String _prod = 'api.checkout.com';
  static const String _sandbox = 'api.sandbox.checkout.com';

  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Headers
  Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Error Messages
  static const String networkError = 'Network error occurred';
  static const String timeoutError = 'Request timed out';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'An unknown error occurred';
} 