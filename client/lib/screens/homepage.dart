import 'package:client/services/payment_service.dart';
import 'package:client/services/razorpay_service.dart';
import 'package:client/services/test_service.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PaymentService paymentService = PaymentService();
  late final RazorpayService razorpayService;

  @override
  void initState() {
    super.initState();
    razorpayService = RazorpayService(paymentService: paymentService);
  }

  @override
  void dispose() {
    razorpayService.dispose();
    super.dispose();
  }

  String result = "Start Payment : 500/-";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Home Page"))),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(result),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                await razorpayService.startPayment(
                  onVerified: () {
                    setState(() {
                      result = "Payment Verified";
                    });
                  },
                  onFailure: () {
                    setState(() {
                      result = "Payment Failed";
                    });
                  },
                );
              },
              child: Text("Order"),
            ),
          ],
        ),
      ),
    );
  }
}
