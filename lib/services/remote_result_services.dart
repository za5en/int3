import 'package:http/http.dart' as http;
import 'package:the_basics/api.dart';

class RemoteResultSevices {
  const RemoteResultSevices();
  final _apiClient = const ApiClient();

  Future<http.Response> searchRequest(String requestText) async {
    var path = '/page/search?request=$requestText';
    final response = _apiClient.getRequest(path: path);
    return response;
  }
}
