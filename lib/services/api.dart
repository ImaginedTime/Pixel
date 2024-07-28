import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:developer';

class API {
  final String API_URL = 'https://pixabay.com/api/?key=44254249-0ae00cfeb93f276a596342ba8';

  String formatUrl(Map<String, dynamic> params) {
    String url = "$API_URL&per_page=30";

    if (params.isEmpty) {
      return url;
    }

    params.forEach((key, value) {
      String? value = key == 'q' ? Uri.encodeComponent(params[key]!) : params[key];
      if(value != "") {
        url += "&$key=$value";
      }
    });

    log(url);

    return url;
  }

  Future<Map<String, dynamic>> fetchFromPixabay(dynamic params) async {
    try {
      final response = await http.get(Uri.parse(formatUrl(params)));
      return {
        'success': true,
        'data': json.decode(response.body)
      };
    } catch (error) {
      log(error.toString());
      return {'success': false, 'msg': error.toString()};
    }
  }
}
