import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListViewBuilder extends StatefulWidget {
  final List<String> headers;
  final List<String> links;
  final List<String> desc;

  const ListViewBuilder(
      {Key? key,
      required this.headers,
      required this.links,
      required this.desc})
      : super(key: key);

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: widget.headers.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 140,
            decoration: BoxDecoration(
              color: Theme.of(context).listTileTheme.tileColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Card(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 2.0, bottom: 4.0),
                    child: InkWell(
                      onTap: () {
                        launchUrl(Uri.parse(widget.links[index]));
                      },
                      child: Text(
                        widget.headers[index],
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      widget.links[index],
                      style: const TextStyle(fontSize: 10.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      widget.desc[index],
                    ),
                  ),
                ])),
          );
        },
      ),
    );
  }
}
