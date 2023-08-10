import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:the_basics/result_param.dart';

//import '../controllers/results_controller.dart';
import '../widgets/t_listview.dart';

class Results extends StatefulWidget {
  const Results({super.key});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  //var resultController = Get.find<ResultController>();
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ResultParams;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(args.request),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ListViewBuilder(
                  headers: args.resModel.header,
                  links: args.resModel.url,
                  desc: args.resModel.text),
            ],
          ),
        ),
      ),
    );
  }
}
