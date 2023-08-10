import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_basics/res_model.dart';
import 'package:the_basics/result_param.dart';

import 'controllers/index_controller.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final textController = TextEditingController();
  bool validation = false;
  ResModel resModel = ResModel([], [], []);

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  request() async {
    var text = textController.text.toString().trim();
    var response = await http
        .get(Uri.parse('http://localhost:5000/api/page/search?request=$text'));

    var data = json.decode(response.body);
    if (data['url'].length > 0) {
      const snackBar = SnackBar(
        content: Text('успешно загружено'),
      );
      for (int i = 0; i < data['url'].length; i++) {
        var url = data['url'][i].toString();
        var protocol = 'http://';
        var protocolS = 'https://';
        if (!url.contains(protocolS) && !url.contains(protocol)) {
          url = 'https://$url';
        }
        resModel.url.add(url);
        resModel.header.add(data['header'][i].toString());
        resModel.text.add(data['text'][i].toString());
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushNamed(context, '/results',
            arguments:
                ResultParams(resModel: resModel, request: textController.text));
      }
    } else {
      const snackBar = SnackBar(
        content: Text('ничего не найдено! попробуйте другой запрос'),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'type your request here',
                  errorText: validation ? 'field can\'t be empty' : null,
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                if (textController.text.isEmpty) {
                  validation = false;
                  const snackBar = SnackBar(
                    content: Text('ошибка! нельзя отправить пустой запрос'),
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                } else {
                  validation = true;
                  resModel = ResModel([], [], []);
                  await request();
                }
              },
              child: const Text('let\'s search!'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.put(IndexController());
          Navigator.pushNamed(context, '/indexing');
        },
        backgroundColor: Colors.blue,
        label: const Text('Index'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
