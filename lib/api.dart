//get for results
//post for indexing

import 'dart:developer';

import 'package:http/http.dart' as http;

class ApiClient {
  static const ip = 'http://localhost:5000/api';
  static final client = http.Client();
  const ApiClient();

  Future<http.Response> getRequest(
      {required String path, bool addIp = true}) async {
    try {
      final url = Uri.parse((addIp ? ip : '') + path);
      final response = await client.get(url);
      log((addIp ? ip : '') + path);
      log(response.body);
      log(response.request.toString());

      switch (response.statusCode) {
        case 200:
          return response;
        default:
          throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<http.Response> postRequest(
      {required String path, Object? body, bool addIp = true}) async {
    final url = Uri.parse((addIp ? ip : '') + path);
    var response = await client.post(
      url,
      body: body,
    );
    log(ip + path);
    log(response.statusCode.toString());
    log(response.body);
    log(response.request.toString());
    // return response;
    switch (response.statusCode) {
      case 200:
        return response;
      default:
        throw Exception(response.reasonPhrase);
    }
  }
}
