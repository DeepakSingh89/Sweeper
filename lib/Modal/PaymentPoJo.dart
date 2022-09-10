// To parse this JSON data, do
//
//     final paymentPoJo = paymentPoJoFromJson(jsonString);

import 'dart:convert';

PaymentPoJo paymentPoJoFromJson(String str) => PaymentPoJo.fromJson(json.decode(str));

String paymentPoJoToJson(PaymentPoJo data) => json.encode(data.toJson());

class PaymentPoJo {
  PaymentPoJo({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  Data? data;

  factory PaymentPoJo.fromJson(Map<String, dynamic> json) => PaymentPoJo(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.object,
    this.amount,
    this.amountCapturable,
    this.amountReceived,
    this.application,
    this.applicationFeeAmount,
    this.automaticPaymentMethods,
    this.canceledAt,
    this.cancellationReason,
    this.captureMethod,
    this.charges,
    this.clientSecret,
    this.confirmationMethod,
    this.created,
    this.currency,
    this.customer,
    this.description,
    this.invoice,
    this.lastPaymentError,
    this.livemode,
    this.metadata,
    this.nextAction,
    this.onBehalfOf,
    this.paymentMethod,
    this.paymentMethodOptions,
    this.paymentMethodTypes,
    this.receiptEmail,
    this.review,
    this.setupFutureUsage,
    this.shipping,
    this.source,
    this.statementDescriptor,
    this.statementDescriptorSuffix,
    this.status,
    this.transferData,
    this.transferGroup,
  });

  String? id;
  String? object;
  int? amount;
  int? amountCapturable;
  int? amountReceived;
  dynamic application;
  dynamic applicationFeeAmount;
  dynamic automaticPaymentMethods;
  dynamic canceledAt;
  dynamic cancellationReason;
  String? captureMethod;
  Charges? charges;
  String? clientSecret;
  String? confirmationMethod;
  int? created;
  String? currency;
  String? customer;
  dynamic description;
  dynamic invoice;
  dynamic lastPaymentError;
  bool? livemode;
  List<dynamic>? metadata;
  dynamic nextAction;
  dynamic onBehalfOf;
  String? paymentMethod;
  PaymentMethodOptions? paymentMethodOptions;
  List<String>? paymentMethodTypes;
  dynamic receiptEmail;
  dynamic review;
  dynamic setupFutureUsage;
  dynamic shipping;
  dynamic source;
  dynamic statementDescriptor;
  dynamic statementDescriptorSuffix;
  String? status;
  dynamic transferData;
  String? transferGroup;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    object: json["object"] == null ? null : json["object"],
    amount: json["amount"] == null ? null : json["amount"],
    amountCapturable: json["amount_capturable"] == null ? null : json["amount_capturable"],
    amountReceived: json["amount_received"] == null ? null : json["amount_received"],
    application: json["application"],
    applicationFeeAmount: json["application_fee_amount"],
    automaticPaymentMethods: json["automatic_payment_methods"],
    canceledAt: json["canceled_at"],
    cancellationReason: json["cancellation_reason"],
    captureMethod: json["capture_method"] == null ? null : json["capture_method"],
    charges: json["charges"] == null ? null : Charges.fromJson(json["charges"]),
    clientSecret: json["client_secret"] == null ? null : json["client_secret"],
    confirmationMethod: json["confirmation_method"] == null ? null : json["confirmation_method"],
    created: json["created"] == null ? null : json["created"],
    currency: json["currency"] == null ? null : json["currency"],
    customer: json["customer"] == null ? null : json["customer"],
    description: json["description"],
    invoice: json["invoice"],
    lastPaymentError: json["last_payment_error"],
    livemode: json["livemode"] == null ? null : json["livemode"],
    metadata: json["metadata"] == null ? null : List<dynamic>.from(json["metadata"].map((x) => x)),
    nextAction: json["next_action"],
    onBehalfOf: json["on_behalf_of"],
    paymentMethod: json["payment_method"] == null ? null : json["payment_method"],
    paymentMethodOptions: json["payment_method_options"] == null ? null : PaymentMethodOptions.fromJson(json["payment_method_options"]),
    paymentMethodTypes: json["payment_method_types"] == null ? null : List<String>.from(json["payment_method_types"].map((x) => x)),
    receiptEmail: json["receipt_email"],
    review: json["review"],
    setupFutureUsage: json["setup_future_usage"],
    shipping: json["shipping"],
    source: json["source"],
    statementDescriptor: json["statement_descriptor"],
    statementDescriptorSuffix: json["statement_descriptor_suffix"],
    status: json["status"] == null ? null : json["status"],
    transferData: json["transfer_data"],
    transferGroup: json["transfer_group"] == null ? null : json["transfer_group"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "object": object == null ? null : object,
    "amount": amount == null ? null : amount,
    "amount_capturable": amountCapturable == null ? null : amountCapturable,
    "amount_received": amountReceived == null ? null : amountReceived,
    "application": application,
    "application_fee_amount": applicationFeeAmount,
    "automatic_payment_methods": automaticPaymentMethods,
    "canceled_at": canceledAt,
    "cancellation_reason": cancellationReason,
    "capture_method": captureMethod == null ? null : captureMethod,
    "charges": charges == null ? null : charges!.toJson(),
    "client_secret": clientSecret == null ? null : clientSecret,
    "confirmation_method": confirmationMethod == null ? null : confirmationMethod,
    "created": created == null ? null : created,
    "currency": currency == null ? null : currency,
    "customer": customer == null ? null : customer,
    "description": description,
    "invoice": invoice,
    "last_payment_error": lastPaymentError,
    "livemode": livemode == null ? null : livemode,
    "metadata": metadata == null ? null : List<dynamic>.from(metadata!.map((x) => x)),
    "next_action": nextAction,
    "on_behalf_of": onBehalfOf,
    "payment_method": paymentMethod == null ? null : paymentMethod,
    "payment_method_options": paymentMethodOptions == null ? null : paymentMethodOptions!.toJson(),
    "payment_method_types": paymentMethodTypes == null ? null : List<dynamic>.from(paymentMethodTypes!.map((x) => x)),
    "receipt_email": receiptEmail,
    "review": review,
    "setup_future_usage": setupFutureUsage,
    "shipping": shipping,
    "source": source,
    "statement_descriptor": statementDescriptor,
    "statement_descriptor_suffix": statementDescriptorSuffix,
    "status": status == null ? null : status,
    "transfer_data": transferData,
    "transfer_group": transferGroup == null ? null : transferGroup,
  };
}

class Datum {
  Datum({
    this.id,
    this.object,
    this.amount,
    this.amountCaptured,
    this.amountRefunded,
    this.application,
    this.applicationFee,
    this.applicationFeeAmount,
    this.balanceTransaction,
    this.billingDetails,
    this.calculatedStatementDescriptor,
    this.captured,
    this.created,
    this.currency,
    this.customer,
    this.description,
    this.destination,
    this.dispute,
    this.disputed,
    this.failureCode,
    this.failureMessage,
    this.fraudDetails,
    this.invoice,
    this.livemode,
    this.metadata,
    this.onBehalfOf,
    this.order,
    this.outcome,
    this.paid,
    this.paymentIntent,
    this.paymentMethod,
    this.paymentMethodDetails,
    this.receiptEmail,
    this.receiptNumber,
    this.receiptUrl,
    this.refunded,
    this.refunds,
    this.review,
    this.shipping,
    this.source,
    this.sourceTransfer,
    this.statementDescriptor,
    this.statementDescriptorSuffix,
    this.status,
    this.transferData,
    this.transferGroup,
  });

  String? id;
  String? object;
  int? amount;
  int? amountCaptured;
  int? amountRefunded;
  dynamic application;
  dynamic applicationFee;
  dynamic applicationFeeAmount;
  String? balanceTransaction;
  BillingDetails? billingDetails;
  String? calculatedStatementDescriptor;
  bool? captured;
  int? created;
  String? currency;
  String? customer;
  dynamic description;
  dynamic destination;
  dynamic dispute;
  bool? disputed;
  dynamic failureCode;
  dynamic failureMessage;
  List<dynamic>? fraudDetails;
  dynamic invoice;
  bool? livemode;
  List<dynamic>? metadata;
  dynamic onBehalfOf;
  dynamic order;
  Outcome? outcome;
  bool? paid;
  String? paymentIntent;
  String? paymentMethod;
  PaymentMethodDetails? paymentMethodDetails;
  dynamic receiptEmail;
  dynamic receiptNumber;
  String? receiptUrl;
  bool? refunded;
  Charges? refunds;
  dynamic review;
  dynamic shipping;
  dynamic source;
  dynamic sourceTransfer;
  dynamic statementDescriptor;
  dynamic statementDescriptorSuffix;
  String? status;
  dynamic transferData;
  String? transferGroup;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    object: json["object"] == null ? null : json["object"],
    amount: json["amount"] == null ? null : json["amount"],
    amountCaptured: json["amount_captured"] == null ? null : json["amount_captured"],
    amountRefunded: json["amount_refunded"] == null ? null : json["amount_refunded"],
    application: json["application"],
    applicationFee: json["application_fee"],
    applicationFeeAmount: json["application_fee_amount"],
    balanceTransaction: json["balance_transaction"] == null ? null : json["balance_transaction"],
    billingDetails: json["billing_details"] == null ? null : BillingDetails.fromJson(json["billing_details"]),
    calculatedStatementDescriptor: json["calculated_statement_descriptor"] == null ? null : json["calculated_statement_descriptor"],
    captured: json["captured"] == null ? null : json["captured"],
    created: json["created"] == null ? null : json["created"],
    currency: json["currency"] == null ? null : json["currency"],
    customer: json["customer"] == null ? null : json["customer"],
    description: json["description"],
    destination: json["destination"],
    dispute: json["dispute"],
    disputed: json["disputed"] == null ? null : json["disputed"],
    failureCode: json["failure_code"],
    failureMessage: json["failure_message"],
    fraudDetails: json["fraud_details"] == null ? null : List<dynamic>.from(json["fraud_details"].map((x) => x)),
    invoice: json["invoice"],
    livemode: json["livemode"] == null ? null : json["livemode"],
    metadata: json["metadata"] == null ? null : List<dynamic>.from(json["metadata"].map((x) => x)),
    onBehalfOf: json["on_behalf_of"],
    order: json["order"],
    outcome: json["outcome"] == null ? null : Outcome.fromJson(json["outcome"]),
    paid: json["paid"] == null ? null : json["paid"],
    paymentIntent: json["payment_intent"] == null ? null : json["payment_intent"],
    paymentMethod: json["payment_method"] == null ? null : json["payment_method"],
    paymentMethodDetails: json["payment_method_details"] == null ? null : PaymentMethodDetails.fromJson(json["payment_method_details"]),
    receiptEmail: json["receipt_email"],
    receiptNumber: json["receipt_number"],
    receiptUrl: json["receipt_url"] == null ? null : json["receipt_url"],
    refunded: json["refunded"] == null ? null : json["refunded"],
    refunds: json["refunds"] == null ? null : Charges.fromJson(json["refunds"]),
    review: json["review"],
    shipping: json["shipping"],
    source: json["source"],
    sourceTransfer: json["source_transfer"],
    statementDescriptor: json["statement_descriptor"],
    statementDescriptorSuffix: json["statement_descriptor_suffix"],
    status: json["status"] == null ? null : json["status"],
    transferData: json["transfer_data"],
    transferGroup: json["transfer_group"] == null ? null : json["transfer_group"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "object": object == null ? null : object,
    "amount": amount == null ? null : amount,
    "amount_captured": amountCaptured == null ? null : amountCaptured,
    "amount_refunded": amountRefunded == null ? null : amountRefunded,
    "application": application,
    "application_fee": applicationFee,
    "application_fee_amount": applicationFeeAmount,
    "balance_transaction": balanceTransaction == null ? null : balanceTransaction,
    "billing_details": billingDetails == null ? null : billingDetails!.toJson(),
    "calculated_statement_descriptor": calculatedStatementDescriptor == null ? null : calculatedStatementDescriptor,
    "captured": captured == null ? null : captured,
    "created": created == null ? null : created,
    "currency": currency == null ? null : currency,
    "customer": customer == null ? null : customer,
    "description": description,
    "destination": destination,
    "dispute": dispute,
    "disputed": disputed == null ? null : disputed,
    "failure_code": failureCode,
    "failure_message": failureMessage,
    "fraud_details": fraudDetails == null ? null : List<dynamic>.from(fraudDetails!.map((x) => x)),
    "invoice": invoice,
    "livemode": livemode == null ? null : livemode,
    "metadata": metadata == null ? null : List<dynamic>.from(metadata!.map((x) => x)),
    "on_behalf_of": onBehalfOf,
    "order": order,
    "outcome": outcome == null ? null : outcome!.toJson(),
    "paid": paid == null ? null : paid,
    "payment_intent": paymentIntent == null ? null : paymentIntent,
    "payment_method": paymentMethod == null ? null : paymentMethod,
    "payment_method_details": paymentMethodDetails == null ? null : paymentMethodDetails!.toJson(),
    "receipt_email": receiptEmail,
    "receipt_number": receiptNumber,
    "receipt_url": receiptUrl == null ? null : receiptUrl,
    "refunded": refunded == null ? null : refunded,
    "refunds": refunds == null ? null : refunds!.toJson(),
    "review": review,
    "shipping": shipping,
    "source": source,
    "source_transfer": sourceTransfer,
    "statement_descriptor": statementDescriptor,
    "statement_descriptor_suffix": statementDescriptorSuffix,
    "status": status == null ? null : status,
    "transfer_data": transferData,
    "transfer_group": transferGroup == null ? null : transferGroup,
  };
}

class Charges {
  Charges({
    this.object,
    this.data,
    this.hasMore,
    this.totalCount,
    this.url,
  });

  String? object;
  List<Datum>? data;
  bool? hasMore;
  int? totalCount;
  String? url;

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
    object: json["object"] == null ? null : json["object"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    hasMore: json["has_more"] == null ? null : json["has_more"],
    totalCount: json["total_count"] == null ? null : json["total_count"],
    url: json["url"] == null ? null : json["url"],
  );

  Map<String, dynamic> toJson() => {
    "object": object == null ? null : object,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    "has_more": hasMore == null ? null : hasMore,
    "total_count": totalCount == null ? null : totalCount,
    "url": url == null ? null : url,
  };
}

class BillingDetails {
  BillingDetails({
    this.address,
    this.email,
    this.name,
    this.phone,
  });

  Address? address;
  dynamic email;
  dynamic name;
  dynamic phone;

  factory BillingDetails.fromJson(Map<String, dynamic> json) => BillingDetails(
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    email: json["email"],
    name: json["name"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "address": address == null ? null : address!.toJson(),
    "email": email,
    "name": name,
    "phone": phone,
  };
}

class Address {
  Address({
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.postalCode,
    this.state,
  });

  dynamic city;
  dynamic country;
  dynamic line1;
  dynamic line2;
  dynamic postalCode;
  dynamic state;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    city: json["city"],
    country: json["country"],
    line1: json["line1"],
    line2: json["line2"],
    postalCode: json["postal_code"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "country": country,
    "line1": line1,
    "line2": line2,
    "postal_code": postalCode,
    "state": state,
  };
}

class Outcome {
  Outcome({
    this.networkStatus,
    this.reason,
    this.riskLevel,
    this.riskScore,
    this.sellerMessage,
    this.type,
  });

  String? networkStatus;
  dynamic reason;
  String? riskLevel;
  int? riskScore;
  String? sellerMessage;
  String? type;

  factory Outcome.fromJson(Map<String, dynamic> json) => Outcome(
    networkStatus: json["network_status"] == null ? null : json["network_status"],
    reason: json["reason"],
    riskLevel: json["risk_level"] == null ? null : json["risk_level"],
    riskScore: json["risk_score"] == null ? null : json["risk_score"],
    sellerMessage: json["seller_message"] == null ? null : json["seller_message"],
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "network_status": networkStatus == null ? null : networkStatus,
    "reason": reason,
    "risk_level": riskLevel == null ? null : riskLevel,
    "risk_score": riskScore == null ? null : riskScore,
    "seller_message": sellerMessage == null ? null : sellerMessage,
    "type": type == null ? null : type,
  };
}

class PaymentMethodDetails {
  PaymentMethodDetails({
    this.card,
    this.type,
  });

  PaymentMethodDetailsCard? card;
  String? type;

  factory PaymentMethodDetails.fromJson(Map<String, dynamic> json) => PaymentMethodDetails(
    card: json["card"] == null ? null : PaymentMethodDetailsCard.fromJson(json["card"]),
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "card": card == null ? null : card!.toJson(),
    "type": type == null ? null : type,
  };
}

class PaymentMethodDetailsCard {
  PaymentMethodDetailsCard({
    this.brand,
    this.checks,
    this.country,
    this.expMonth,
    this.expYear,
    this.fingerprint,
    this.funding,
    this.installments,
    this.last4,
    this.network,
    this.threeDSecure,
    this.wallet,
  });

  String? brand;
  Checks? checks;
  String? country;
  int? expMonth;
  int? expYear;
  String? fingerprint;
  String? funding;
  dynamic installments;
  String? last4;
  String? network;
  dynamic threeDSecure;
  dynamic wallet;

  factory PaymentMethodDetailsCard.fromJson(Map<String, dynamic> json) => PaymentMethodDetailsCard(
    brand: json["brand"] == null ? null : json["brand"],
    checks: json["checks"] == null ? null : Checks.fromJson(json["checks"]),
    country: json["country"] == null ? null : json["country"],
    expMonth: json["exp_month"] == null ? null : json["exp_month"],
    expYear: json["exp_year"] == null ? null : json["exp_year"],
    fingerprint: json["fingerprint"] == null ? null : json["fingerprint"],
    funding: json["funding"] == null ? null : json["funding"],
    installments: json["installments"],
    last4: json["last4"] == null ? null : json["last4"],
    network: json["network"] == null ? null : json["network"],
    threeDSecure: json["three_d_secure"],
    wallet: json["wallet"],
  );

  Map<String, dynamic> toJson() => {
    "brand": brand == null ? null : brand,
    "checks": checks == null ? null : checks!.toJson(),
    "country": country == null ? null : country,
    "exp_month": expMonth == null ? null : expMonth,
    "exp_year": expYear == null ? null : expYear,
    "fingerprint": fingerprint == null ? null : fingerprint,
    "funding": funding == null ? null : funding,
    "installments": installments,
    "last4": last4 == null ? null : last4,
    "network": network == null ? null : network,
    "three_d_secure": threeDSecure,
    "wallet": wallet,
  };
}

class Checks {
  Checks({
    this.addressLine1Check,
    this.addressPostalCodeCheck,
    this.cvcCheck,
  });

  dynamic addressLine1Check;
  dynamic addressPostalCodeCheck;
  String? cvcCheck;

  factory Checks.fromJson(Map<String, dynamic> json) => Checks(
    addressLine1Check: json["address_line1_check"],
    addressPostalCodeCheck: json["address_postal_code_check"],
    cvcCheck: json["cvc_check"] == null ? null : json["cvc_check"],
  );

  Map<String, dynamic> toJson() => {
    "address_line1_check": addressLine1Check,
    "address_postal_code_check": addressPostalCodeCheck,
    "cvc_check": cvcCheck == null ? null : cvcCheck,
  };
}

class PaymentMethodOptions {
  PaymentMethodOptions({
    this.card,
  });

  PaymentMethodOptionsCard? card;

  factory PaymentMethodOptions.fromJson(Map<String, dynamic> json) => PaymentMethodOptions(
    card: json["card"] == null ? null : PaymentMethodOptionsCard.fromJson(json["card"]),
  );

  Map<String, dynamic> toJson() => {
    "card": card == null ? null : card!.toJson(),
  };
}

class PaymentMethodOptionsCard {
  PaymentMethodOptionsCard({
    this.installments,
    this.network,
    this.requestThreeDSecure,
  });

  dynamic installments;
  dynamic network;
  String? requestThreeDSecure;

  factory PaymentMethodOptionsCard.fromJson(Map<String, dynamic> json) => PaymentMethodOptionsCard(
    installments: json["installments"],
    network: json["network"],
    requestThreeDSecure: json["request_three_d_secure"] == null ? null : json["request_three_d_secure"],
  );

  Map<String, dynamic> toJson() => {
    "installments": installments,
    "network": network,
    "request_three_d_secure": requestThreeDSecure == null ? null : requestThreeDSecure,
  };
}
