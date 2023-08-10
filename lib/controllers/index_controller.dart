import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/data.dart';
import '../services/remote_index_services.dart';

class IndexController extends GetxController {
  final _remoteIndexServices = const RemoteIndexSevices();
  var _index = 0;

  indexing(String url, String header, String indexedText,
      BuildContext context) async {
    var response =
        await _remoteIndexServices.indexPage(url, header, indexedText);
    var data = Data.fromJson(response.body);
    if (data.isSuccess) {
      _index = data.data['id'];
      var snackBar = SnackBar(
        content: Text('новая страница успешно добавлена, id: $_index'),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      var snackBar = SnackBar(
        content: Text('ошибка! ${data.data['errorMessage']}'),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
