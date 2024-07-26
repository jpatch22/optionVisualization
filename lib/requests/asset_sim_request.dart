import 'package:option_visualizer/utils/util.dart';

import '../constants/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssetSimRequest {
  static Future<List<List<double>>?> sendAssSimReq(
    double stockPrice,
    double time,
    double vol,
    double drift,
    int N,
  ) async {
    final url = Uri.parse(Constants.baseUrl + Constants.assetSimEndpoint);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "s0": stockPrice,
      "N": N,
      "sigma": vol,
      "T": time,
      "drift": drift,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        List<List<double>> assetPrices = Utils.parse2DArrayFromJson(response.body, "assetPrices");
        return assetPrices;
      } else {
        return null;
      }
    } catch (e) {
      print("Response $e");
      return null;
    }
  }
}