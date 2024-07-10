import 'package:http/http.dart' as http;
import 'package:option_visualizer/constants/constants.dart';
import 'dart:convert';
import 'package:option_visualizer/models/row_data_extend.dart';
import 'package:option_visualizer/utils/util.dart';

class BsOpValRequest {
  static Future<String?> getOptionValues(
    List<RowDataExtended> options, 
    double r, 
    double volatility,
    double stockPrice
  ) async {
    final url = Uri.parse(Constants.baseUrl + Constants.bsOpValEndpoint);
    final headers = {"Content-Type": "application/json"};
    List<Map<String, dynamic>> optionsJson = options.map((option) => option.toJson()).toList();
    print(optionsJson);
    final body = jsonEncode({
      "r": r,
      "sigma": volatility,
      "s": stockPrice,
      "options": optionsJson
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        // print(jsonDecode(response.body)['time']);
        // print("respone :${response.body}");
        return response.body;
      } else {
        print("Response error code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      return null; 
    }

  }
}