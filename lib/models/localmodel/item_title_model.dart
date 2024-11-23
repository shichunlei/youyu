import 'dart:convert';

///公用列表item模型
// class ItemTitleModel<T> {
//   ItemTitleModel({this.type, this.title = "", this.subTitle, this.extra});

//   dynamic type;
//   String title;
//   String? subTitle;
//   T? extra;
// }

ItemTitleModel itemTitleModelFromJson(String str) =>
    ItemTitleModel.fromJson(json.decode(str));

String itemTitleModelToJson(ItemTitleModel data) => json.encode(data.toJson());

class ItemTitleModel<T> {
  dynamic type;
  String? subTitle;
  String title;
  T? extra;

  ItemTitleModel({
    this.type,
    this.subTitle,
    this.title = "",
    this.extra,
  });

  factory ItemTitleModel.fromJson(Map<String, dynamic> json) => ItemTitleModel(
        subTitle: json["subTitle"],
        title: json["title"],
        extra: json["extra"],
      );

  Map<String, dynamic> toJson() => {
        "subTitle": subTitle,
        "title": title,
        "extra": extra,
      };
}
