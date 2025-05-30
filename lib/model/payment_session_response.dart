
/// [id] The Payment Sessions unique identifier
/// 
/// [paymentSessionToken] A unique token representing the payment session, which you must provide when you initialize Flow.
/// Do not log or store this value.
/// 
/// [paymentSessionSecret] The secret used by Flow to authenticate payment session requests.
/// Do not log or store this value.
/// 
/// [links] The links related to the Payment Session.
class PaymentSessionResponse {
  final String id;
  final String paymentSessionToken;
  final String paymentSessionSecret;
  final PaymentLinks links;

  PaymentSessionResponse({
    required this.id,
    required this.paymentSessionToken,
    required this.paymentSessionSecret,
    required this.links,
  });

  factory PaymentSessionResponse.fromJson(Map<String, dynamic> json) {
    return PaymentSessionResponse(
      id: json['id'],
      paymentSessionToken: json['payment_session_token'],
      paymentSessionSecret: json['payment_session_secret'],
      links: PaymentLinks.fromJson(json['_links']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_session_token': paymentSessionToken,
      'payment_session_secret': paymentSessionSecret,
      '_links': links.toJson(),
    };
  }

  @override
  String toString() {
    return 'PaymentSessionResponse(id: $id, paymentSessionToken: $paymentSessionToken, '
        'paymentSessionSecret: $paymentSessionSecret, links: $links)';
  }
}

class PaymentLinks {
  final Link self;

  PaymentLinks({required this.self});

  factory PaymentLinks.fromJson(Map<String, dynamic> json) {
    return PaymentLinks(
      self: Link.fromJson(json['self']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'self': self.toJson(),
    };
  }

  @override
  String toString() => 'PaymentLinks(self: $self)';
}

class Link {
  final String href;

  Link({required this.href});

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      href: json['href'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'href': href,
    };
  }

  @override
  String toString() => 'Link(href: $href)';
}