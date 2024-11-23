import 'package:youyu/models/banner_model.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'recommend_list_model.g.dart';

@JsonSerializable()
class RecommendListModel implements BaseModel {

  //banner
  List<BannerModel>?banner;
  //hotData
  @JsonKey(name: 'list')
  List<RoomListItem>? list;

  RecommendListModel({
    this.banner,
    this.list,
  });

  @override
  factory RecommendListModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendListModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$RecommendListModelToJson(this);
}
