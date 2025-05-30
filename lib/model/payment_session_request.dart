/// [amount] The payment amount. Provide a value of 0 to perform a card verification.
/// The amount must be provided in the minor currency unit.
/// 
/// [currency] The three-letter ISO currency code
/// 
/// [reference] A reference you can use to identify the payment. For example, an order number.
/// For Amex payments, this must be at most 30 characters.
/// For Benefit payments, the reference must be a unique alphanumeric value.
/// For iDEAL payments, the reference is required and must be an alphanumeric value with a 35-character limit.
/// 
/// [successUrl] Overrides the default success redirect URL configured on your account, for payment methods that require a redirect.
/// [failureUrl] Overrides the default failure redirect URL configured on your account, for payment methods that require a redirect.
/// 
/// [metadata] Allows you to store additional information about a transaction with custom fields and up to five user-defined fields, which can be used for reporting purposes. You can supply fields of type string, number, and boolean within the metadata object. Arrays and objects are not supported.
/// You can provide up to 18 metadata fields per API call, but the value of each field must not exceed 255 characters in length.
/// You can also reference metadata properties in your custom rules for Fraud Detection. For example, $coupon_code = '1234’.
/// 
/// [enabledPaymentMethods] Configurations for payment method-specific settings. Default = CARD
/// 
/// [processingChannelId] The processing channel to use for the payment. Provided at dashboard
class PaymentSessionRequest {
  final int amount;
  final String currency;
  final String? reference;
  final Shipping? shipping;
  final Billing billing;
  final ThreeDS? threeDS;
  List<String> enabledPaymentMethods;
  final String successUrl;
  final String failureUrl;
  final Metadata? metadata;
  final String processingChannelId;

  PaymentSessionRequest({
    required this.amount,
    required this.currency,
    required this.billing,
    required this.processingChannelId,
    this.successUrl = "https://example.com/payments/success",
    this.failureUrl = "https://example.com/payments/fail",
    this.reference,
    this.shipping,
    this.threeDS,
    this.metadata,
  }) : enabledPaymentMethods = ["card"];

  factory PaymentSessionRequest.fromJson(Map<String, dynamic> json) {
    return PaymentSessionRequest(
      amount: json['amount'],
      currency: json['currency'],
      reference: json['reference'],
      shipping: Shipping.fromJson(json['shipping']),
      billing: Billing.fromJson(json['billing']),
      threeDS: ThreeDS.fromJson(json['3ds']),
      successUrl: json['success_url'],
      failureUrl: json['failure_url'],
      metadata: Metadata.fromJson(json['metadata']),
      processingChannelId: json['processing_channel_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      if(reference!=null) 'reference': reference,
      if(shipping!=null) 'shipping': shipping?.toJson(),
      'billing': billing.toJson(),
      if(threeDS!=null) '3ds': threeDS?.toJson(),
      'enabled_payment_methods': enabledPaymentMethods,
      'success_url': successUrl,
      'failure_url': failureUrl,
      if(metadata!=null) 'metadata': metadata?.toJson(),
      'processing_channel_id': processingChannelId,
    };
  }

  @override
  String toString() {
    return 'PaymentRequest(amount: $amount, currency: $currency, reference: $reference, '
        'shipping: $shipping, billing: $billing, threeDS: $threeDS, '
        'enabledPaymentMethods: $enabledPaymentMethods, successUrl: $successUrl, '
        'failureUrl: $failureUrl, metadata: $metadata, processingChannelId: $processingChannelId)';
  }
}

class Shipping {
  final Address address;
  final Phone? phone;

  Shipping({required this.address,this.phone});

  factory Shipping.fromJson(Map<String, dynamic> json) {
    return Shipping(
      address: Address.fromJson(json['address']),
      phone: Phone?.fromJson(json['address'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address.toJson(),
      if(phone != null) 'phone': phone?.toJson()
    };
  }

  @override
  String toString() => 'Shipping(address: $address, phone: $phone)';
}

class Billing {
  final Address address;
  final Phone? phone;

  Billing({required this.address, this.phone});

  factory Billing.fromJson(Map<String, dynamic> json) {
    return Billing(
      address: Address.fromJson(json['address']),
      phone: Phone.fromJson(json['phone'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address.toJson(),
      if(phone!=null) 'phone' : phone?.toJson(),
    };
  }

  @override
  String toString() => 'Billing(address: $address)';
}

class Phone{
  final String countryCode;
  final String number;

  Phone({required this.countryCode, required this.number});

  factory Phone.fromJson(Map<String, dynamic> json) => Phone(
      countryCode: json['country_code'],
      number: json['number'],
    );
  
  Map<String, dynamic> toJson() => {
    'country_code' : countryCode,
    'number' : number
  };

}

/// [country] The two-letter ISO country code of the address.
class Address {
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? zip;
  final String country;

  Address({
    required this.country,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.zip,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressLine1: json['address_line1'],
      addressLine2: json['address_line2'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if(addressLine1!=null) 'address_line1': addressLine1,
      if(addressLine2!=null) 'address_line2': addressLine2,
      if(city!=null) 'city': city,
      if(state!=null) 'state': state,
      if(zip!=null) 'zip': zip,
      'country': country,
    };
  }

  @override
  String toString() {
    return 'Address(addressLine1: $addressLine1, addressLine2: $addressLine2, '
        'city: $city, state: $state, zip: $zip, country: $country)';
  }
}

class ThreeDS {
  final bool enabled;
  final bool attemptN3d;
  final String challengeIndicator;
  final String exemption;
  final bool allowUpgrade;

  const ThreeDS({
     this.enabled = false,
     this.attemptN3d = false,
     this.challengeIndicator = 'no_preference',
     this.exemption = 'low_value',
     this.allowUpgrade = true,
  });

  factory ThreeDS.fromJson(Map<String, dynamic> json) {
    return ThreeDS(
      enabled: json['enabled'],
      attemptN3d: json['attempt_n3d'],
      challengeIndicator: json['challenge_indicator'],
      exemption: json['exemption'],
      allowUpgrade: json['allow_upgrade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'attempt_n3d': attemptN3d,
      'challenge_indicator': challengeIndicator,
      'exemption': exemption,
      'allow_upgrade': allowUpgrade,
    };
  }

  @override
  String toString() {
    return 'ThreeDS(enabled: $enabled, attemptN3d: $attemptN3d, '
        'challengeIndicator: $challengeIndicator, exemption: $exemption, '
        'allowUpgrade: $allowUpgrade)';
  }
}

class Metadata {
  final String couponCode;
  final int partnerId;

  Metadata({
    required this.couponCode,
    required this.partnerId,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      couponCode: json['coupon_code'],
      partnerId: json['partner_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coupon_code': couponCode,
      'partner_id': partnerId,
    };
  }

  @override
  String toString() => 'Metadata(couponCode: $couponCode, partnerId: $partnerId)';
}