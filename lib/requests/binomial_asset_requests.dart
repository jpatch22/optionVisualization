import 'package:http/http.dart' as http;
import 'dart:convert';

class BinomialAssetRequest {
  static Future<void> sendBinomialAssetRequest(
    double s,
    int numSteps,
    double u,
    double v,
  ) async {
    print("Sending request");
    final url = Uri.parse("http://127.0.0.1:8000/binomial_asset/");
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "u": .5,
      "v": .5,
      "s": 10,
      "numSteps": 10
    });
    print("$url");
    print("$headers");

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

  static Future<void> sendBinomialAssetDriftRequest(
    double s,
    int numSteps,
    double vol,
    double dt,
  ) async {
    final url = Uri.parse('http://10.0.0.141:8000/binomial_asset/');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "vol": vol,
      "dt": dt,
      "s": s,
      "numSteps": numSteps
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
