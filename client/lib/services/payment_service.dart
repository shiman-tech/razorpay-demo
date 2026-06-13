import 'dart:convert';
import 'package:client/constants/api_constants.dart';
import 'package:client/models/create_order_response.dart';
import 'package:client/models/payment_verification_response.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String baseUrl = ApiConstants.baseUrl;


  Future<PaymentVerificationResponse> verifyPayment({required String orderId,required String paymentId, required String signature}) async{

    final response= await http.post(
      Uri.parse("$baseUrl/verify-payment"),
      headers:{
        "Content-type": "application/json"
      },
      body: jsonEncode({
        "razorpay_order_id": orderId,
        "razorpay_payment_id": paymentId,
        "razorpay_signature": signature
      })
    );

    if(response.statusCode<200 || response.statusCode>=300){
      debugPrint("Backend error: ${response.body}");
      throw Exception("Backend error: ${response.body}");
    }

    Map<String,dynamic> decodedJson= jsonDecode(response.body);

    return PaymentVerificationResponse.fromJson(decodedJson);

  }

  Future<CreateOrderResponse> createOrder(int amount) async {
    final response = await http.post(
      Uri.parse("$baseUrl/create-order"),
      headers: {
        "Content-type": "application/json"
      },
      body: jsonEncode({
        "amount": amount
      })
    );

    if(response.statusCode!=200){
      debugPrint("Backend error: ${response.body}");
      throw Exception("Backend error: ${response.body}");
    }

    Map<String,dynamic> decodedJson= jsonDecode(response.body);

    return CreateOrderResponse.fromJson(decodedJson);
  }
}
