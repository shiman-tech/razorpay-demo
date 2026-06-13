import 'package:client/constants/api_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestService {
  static const String backendUrl = ApiConstants.baseUrl;

  Future<Map<String, dynamic>> testRequest(String mssg) async {
    try {
      debugPrint("Sending request...");

      final response = await http.post(
        Uri.parse("$backendUrl/test"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mssg": mssg}),
      );
      debugPrint("Status: ${response.statusCode}");
      debugPrint("Body: ${response.body}");
    } catch (e) {
      debugPrint("ERROR: $e");
    }

    return {"mssg": "Success"};
  }
}
