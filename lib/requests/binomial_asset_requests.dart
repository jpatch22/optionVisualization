import 'package:http/http.dart' as http;
import 'dart:convert';

class BinomialAssetRequest {
  static Future<List<List<double>>?> sendBinomialAssetRequest(
    double s,
    int numSteps,
    double u,
    double v,
  ) async {
    final url = Uri.parse("http://127.0.0.1:8000/binomial_asset/");
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "u": .5,
      "v": .5,
      "s": 10,
      "numSteps": 7
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        List<List<double>> assetPrices = parseAssetPrices(response.body);
        return assetPrices;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print('Error making request: $e');
      return null;
    }
  }

  static Future<List<List<double>>?> sendBinomialAssetDriftRequest(
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
        List<List<double>> assetPrices = parseAssetPrices(response.body);
        print('Response data: ${response.body}');
        return assetPrices;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print('Error making request: $e');
      return null;
    }
  }

  static List<List<double>> parseAssetPrices(String jsonString) {
    final jsonResponse = json.decode(jsonString);
    final assetPricesJson = jsonResponse['asset_prices'] as List<dynamic>;

    List<List<double>> assetPrices = assetPricesJson.map((row) {
      return (row as List<dynamic>).map((value) => value as double).toList();
    }).toList();

    return assetPrices;
  }
}
