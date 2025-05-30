import 'package:checkout_flow_plugin/model/payment_session_request.dart';
import 'package:checkout_flow_plugin/model/payment_session_response.dart';
import 'package:checkout_flow_plugin/network/contants.dart';
import 'package:flutter/cupertino.dart';

import 'api_client.dart';

class FCheckoutRepo {
  final ApiClient _apiClient;

  FCheckoutRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  /// create payment-session
  Future<PaymentSessionResponse?> createPaymentSession({
    required String secretKey,
    required PaymentSessionRequest data,
  }) async {
    final response = await _apiClient.post(
      Endpoints.paymentSession,
      body: data.toJson(),
      headers: {
        'Authorization' : 'Bearer $secretKey'
      }
    );
    debugPrint(response.toString());
    if (response != null) {
      return PaymentSessionResponse.fromJson(response);
    }
    return null;
  }

  void dispose() {
    _apiClient.dispose();
  }
}
