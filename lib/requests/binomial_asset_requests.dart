import 'package:http/http.dart' as http;
import 'dart:convert';

class BinomialAssetRequest {
  static Future<void> sendBinomialAssetRequest() async {
    final url = Uri.parse('http://127.0.0.1:8000/binomial_asset/');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "u": 0.5,
      "v": 0.5,
      "s": 100,
      "numSteps": 10
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error making request: $e');
    }
  }
}
