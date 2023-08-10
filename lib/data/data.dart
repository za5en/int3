import 'dart:convert';

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  bool isSuccess;
  String message;
  dynamic data;

  factory Data.fromJson(String jsonString) {
    var jsonData = json.decode(jsonString);
    return Data(
      isSuccess: jsonData["status"] == 'SUCCESS',
      message: jsonData["message"],
      data: jsonData["data"],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": isSuccess.toString(),
        "message": message,
        "data": data,
      };
}
