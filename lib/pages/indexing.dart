import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import '../controllers/index_controller.dart';

const List<String> indexType = <String>['Manual', 'Auto'];

class AddFormController extends GetxController {
  RxBool manual = true.obs;
}

class Indexing extends StatefulWidget {
  const Indexing({super.key});

  @override
  State<Indexing> createState() => _IndexingState();
}

class _IndexingState extends State<Indexing> {
  String dropdownValue = indexType.first;
  final htmlController = TextEditingController();
  final saveLinkController = TextEditingController();
  final parseLinkController = TextEditingController();
  final stepsController = TextEditingController();
  bool fieldValidation = false;

  indexing(IndexController indexController) async {
    String pattern =
        r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
    RegExp regExp = RegExp(pattern);
    var header = "";
    var indexedText = "";
    if (htmlController.text.isEmpty || saveLinkController.text.isEmpty) {
      fieldValidation = false;
      const snackBar = SnackBar(
        content: Text('Ошибка! Заполните все поля'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (!(regExp.hasMatch(saveLinkController.text))) {
      fieldValidation = false;
      const snackBar = SnackBar(
        content: Text(
            'Ошибка! Ссылка должна быть указана в формате "https://site.com/"'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      fieldValidation = true;
      var link = saveLinkController.text.toString().trim();
      var html = htmlController.text.toString().trim();
      var manualIndex = true;
      parseHTML(html, header, indexedText, link, indexController, manualIndex);
    }
  }

  parseHTML(String html, String header, String indexedText, String link,
      IndexController indexController, bool manualIndex) {
    var title1 = '<title';
    var title2 = '>';
    var title3 = '</title>';
    var titleStartIndex = html.indexOf(title1);
    var titleStartEndIndex =
        html.indexOf(title2, titleStartIndex + title1.length);
    var titleEndIndex = html.indexOf(title3, titleStartEndIndex);

    print(titleStartEndIndex);

    if (titleStartIndex != -1 &&
        titleStartEndIndex != -1 &&
        titleEndIndex != -1) {
      var headerNew =
          html.substring(titleStartEndIndex + 1, titleEndIndex).trim();
      header = headerNew.replaceAll('\n', '');

      var body1 = '<body';
      var body2 = '>';
      var body3 = '</body>';
      var bodyStartIndex = html.indexOf(body1);
      var bodyStartEndIndex =
          html.indexOf(body2, bodyStartIndex + body1.length);
      var bodyEndIndex = html.indexOf(body3, bodyStartEndIndex);

      if (bodyStartIndex != -1 &&
          bodyStartEndIndex != -1 &&
          bodyEndIndex != -1) {
        var body = html.substring(bodyStartEndIndex + 1, bodyEndIndex).trim();
        indexedText = _parseHtmlString(body);
        var bodyNew = indexedText.replaceAll('   ', ' ');
        indexedText = bodyNew.replaceAll('  ', ' ');

        if (manualIndex) {
          if (htmlController.text.isNotEmpty &&
              saveLinkController.text.isNotEmpty) {
            indexController.indexing(link, header, indexedText, context);
            htmlController.clear();
            saveLinkController.clear();
          } else if (parseLinkController.text.isNotEmpty) {
            indexController.indexing(link, header, indexedText, context);
            parseLinkController.clear();
          }
        }
      } else {
        const snackBar = SnackBar(
          content: Text('Ошибка! Отсутствует тэг body'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      const snackBar = SnackBar(
        content: Text('Ошибка! Отсутствует тэг title'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    AddFormController controller = Get.put(AddFormController());
    var indexController = Get.find<IndexController>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('indexing page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(color: Colors.blue),
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                  dropdownValue == 'Manual'
                      ? controller.manual.value = true
                      : controller.manual.value = false;
                });
              },
              items: indexType.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Obx(() => controller.manual.value == true
                ? Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 20.0),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 15,
                        controller: htmlController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'type your html code',
                          errorText:
                              fieldValidation ? 'field can\'t be empty' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 20.0),
                      child: TextField(
                        controller: saveLinkController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'type url of your page',
                          errorText:
                              fieldValidation ? 'field can\'t be empty' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () async {
                        await indexing(indexController);
                      },
                      child: const Text('submit page indexing'),
                    )
                  ])
                : Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: parseLinkController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'type url here',
                          errorText:
                              fieldValidation ? 'field can\'t be empty' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: stepsController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'type index steps',
                          errorText:
                              fieldValidation ? 'field can\'t be empty' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () async {
                        String pattern =
                            r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
                        RegExp regExp = RegExp(pattern);
                        if (parseLinkController.text.isEmpty
                            // || stepsController.text.isEmpty ||
                            // stepsController.text == '0'
                            ) {
                          fieldValidation = false;
                        } else if (!(regExp
                            .hasMatch(parseLinkController.text))) {
                          fieldValidation = false;
                          const snackBar = SnackBar(
                            content: Text(
                                'Ошибка! Ссылка должна быть указана в формате "https://site.com/"'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          fieldValidation = true;
                          var url = parseLinkController.text;
                          //var steps = stepsController.text;
                          var response = await http
                              .get(Uri.parse(parseLinkController.text));
                          if (response.statusCode == 200) {
                            String htmlToParse = response.body;
                            var header = "";
                            var indexedText = "";
                            var manualIndex = false;
                            parseHTML(htmlToParse, header, indexedText, url,
                                indexController, manualIndex);
                          }
                        }
                      },
                      child: const Text('submit page indexing'),
                    )
                  ])),
          ],
        ),
      ),
    );
  }
}

String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}
