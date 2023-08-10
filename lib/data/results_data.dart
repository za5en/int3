class Result {
  Result({
    required this.header,
    required this.text,
    required this.url,
  });

  List<String> header;
  List<String> text;
  List<String> url;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        url: List<String>.from(json["url"].map((x) => x.toString())),
        header: List<String>.from(json["header"].map((x) => x.toString())),
        text: List<String>.from(json["text"].map((x) => x.toString())),
      );

  Map<String, dynamic> toJson() => {
        "header": header,
        "text": text,
        "url": url,
      };
}
