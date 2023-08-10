import 'package:get/get.dart';
import 'package:the_basics/data/results_data.dart';
import 'package:the_basics/services/remote_result_services.dart';

import '../data/data.dart';

class ResultController extends GetxController {
  final _remoteResultServices = const RemoteResultSevices();
  var _result = Result(
      header: ['null', 'null'], text: ['null', 'null'], url: ['null', 'null']);
  //final _resultsData = <Result>[].obs;

  Result get result => _result;
  //List<Result> get resultsData => _resultsData;

  search(String requestText) async {
    var response = await _remoteResultServices.searchRequest(requestText);
    var data = Data.fromJson(response.body);
    if (data.isSuccess) {
      _result = Result.fromJson(data.data);
    } else {
      Get.snackbar('Error', data.message);
    }
  }
}
