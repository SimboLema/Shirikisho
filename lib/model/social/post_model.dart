import 'dart:convert';


postModule postFromJson(String str) => postModule.fromJson(json.decode(str));

String postToJson(postModule data) => json.encode(data.toJson());

class postModule {
  postModule({
    required this.text,
    required this.file,
  });

  int text;
  String? file;

  factory postModule.fromJson(Map<String, dynamic> json) => postModule(
    text: json["text"],
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "text":    text,
    "file":  file,
  };
}
