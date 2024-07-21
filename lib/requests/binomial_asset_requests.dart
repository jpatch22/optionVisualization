import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/util.dart';
import '../constants/constants.dart';

class BinomialAssetRequest {
  static Future<List<List<double>>?> sendBinomialAssetRequest(
    double s,
    int numSteps,
    double u,
    double v,
  ) async {
    final url = Uri.parse(Constants.baseUrl + Constants.binEndpoint);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "u": u,
      "v": v,
      "s0": s,
      "N": numSteps
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        List<List<double>> assetPrices = Utils.parseAssetPrices(response.body, "assetPrices");
        return assetPrices;
      } else {
        print("Response error code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      return null; 
    }
  }

  static Future<List<List<double>>?> sendBinomialAssetDriftRequest(
    double s,
    int numSteps,
    double vol,
    double T,
  ) async {
    final url = Uri.parse(Constants.baseUrl + Constants.baseUrl);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "sigma": vol,
      "T": T,
      "s0": s,
      "N": numSteps
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        List<List<double>> assetPrices = Utils.parseAssetPrices(response.body, "assetPrices");
        return assetPrices;
      } else {
        print("Response error code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
