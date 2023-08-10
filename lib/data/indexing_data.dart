class Index {
  Index({
    required this.id,
  });

  int id;

  factory Index.fromJson(Map<String, dynamic> json) => Index(
        id: json["id"],
      );
}
