import 'package:youyu/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class IMGifModel implements BaseModel {
  //gif名称
  final String name;
  //是否显示结束的画面
  final bool? isShowEnd;

  IMGifModel({required this.name, required this.isShowEnd});

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name,'isShowEnd':isShowEnd};

  static IMGifModel fromJson(Map<String, dynamic> json) =>
      IMGifModel(name: json['name'], isShowEnd: json['isShowEnd'] as bool?);
}
