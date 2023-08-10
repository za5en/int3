import 'package:http/http.dart' as http;
import 'package:the_basics/api.dart';

class RemoteIndexSevices {
  const RemoteIndexSevices();
  final _apiClient = const ApiClient();

  Future<http.Response> indexPage(
      String url, String header, String indexedText) async {
    final response = await _apiClient.postRequest(
      path: '/page/indexing',
      body: {
        'url': url,
        'header': header,
        'text': indexedText,
      },
    );
    return response;
  }
}
