class PaymentVerificationResponse {

  final bool verified;
  final String? error;
 

  PaymentVerificationResponse({
    required this.verified,
    this.error
  });

  factory PaymentVerificationResponse.fromJson(Map<String,dynamic> json){

    return PaymentVerificationResponse(verified: json["verified"], error: json["error"]);
  }

}