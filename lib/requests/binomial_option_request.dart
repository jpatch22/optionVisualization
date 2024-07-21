import 'package:http/http.dart' as http;
import 'package:option_visualizer/constants/constants.dart';
import 'dart:convert';
import '../utils/util.dart';

class BinomialOptionRequest {
  static Future<List<List<double>>?> sendBinomialOptionRequest(
    double s,
    int numSteps,
    double u,
    double v,
    double sigma,
    double K,
    double r,
    double T,
    String optionType
  ) async {
    final url = Uri.parse(Constants.baseUrl + Constants.binOpEndpoint);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "u": u,
      "v": v,
      "s0": s,
      "N": numSteps,
      "K": K,
      "sigma": sigma,
      "r": r,
      "T": T,
      "optionType": optionType
    });
    print("The body is $body");

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("response : ${response.statusCode} :: ${response.body}");
        List<List<double>> assetPrices = Utils.parseAssetPrices(response.body, "optionPrices");
        return assetPrices;
      } else {
        return null;
      }
    } catch (e) {
      print("Response $e");
      return null;
    }
  }

  static Future<List<List<double>>?> sendBinomialOptionsVolRequest(
    double s,
    int numSteps,
    double vol,
    double T,
    double sigma,
    double K,
    double r,
    String optionType
  ) async {
    final url = Uri.parse(Constants.baseUrl + Constants.binOpEndpoint);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "sigma": vol,
      "T": T,
      "s0": s,
      "N": numSteps,
      "K": K,
      "r": r,
      "optionType": optionType
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        List<List<double>> assetPrices = Utils.parseAssetPrices(response.body, "optionPrices");
        return assetPrices;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
