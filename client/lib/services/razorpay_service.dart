import 'package:client/services/payment_service.dart';
import 'package:flutter/widgets.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {

  void dispose() {
  razorpay.clear();
}

  final Razorpay razorpay = Razorpay();


  VoidCallback? _onVerified;
  VoidCallback? _onFailure;

  final PaymentService paymentService;

  RazorpayService({required this.paymentService}) {
    debugPrint("Razorpay service created");

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    //razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint("Payment successful");

    debugPrint("Payment ID: ${response.paymentId}");

    debugPrint("Order ID: ${response.orderId}");

    debugPrint("Signature: ${response.signature}");

    try {
      final res = await paymentService.verifyPayment(
        paymentId: response.paymentId!,
        orderId: response.orderId!,
        signature: response.signature!,
      );

      debugPrint("Verified: ${res.verified}");

      if (res.verified == true) {
        _onVerified?.call();
      }
      if (res.error != null) {
        debugPrint("Verification Error: ${res.error}");
        _onFailure?.call();
        
      }
    } catch (e) {
      debugPrint("Verification Error: $e");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment failed");

    debugPrint("Code: ${response.code}");

    debugPrint("Message: ${response.message}");

    _onFailure?.call();
  }

  Future<void> startPayment({required VoidCallback onVerified, required VoidCallback onFailure}) async {
    _onVerified = onVerified;
    _onFailure=onFailure;
    final order = await paymentService.createOrder(500);

    final options = {
      "key": "rzp_test_Szt5PUWaZRqcos",
      "amount": order.amount,
      "order_id": order.id,
      "name": "Shiman Kumar D",
      "description": "me broke so pay :)",
    };

    razorpay.open(options);
  }
}
